#!/usr/bin/env python3
import requests

emailURL = 'http://52.91.107.223:5000/user/email_address/'

payload = 'example@rowan.edu'
finalURL = emailURL+payload
r = requests.get(finalURL)
print(r)
