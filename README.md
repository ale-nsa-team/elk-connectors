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
- Automated Uploads 
- Log Architecture
- quick reminder

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
    python flask_server.py
  `````
- The server listens on 0.0.0.0:31175 and saves files in /tmp/uploads.

# 5- Installing FreeRADIUS
FreeRADIUS is an open-source RADIUS server.
In the context of ELK Connectors, FreeRADIUS is only used to correctly read RADIUS Accounting logs received from the switch or other network equipment.
```bash
sudo apt install freeradius freeradius-utils -y
`````
- Enable and start the FreeRADIUS service:
  ```bash
    sudo systemctl enable freeradius
    sudo systemctl start freeradius
  `````
- Basic Configuration, in /etc/freeradius/3.0/clients.conf: define switches or devices allowed to send RADIUS requests is available in elk_code_source/config/client.config
- Enable debug mode to see logs in real time:
  ```bash
   sudo freeradius -X
  `````

# Usage
```bash
   chmod +x push_config.sh
   ./push_config.sh
  `````
- Authenticates to the switch
- Uploads each file listed in UPLOAD_FILE_NAMES
- Sends them to the ELK server (Flask)
# in this case: 
- Filebeat collects RADIUS, DPI, and Fortigate syslog logs
- Logstash parses and enriches logs, then sends them to Elasticsearch
- Logs are indexed in Elasticsearch as follows:
    - RADIUS	sw-radius-logs-YYYY.MM.dd
    - DPI	sw-dpi-logs-test-YYYY.MM.dd
    - Firewall	sw-firewall-syslog-YYYY.MM.dd
 
# Automated Uploads
To automate uploads from the switch to the ELK server every 10 minutes, use a cron job:
```bash
   crontab -e
  `````
add the following line:
```bash
   */10 * * * * /home/elkadmin/elk-connectors/scripts/push_config.sh >> /home/elkadmin/elk-connectors/logs/upload.log 2>&1
  `````
# Log Architecture
  # RADIUS Logs
  - Extracts: username, NAS IP, VLAN, MAC, timestamps, octets/packets
  # DPI Logs
  - parses CSV with IPs, ports, protocol, application, bytes/packets, timestam
  # Firewall
  - Extracts: IPs (external), applications, time in and out, type, action, policyid, ports, bytes, packets, scores...

# quick reminder
- Keep appmon_config.env local and add .env to .gitignore.
    


  

