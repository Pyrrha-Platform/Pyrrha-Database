# Pyrrha database

This repository contains the [Pyrrha](https://github.com/Pyrrha-Platform/Pyrrha) solution application database that manages sensor readings over time. It targets MariaDB.

[![License](https://img.shields.io/badge/License-Apache2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0) [![Slack](https://img.shields.io/badge/Join-Slack-blue)](https://callforcode.org/slack)

## Setting up the solution

### Locally using Docker

1. Set the environment variable
   
   All commands shown below use the environment variable MDB_PASSWORD that contains the MariaDB password. You should change it to your own secure password.
    ```
    export MDB_PASSWORD=my-secret-pw
    ```

2. Run the container

    MariaDB is available as an image on [DockerHub](https://hub.docker.com/_/mariadb/). Use the following command to download the image and run a container that listens on port 3306. The command also mounts the `$PWD/data` directory to `/var/lib/mysql`. This makes it easier to load data later.
    
    ```
    docker run --name mariadb -v $PWD/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=${MDB_PASSWORD} -p 3306:3306 -d mariadb
    ```

    The startup configuration is specified in the file /etc/mysql/my.cnf. If you want to use a customized MariaDB configuration, you can create your alternative configuration file in a directory on the host machine and then mount that directory location as /etc/mysql/conf.d inside the mariadb container as follows:
     - $PWD/mdbconfig:/etc/mysql/conf.d - store configuration

    When using a host mount with SELinux, you need to pass an extra option `:z` or `:Z` to the end of the volume definition:

    - The z option indicates that the bind mount content is shared among multiple containers.
    - The Z option indicates that the bind mount content is private and unshared.

    You can learn more in the official [Docker guide](https://docs.docker.com/storage/bind-mounts/#configure-the-selinux-label). This [Stack Overflow answer](https://stackoverflow.com/a/31334443/898954) has more details.

    ```
    docker run --name mariadb -v $PWD/data:/var/lib/mysql:Z -e MYSQL_ROOT_PASSWORD=${MDB_PASSWORD} -p 3306:3306 -d mariadb
    ```

3. Confirm container started properly

    You can confirm the container is running by using the `docker ps` command:
    ```
    ❯ docker ps                                                                            
    CONTAINER ID  IMAGE                             COMMAND               CREATED         STATUS             PORTS                   NAMES                            ws
    9f16930dcb23  docker.io/library/mariadb:latest  mysqld                11 minutes ago  Up 11 minutes ago  0.0.0.0:3306->3306/tcp  mariadb
    ```
    
    You can check the sql file was mounted by using the following command:

    ```
    docker exec -it mariadb ls /var/lib/mysql
    ```

    You should see `prometeo.sql` file along with other mariadb files in the output:

    ```
    aria_log.00000001  ib_logfile0  multi-master.info   prometeo.sql
    aria_log_control   ibdata1      mysql
    ib_buffer_pool     ibtmp1       performance_schema

    ```

    You can now execute mysql commands as shown here:
    ```
    docker exec -t mariadb mysql -uroot -p${MDB_PASSWORD} -e 'show databases;'
    ```

    Output: 
    ```
    +--------------------+
    | Database           |
    +--------------------+
    | data               |
    | information_schema |
    | mysql              |
    | performance_schema |
    +--------------------+
    ```

1. Load the sql data

    Set the `log_bin_trust_function_creators` flag to 1 in order to successfully create the stored procedures without having a SUPER privilege.
    ```
    docker exec -t mariadb mysql -uroot -p${MDB_PASSWORD} -e 'SET GLOBAL log_bin_trust_function_creators = 1;'
    ```

    You can now load the .sql file as follows:
    ```
    docker exec -t mariadb mysql -uroot -p${MDB_PASSWORD} -e 'source /var/lib/mysql/prometeo.sql;'
    ```

2. Verify the database

    You should be able to see the Prometeo database:

    ```
    docker exec -t mariadb mysql -uroot -p${MDB_PASSWORD} -e 'show databases;'
    ```

    Output:
    ```
    +--------------------+
    | Database           |
    +--------------------+
    | data               |
    | information_schema |
    | mysql              |
    | performance_schema |
    | prometeo           |
    +--------------------+
    ```

    You can also list all the tables in the pyrrha database:
    ```
    docker exec -t mariadb mysql -uroot -p${MDB_PASSWORD} -e 'use prometeo; show tables;'
    ```

    Output:
    ```
    +------------------------------+
    | Tables_in_prometeo           |
    +------------------------------+
    | event_types                  |
    | events                       |
    | events_firefighters_devices  |
    | feedback                     |
    | firefighter_sensor_log       |
    | firefighter_status_analytics |
    | firefighters                 |
    | fuel_types                   |
    | sensors                      |
    | status                       |
    | user_types                   |
    | users                        |
    +------------------------------+
    ```

    You are ready to go! You can talk to the database by using localhost:3306. If you have `mysql` available on the host machine, use the following command to connect:
    ```
    mysql -u root -p${MDB_PASSWORD} --host localhost --port 3306 --protocol=tcp
    ```

### IKS (IBM Kubernetes Service)

1. Sign up for [IBM Cloud](https://cloud.ibm.com/registration) or log in with your existing account.

2. Create an IBM Kubernetes Cluster (IKS) from the [catalog](https://cloud.ibm.com/kubernetes/catalog/create).

3. Add [IBM Cloud Block Storage plug-in](https://cloud.ibm.com/catalog/content/ibmcloud-block-storage-plugin-51baa72d-be9b-487a-8e77-02577d2b5b21-global) from the catalog to your cluster in the default namespace. You need this plugin to use persistance volumes and persistance volume claims on IKS. 

4. Log into your cluster by following these [steps](https://cloud.ibm.com/docs/containers?topic=containers-access_cluster)

    You can verify that you have the correct context by using this command:
    ```
    ❯ kubectl config current-context
    ```
    You should see an output like `<cluster_name>/<cluster_ID>`.

5. Add password to `kubernetes/mariadb-secret.yaml` file. You need to get the base 64 encoded password first by using the following command:
    ```
    ❯ echo -n ${MDB_PASSWORD} | base64
    ```
    There are three passwords in the secret yaml file. You can create different passwords for each one.
    - mariadb-root-password:
    - mariadb-replication-password:
    - mariadb-user-password:

6. Add bitnami helm repo locally
    ```
    ❯ helm repo add bitnami https://charts.bitnami.com/bitnami
    ```

7. Apply the secret file `kubernetes/mariadb-secret-sample.yaml`. The pods will not run unless you apply this secret with the correct base64 encoded credentials.

    ```
    ❯ kubectl apply -f kubernetes/mariadb-secret-sample.yaml
    secret/mariadb created
    ```
    You can verify that the secret was created successfully.

    ```
    ❯ kubectl get secret
    NAME                            TYPE                                  DATA   AGE
    mariadb                         Opaque                                3      2m33s
    ```

8. Apply the helm chart with the `values-production.yaml` file.

    ```
    ❯ helm install mariadb bitnami/mariadb -f kubernetes/values-production.yaml

    NAME: mariadb
    LAST DEPLOYED: Wed Dec 30 14:43:07 2020
    NAMESPACE: staging
    STATUS: deployed
    REVISION: 1
    TEST SUITE: None
    NOTES:
    Please be patient while the chart is being deployed
    ```

    You should see the primary and secondary pods running after some time. The chart first creates the persistent volume claims first before creatings the pods and services

    ```
    ❯ kubectl get pods
    NAME                  READY   STATUS    RESTARTS   AGE
    mariadb-primary-0     1/1     Running   0          8m18s
    mariadb-secondary-0   1/1     Running   0          8m18s
    ```

9. Copy the sql data file to the primary pod.

    ```
    ❯ kubectl cp data/pyrrha.sql mariadb-primary-0:/tmp/pyrrha.sql
    ```

    Check if the file is present in the container
    ```
    ❯ kubectl exec -it mariadb-primary-0 -- ls /tmp
    pyrrha.sql
    ```

10. Load the data into the database.

    First, set permissions so your can load the sql without having root privileges:
    ```
    ❯ kubectl exec mariadb-primary-0 -- mysql -uroot -p${MDB_PASSWORD} -e 'SET GLOBAL log_bin_trust_function_creators = 1;'
    ```

    Next, load the sql file
    ```
    ❯ kubectl exec -it mariadb-primary-0 -- mysql -uroot -p${MDB_PASSWORD} -e 'source /tmp/pyrrha.sql;'
    ```

    You just deployed MariaDB On IBM Cloud Kubernetes Services and loaded the pyrrha tables and stored procedures. You can see the tables with the following command:

    ```
    ❯ kubectl exec mariadb-primary-0 -- mysql -uroot -p${MDB_PASSWORD} -e 'use pyrrha; show tables'
    ```

    ```
    Tables_in_pyrrha
    event_types
    events
    events_firefighters_devices
    feedback
    firefighter_sensor_log
    firefighter_status_analytics
    firefighters
    fuel_types
    sensors
    status
    user_types
    users
    ```

## Uninstall MariaDB
1. Remove the helm chart
    ```
    helm uninstall mariadb
    ```
2. Remove the persistent volume claims:
    ```
    kubectl delete pvc data-mariadb-primary-0

    kubectl delete pvc data-mariadb-secondary-0
    ```
3. Remove the secret:
    ```
    kubectl delete secret mariadb
    ```

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting Pyrrha pull requests.

## License

This project is licensed under the Apache 2 License - see the [LICENSE](LICENSE) file for details.
