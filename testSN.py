#!/usr/bin/env python3
import requests

snURL = 'http://52.91.107.223:5000/pi/sn'

payload = {
        'pi_sn': '000000001f7c4078'
}
r = requests.get(snURL, json=payload)

print(payload)
print(payload['pi_sn'])
print(r.status_code)
print(r)
print(r.content)

