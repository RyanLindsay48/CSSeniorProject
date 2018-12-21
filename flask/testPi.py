#!/usr/bin/env python3
import requests


piJsonURL = 'http://52.91.107.223:5000/pi'


postPayload = {
        'user_id': 2,
        'location': 'Coal Plant',
        'serial_number': '000000008b052d77'
}

r = requests.post(piJsonURL, json=postPayload)
print(r.content)
