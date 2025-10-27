#!/usr/bin/env python3
from flask import Flask, request, jsonify
import json
import requests
import subprocess
import logging
import os

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)

def trigger_ansible_playbook(alert_name, service_name):
    """Execute Ansible playbook based on alert"""
    try:
        playbook_path = f"./playbooks/{service_name}_recovery.yml"
        
        if os.path.exists(playbook_path):
            result = subprocess.run(
                ['ansible-playbook', playbook_path, '-e', f'alert_name={alert_name}'],
                capture_output=True, text=True, timeout=300
            )
            
            logging.info(f"Ansible playbook executed: {result.stdout}")
            if result.stderr:
                logging.error(f"Ansible errors: {result.stderr}")
                
            return result.returncode == 0
        else:
            logging.error(f"Playbook not found: {playbook_path}")
            return False
            
    except Exception as e:
        logging.error(f"Error executing playbook: {e}")
        return False

@app.route('/webhook', methods=['POST'])
def webhook():
    try:
        data = request.json
        logging.info(f"Received alert: {json.dumps(data, indent=2)}")
        
        for alert in data.get('alerts', []):
            alert_name = alert['labels']['alertname']
            service_name = alert['labels'].get('service', 'unknown')
            status = alert['status']
            
            logging.info(f"Alert: {alert_name}, Service: {service_name}, Status: {status}")
            
            # Only trigger remediation for firing alerts
            if status == 'firing':
                success = trigger_ansible_playbook(alert_name, service_name)
                if success:
                    logging.info(f"Successfully handled alert: {alert_name}")
                else:
                    logging.error(f"Failed to handle alert: {alert_name}")
        
        return jsonify({'status': 'success'}), 200
        
    except Exception as e:
        logging.error(f"Webhook error: {e}")
        return jsonify({'status': 'error', 'message': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
