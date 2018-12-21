#!/usr/bin/env python3
import requests
import json
import os
import datetime as dt

url = 'http://52.91.107.223:5000/exposure/picture'
filename = 'image-113155.jpg' #'image21-07-38.jpg'


metadata = {
        'image_name': filename,
	'pi_id': '1',
	'expo_id': '1'
}

print (metadata)

r = requests.get(url, json=metadata, stream=True)

print (r.status_code)
#print (r.content[0:1000]) # This print out ugly
