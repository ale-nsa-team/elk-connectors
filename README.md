# elk-connectors

#ELK Connectors
This project provides a set of scripts and configurations to extract, transform, and send logs from switches and network devices to an ELK server (Elasticsearch, Logstash, Kibana). It includes:
  Filebeat configuration to collect RADIUS, DPI, and syslog logs
  Logstash configuration to parse and enrich logs before sending them to Elasticsearch
  A script to upload configuration files to the switch
  A Flask server to receive uploaded files
Additionally, the reception of files on the ELK server is automated every 10 minutes, ensuring that switch data is regularly synchronized and available for analysis.

#Table of Contents
- Project Structure
- Prerequisites
- Configuration
- Installation
- Usage
- Automated Uploads (Every 10 Minutes)
- Log Architecture
- Security

#Project Structure
elk_connectors/
├─ elk_code_source/
    ├─ config/
    │  └─ appmon_config.env.example   # Switch & ELK configuration example
       └─  filebeat.yml               # configuration to collect logs
       └─ logstash.conf               # configuration to parse and enrich logs
    ├─ scripts/
    │  └─ push_config.sh              # Script to upload configuration files to the switch
    ├─ server/
    │  └─ flask_server.py             # Flask server to receive uploaded files
    └─ README.md
