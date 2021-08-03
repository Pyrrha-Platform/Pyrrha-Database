# Pyrrha database

[![License](https://img.shields.io/badge/License-Apache2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0) [![Slack](https://img.shields.io/static/v1?label=Slack&message=%23prometeo-pyrrha&color=blue)](https://callforcode.org/slack)

This repository contains the [Pyrrha](https://github.com/Pyrrha-Platform/Pyrrha) solution application database that manages sensor readings over time. It uses [MariaDB](https://mariadb.org/) though you can also use MySQL.

- [Setting up the solution](#setting-up-the-solution)
  - [Locally using Docker](#locally-using-docker)
  - [IKS (IBM Kubernetes Service)](#iks-ibm-kubernetes-service)
- [Troubleshooting](#troubleshooting)
  - [Changing password](#changing-password)
- [Uninstall MariaDB](#uninstall-mariadb)
- [Contributing](#contributing)
- [License](#license)

## Setting up the solution

### Locally using Docker

The following steps assume you have [Git](https://git-scm.com/) and [Docker](https://www.docker.com/) installed on your machine.

1. Git clone this repo and change into root directory

   ```bash
   git clone https://github.com/Pyrrha-Platform/Pyrrha-Database && cd Pyrrha-Database
   ```

2. Set the environment variable

   All commands shown below use the environment variable `MDB_PASSWORD` that contains the MariaDB password. You should change it to your own secure password.

   ```bash
   export MDB_PASSWORD=my-secret-pw
   ```

3. Build the container

   MariaDB is available as an image on [DockerHub](https://hub.docker.com/_/mariadb/). The Dockerfile in this repository uses that as the base image. Run the following command to build the Pyrrha mariadb component:

   ```bash
   docker build -t mariadb .
   ```

4. Run the container

   Use the following command to download the image and run a container that listens on port 3306. The command also mounts the `data` directory in the cloned repository to `/var/lib/mysql`. This makes it easier to access the data files in your host system.

   ```bash
   docker run --name mariadb -v $PWD/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=${MDB_PASSWORD} -p 3306:3306 -d mariadb
   ```

   The startup configuration is specified in the file `/etc/mysql/my.cnf`. If you want to use a customized MariaDB configuration, you can create your alternative configuration file in a directory on the host machine and then mount that directory location as `/etc/mysql/conf.d` inside the MariaDB container as follows:

   - `$PWD/mdbconfig:/etc/mysql/conf.d` - store configuration

   When using a host mount with SELinux, you need to pass an extra option `:z` or `:Z` to the end of the volume definition:

   - The `z` option indicates that the bind mount content is shared among multiple containers.
   - The `Z` option indicates that the bind mount content is private and unshared.

   You can learn more in the official [Docker guide](https://docs.docker.com/storage/bind-mounts/#configure-the-selinux-label). This [Stack Overflow answer](https://stackoverflow.com/a/31334443/898954) has more details.

   ```bash
   docker run --name mariadb -v $PWD/data:/var/lib/mysql:Z -e MYSQL_ROOT_PASSWORD=${MDB_PASSWORD} -p 3306:3306 -d mariadb
   ```

5. Verify the database

   You should be able to see the Pyrrha database:

   ```bash
   docker exec -t mariadb mysql -uroot -p${MDB_PASSWORD} -e 'show databases;'
   ```

   Output:

   ```bash
   +--------------------+
   | Database           |
   +--------------------+
   | information_schema |
   | mysql              |
   | performance_schema |
   | pyrrha             |
   +--------------------+
   ```

   You can also list all the tables in the pyrrha database:

   ```bash
   docker exec -t mariadb mysql -uroot -p${MDB_PASSWORD} -e 'use pyrrha; show tables;'
   ```

   Output:

   ```bash
   +------------------------------+
   | Tables_in_pyrrha             |
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

6. Use `mysql` (OPTIONAL)

   You are ready to go! You can talk to the database by using localhost:3306. If you have `mysql` available on the host machine, use the following command to connect:

   ```bash
   mysql -u root -p${MDB_PASSWORD} --host localhost --port 3306 --protocol=tcp
   ```

### IKS (IBM Kubernetes Service)

1. Sign up for [IBM Cloud](https://cloud.ibm.com/registration) or log in with your existing account.

2. Create an IBM Kubernetes Cluster (IKS) from the [catalog](https://cloud.ibm.com/kubernetes/catalog/create).

3. Add [IBM Cloud Block Storage plug-in](https://cloud.ibm.com/catalog/content/ibmcloud-block-storage-plugin-51baa72d-be9b-487a-8e77-02577d2b5b21-global) from the catalog to your cluster in the default namespace. You need this plugin to use persistance volumes and persistance volume claims on IKS.

4. Log into your cluster by following these [steps](https://cloud.ibm.com/docs/containers?topic=containers-access_cluster)

   You can verify that you have the correct context by using this command:

   ```bash
   kubectl config current-context
   ```

   You should see an output like `<cluster_name>/<cluster_ID>`.

5. Add password to `kubernetes/mariadb-secret.yaml` file. You need to get the base 64 encoded password first by using the following command:

   ```bash
   echo -n ${MDB_PASSWORD} | base64
   ```

   There are three passwords in the secret yaml file. You can create different passwords for each one.

   - `mariadb-root-password`
   - `mariadb-replication-password`
   - `mariadb-user-password`

6. Add Bitnami Helm repo locally

   ```bash
   helm repo add bitnami https://charts.bitnami.com/bitnami
   ```

7. Apply the secret file `kubernetes/mariadb-secret-sample.yaml`. The pods will not run unless you apply this secret with the correct base 64 encoded credentials.

   ```bash
   kubectl apply -f kubernetes/mariadb-secret-sample.yaml

   secret/mariadb created
   ```

   You can verify that the secret was created successfully.

   ```bash
   kubectl get secret

   NAME                            TYPE                                  DATA   AGE
   mariadb                         Opaque                                3      2m33s
   ```

8. Apply the Helm chart with the `values-production.yaml` file.

   ```bash
   helm install mariadb bitnami/mariadb -f kubernetes/values-production.yaml

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

   ```bash
   kubectl get pods

   NAME                  READY   STATUS    RESTARTS   AGE
   mariadb-primary-0     1/1     Running   0          8m18s
   mariadb-secondary-0   1/1     Running   0          8m18s
   ```

9. Copy the SQL data file to the primary pod.

   ```bash
   kubectl cp data/pyrrha.sql mariadb-primary-0:/tmp/pyrrha.sql
   ```

   Check if the file is present in the container

   ```bash
   kubectl exec -it mariadb-primary-0 -- ls /tmp

   pyrrha.sql
   ```

10. Load the data into the database.

    First, set permissions so your can load the SQL without having root privileges:

    ```bash
    kubectl exec mariadb-primary-0 -- mysql -uroot -p${MDB_PASSWORD} -e 'SET GLOBAL log_bin_trust_function_creators = 1;'
    ```

    Next, load the SQL file

    ```bash
    kubectl exec -it mariadb-primary-0 -- mysql -uroot -p${MDB_PASSWORD} -e 'source /tmp/pyrrha.sql;'
    ```

    You just deployed MariaDB On IBM Cloud Kubernetes Services and loaded the pyrrha tables and stored procedures. You can see the tables with the following command:

    ```bash
    kubectl exec mariadb-primary-0 -- mysql -uroot -p${MDB_PASSWORD} -e 'use pyrrha; show tables'

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

## Troubleshooting

### Changing password

1. Log into MariaDB using your current root password.

   ```bash
   mysql -u root -pcurrentpassword --host localhost --port 3306 --protocol tcp
   ```

2. Change password for the root user

   ```sql
   UPDATE mysql.user SET Password=PASSWORD('Test@123$') WHERE User='root';
   ```

3. Flush privileges

   ```sql
   FLUSH PRIVILEGES;
   ```

4. Exit the `mysql` shell

   ```bash
   exit;
   ```

5. You now need to change the password in the secret used by MariaDB. You need to know the name of the secret.

   ```bash
   kubectl get secret | grep mariadb

   mariadbxx-xxxx-xx Opaque 2 366d
   ```

   The describe command will show us the content of this seret

   ```bash
   kubectl describe secret mariadbxx-xxxx-xx

   Name:         mariadbxx-xxxx-xx
   ...
   ...
   Data
   ====
   mariadb-replication-password:  10 bytes
   mariadb-root-password:         12 bytes
   ```

   You can now update this secret with the new password:

   ```bash
   kubectl create secret generic mariadbxx-xxxx-xx --from-literal=mariadb-root-password=Test@123$ --dry-run -o yaml \
   | kubectl apply -f -
   ```

6. You can similarly change the other cluster secrets that use this password. The example below updates secret called `rulesdecision-secret` with the new password:

   ```bash
   kubectl create secret generic rulesdecision-secret --from-literal=MARIADB_PASSWORD=Test@123$ --dry-run -o yaml \
   | kubectl apply -f -
   ```

## Uninstall MariaDB

1. Remove the Helm chart

   ```bash
   helm uninstall mariadb
   ```

2. Remove the persistent volume claims:

   ```bash
   kubectl delete pvc data-mariadb-primary-0
   kubectl delete pvc data-mariadb-secondary-0
   ```

3. Remove the secret:

   ```bash
   kubectl delete secret mariadb
   ```

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting Pyrrha pull requests.

## License

This project is licensed under the Apache 2 License - see the [LICENSE](LICENSE) file for details.
