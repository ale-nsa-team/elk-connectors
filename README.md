# elk-connectors

# ELK Connectors
This project provides a set of scripts and configurations to extract, transform, and send logs from switches and network devices to an ELK server (Elasticsearch, Logstash, Kibana). It includes:
  Filebeat configuration to collect RADIUS, DPI, and syslog logs
  Logstash configuration to parse and enrich logs before sending them to Elasticsearch
  A script to upload configuration files to the switch
  A Flask server to receive uploaded files
Additionally, the reception of files on the ELK server is automated every 10 minutes, ensuring that switch data is regularly synchronized and available for analysis.

# Table of Contents
- Project Structure
- Prerequisites
- Configuration
- Installation
- Usage
- Automated Uploads (Every 10 Minutes)
- Log Architecture
- Security

# Project Structure
elk_connectors/
├─ elk_code_source/
    ├─ config/
    │  └─ appmon_config.env.example   # Switch & ELK configuration example
       └─  filebeat.yml               # configuration to collect logs
       └─ logstash.conf               # configuration to parse and enrich logs
    ├─ scripts/
    │  └─ push_config.sh              # Script to upload configuration files to the switch
    ├─ server/
    │  └─ flask_server.py             # Flask server to receive uploaded files and save them locally
    └─ README.md

# Prerequisites
    - Python 3.10+ (for Flask server)
    - Flask (pip install flask)
    - Filebeat (compatible version with Logstash)
    - Logstash (compatible version with Elasticsearch)
    - curl (for upload script)
    - Network access to: (Switch (SWITCH_IP), ELK server (UPLOAD_FILE_URL), Logstash port (5044), Flask port (31175)) 

#  Configuration
Copy the example configuration and update it:
  ```bash
cp config/appmon_config.env.example config/appmon_config.env
`````

# installation 
# 1- Install Filebeat
 ```bash
sudo apt update
sudo apt install filebeat
`````
- Copy Filebeat configuration from the project to # /etc/filebeat/filebeat.yml
- Enable and start Filebeat:
  ```bash
     sudo systemctl enable filebeat
     sudo systemctl start filebeat
  `````
# 2- Install Logstash
 ```bash
sudo apt install logstash
`````
- Copy Logstash configuration from the project
- Start Logstash:
  ```bash
    sudo systemctl enable logstash
    sudo systemctl start logstash
  `````
# 3- Install Kibana
 ```bash
sudo apt install Kibana
`````
- in kibana configuration (/etc/kibana/kibana.yml) add this ligne:
  ```bash
    server.host: "0.0.0.0"
  `````
- Start kibana:
  ```bash
    sudo systemctl enable kibana
    sudo systemctl start kibana
  `````
# 4- Install Flask server
 ```bash
pip install flask
`````
- and then run the script 
  ```bash
    python flask_server.py.py
  `````
- The server listens on 0.0.0.0:31175 and saves files in /tmp/uploads.


  

