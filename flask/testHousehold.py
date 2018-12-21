#!/usr/bin/env python3
import requests


householdJsonURL = 'http://52.91.107.223:5000/household'

postPayload = {
	'user_id': 2,
        'street_address': '101 Toottoot Lane',
        'apartment_num': 1,
	'city': 'Engineville',
        'state': 'TN',
        'zip_code': '00000'
}

r = requests.post(householdJsonURL, json=postPayload)
print(r.content)
