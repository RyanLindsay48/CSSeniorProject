#!/usr/bin/env python3

import requests
import json
import os
import datetime as dt

url = 'http://52.91.107.223:5000/exposure/picture'
filename = 'image-113030.jpg' #'image-112959.jpg' #'hello.txt'


metadata = {
	'timestamp': str(dt.datetime.now().strftime('%H:%M:%S')),
	'filename': filename,
	'expo_id': 7,
        'pi_id': 1
}

files = {
        'photo': open(filename, 'rb') #open('image21-07-38.jpg', 'rb')
        # (os.path.basename('image-17:04:44.jpg'), open('image-17:04:44.jpg', 'r$
}


#print (metadata)
#print (files)


r = requests.post(url, files=files, data=metadata)

#print (r.status_code)
#print (r.content)


