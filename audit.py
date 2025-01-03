import requests
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

# Configuration
API_BASE_URL = "https://api.dynatrace.com/iam/v1/accounts"
SSO_TOKEN_URL = "https://sso.dynatrace.com/sso/oauth2/token"
ACCOUNT_UUID = "your_account_uuid_here"
CLIENT_ID = "your_client_id_here"
CLIENT_SECRET = "your_client_secret_here"
SCOPES = "account-idm-read"
SMTP_SERVER = "your_smtp_server"
SMTP_PORT = 587  # Common for TLS
EMAIL_SENDER = "your_email@example.com"
EMAIL_PASSWORD = "your_email_password"
EMAIL_RECIPIENT = "recipient_email@example.com"

# Function to get OAuth token
def get_oauth_token():
    data = {
        "grant_type": "client_credentials",
        "client_id": CLIENT_ID,
        "client_secret": CLIENT_SECRET,
        "scope": SCOPES,
        "resource": f"urn:dtaccount:{ACCOUNT_UUID}"
    }
    headers = {"Content-Type": "application/x-www-form-urlencoded"}
    response = requests.post(SSO_TOKEN_URL, data=data, headers=headers)
    response.raise_for_status()
    return response.json().get("access_token")

# Headers for API requests
def get_headers(token):
    return {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json",
    }

def get_groups(token):
    url = f"{API_BASE_URL}/{ACCOUNT_UUID}/groups"
    headers = get_headers(token)
    response = requests.get(url, headers=headers)
    response.raise_for_status()
    return response.json()

def get_group_members(token, group_uuid):
    url = f"{API_BASE_URL}/{ACCOUNT_UUID}/groups/{group_uuid}/users"
    headers = get_headers(token)
    response = requests.get(url, headers=headers)
    response.raise_for_status()
    return response.json()

def send_email(group_name, member_count):
    subject = f"Alert: Members Found in LOCAL Group '{group_name}'"
    body = f"The LOCAL group '{group_name}' contains {member_count} member(s). Please review the group for compliance."

    msg = MIMEMultipart()
    msg["From"] = EMAIL_SENDER
    msg["To"] = EMAIL_RECIPIENT
    msg["Subject"] = subject
    msg.attach(MIMEText(body, "plain"))

    with smtplib.SMTP(SMTP_SERVER, SMTP_PORT) as server:
        server.starttls()
        server.login(EMAIL_SENDER, EMAIL_PASSWORD)
        server.sendmail(EMAIL_SENDER, EMAIL_RECIPIENT, msg.as_string())

# Main script
def main():
    try:
        token = get_oauth_token()
        groups = get_groups(token)
        for group in groups.get("items", []):
            if group["owner"] == "LOCAL":
                group_uuid = group["uuid"]
                group_name = group["name"]
                members = get_group_members(token, group_uuid)
                member_count = members.get("count", 0)

                if member_count > 0:
                    send_email(group_name, member_count)

    except requests.exceptions.RequestException as e:
        print(f"API error: {e}")
    except Exception as e:
        print(f"Unexpected error: {e}")

if __name__ == "__main__":
    main()
