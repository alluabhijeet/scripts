import socket
import datetime
import os
import platform

# === Config ===
SYSLOG_SERVER = '127.0.0.1'    # Replace with your actual endpoint
SYSLOG_PORT = 514              # Standard syslog port (UDP)
APP_NAME = 'PythonTestApp'
HOSTNAME = platform.node()
PROC_ID = str(os.getpid())
MSG_ID = 'test123'
MESSAGE = 'RFC5424 syslog message — structured log from Python.'
FACILITY = 1                   # user-level messages
SEVERITY = 6                   # info level

# === Build RFC5424 Log ===
def build_rfc5424_log(msg):
    priority = FACILITY * 8 + SEVERITY
    timestamp = datetime.datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%S.%fZ')
    structured_data = '-'  # Can be replaced with [exampleSDID@32473 iut="3" eventSource="App" eventID="1011"]
    
    syslog_msg = f'<{priority}>1 {timestamp} {HOSTNAME} {APP_NAME} {PROC_ID} {MSG_ID} {structured_data} {msg}'
    return syslog_msg

# === Send via UDP ===
def send_syslog(msg, server, port):
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        sock.sendto(msg.encode('utf-8'), (server, port))
        print("RFC5424 syslog message sent.")
    except Exception as e:
        print(f"Error sending syslog message: {e}")
    finally:
        sock.close()

# === Do it ===
if __name__ == '__main__':
    rfc5424_msg = build_rfc5424_log(MESSAGE)
    send_syslog(rfc5424_msg, SYSLOG_SERVER, SYSLOG_PORT)
