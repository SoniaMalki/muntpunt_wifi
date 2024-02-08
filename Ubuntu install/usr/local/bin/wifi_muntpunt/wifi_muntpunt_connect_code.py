import requests
import urllib.request
import os
import shutil

credential = {}

current_directory = os.path.dirname(os.path.realpath(__file__))


# Define the message to be centered
message = "Welcome to Wifi Muntpunt connect!"
message2 =  len(message)*"*" 

# Get the width of the terminal
terminal_width = shutil.get_terminal_size().columns

# Calculate the amount of whitespace needed to center the message
padding = (terminal_width - len(message)) // 2

# Construct the centered message with padding
centered_message = " " * padding + message
centered_message2 = " " * padding + message2

print(centered_message)
print(centered_message2)

welcome_message = """
To install the app in the tray for launch, please run the following command:
    /usr/local/bin/wifi_muntpunt/install_tray_at_launch.sh

To reconfigure the credentials, please run this script from the terminal:
    sudo dpkg-reconfigure wifi-muntpunt
"""

# Create the separator line with the same width as the terminal
separator = '-' * terminal_width

# Concatenate the centered welcome message with the separator
message_with_separator = welcome_message.strip() + '\n\n' + separator

print(message_with_separator)
# Add your follow-up message here


with open(current_directory+"/credentials.txt", "r") as credential_file:
    for i in range (2):
       line = credential_file.readline().split("=")
       credential[line[0].strip()]= line[1].strip()



def connect(host="https://google.com"):
    try:
        requests.get("https://google.com")
        return True
    
    except Exception as e:
        return False

def connexion_captive_portal(username=credential["username"], password=credential["password"]):
    response = requests.get('http://captive.apple.com/', verify=False)
    #--------------------------------------------------------------------------------------
    params = {}
    params_list = [x.split("=") for x in response.headers['Location'][50:].split("&")]
    for key_value in params_list:
        params[key_value[0]] = key_value[1]

    response = requests.get('https://mp-ise001.muntpunt.be:8445/portal/gateway', params=params)
    #--------------------------------------------------------------------------------------
    cookies = response.cookies
    response = requests.get('https://mp-ise001.muntpunt.be:8445/portal/PortalSetup.action', params=params, cookies=cookies)
    #--------------------------------------------------------------------------------------
    token = response.headers["token"]
    cookies = response.cookies
    params = {'from': 'LOGIN'}
    data = [
        ('token', token),
        ('portal', '71984f36-f55e-4439-ba6e-903d9f77c216'),
        ('user.username', username),
        ('token', token),
        ('user.password', password),
    ]
    response = requests.post('https://mp-ise001.muntpunt.be:8445/portal/LoginSubmit.action', params=params, data=data, cookies=cookies)
    #---------------------------------------------------------------------------------------
    cookies = response.cookies
    data = {'token': token}
    params = {'from': 'POST_ACCESS_BANNER'}
    response = requests.post('https://mp-ise001.muntpunt.be:8445/portal/Continue.action', params=params, data=data, cookies=cookies)
    #---------------------------------------------------------------------------------------
    data = {
        'delayToCoA': '0',
        'coaType': 'Reauth',
        'coaSource': 'GUEST',
        'coaReason': 'Guest authenticated for network access',
        'waitForCoA': 'true',
        'token': token,
    }

    response = requests.post('https://mp-ise001.muntpunt.be:8445/portal/DoCoA.action', data=data, cookies=cookies)
    if response.status_code == 200:
        print("Success ! Connected to internet!")
    else:
        print("Error... Please relaunch install and correct password.")
if connect():
    print("Already connected to internet!")
else:
    connexion_captive_portal()
