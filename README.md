# Prometeo database

This repository contains the [Prometeo](https://github.com/Code-and-Response/Prometeo) solution application database that manages sensor readings over time. It targets MariaDB.

[![License](https://img.shields.io/badge/License-Apache2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0) [![Slack](https://img.shields.io/badge/Join-Slack-blue)](https://callforcode.org/slack)

## Setting up the solution

* Create a MariaDB database instance. This one has been set up via a Helm Chart on the IBM Kubernetes service.

* Log into the instance and create the database structure
```sql
mysql> source prometeo.sql
```

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting Prometeo pull requests.

## License

This project is licensed under the Apache 2 License - see the [LICENSE](LICENSE) file for details.