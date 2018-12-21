#!/usr/bin/env python3
import requests

emailURL = 'http://52.91.107.223:5000/exposure/recent?user_id='

user_id = '1'
finalURL = emailURL+payload
r = requests.get(finalURL)
print(r.json)
