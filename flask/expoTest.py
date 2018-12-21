#!/usr/bin/env python3
import requests

expoURL = 'http://52.91.107.223:5000/exposure'

payload = {
	'pi_id': 1
}
r = requests.post(expoURL, json=payload)
print(r)
