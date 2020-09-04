# Prometeo database

This repository contains the [Prometeo](https://github.com/Code-and-Response/Prometeo) solution application database that manages sensor readings over time. It targets MariaDB.

[![License](https://img.shields.io/badge/License-Apache2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0) [![Slack](https://img.shields.io/badge/Join-Slack-blue)](https://join.slack.com/t/code-and-response/shared_invite/enQtNzkyMDUyODg1NDU5LTdkZDhmMjJkMWI1MDk1ODc2YTc2OTEwZTI4MGI3NDI0NmZmNTg0Zjg5NTVmYzNiNTYzNzRiM2JkZjYzOWIwMWE)

## Setting up the solution

* Create a MariaDB database instance. This one has been set up via a Helm Chart on the IBM Kubernetes service.
* Create the database
```sql
CREATE DATABASE IF NOT EXISTS prometeo character set UTF8mb4 collate utf8mb4_unicode_ci;
```
* Log into the instance and create the database structure
```sql
mysql> use prometeo;
mysql> source prometeo.sql
```
* Create the stored procedures
```sql
mysql> use prometeo;
mysql> source procedures.sql
```

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting Prometeo pull requests.

## License

This project is licensed under the Apache 2 License - see the [LICENSE](LICENSE) file for details.