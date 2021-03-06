#!/usr/bin/env python3
import requests
import zipfile
import json
import imghdr as img
import tempfile
import os

picsURL = 'http://52.91.107.223:5000/exposure/pictures'

payload = {
        'pi_id': '2',
	'expo_id': '28',
	'image_name': 'image-162614.jpg'
}
r = requests.get(picsURL, json=payload)

print(payload)
print(r.status_code)

# Create temp directory to save images into
with tempfile.TemporaryDirectory() as dirpath:
	# Create temp file to save zip file to
	with tempfile.TemporaryFile() as filepath:
		# Write content to temp zip file
		zippath = dirpath + '/' + 'arc.zip'
		with open(zippath, 'wb') as f:
			f.write(r.content)

		# Extract contents of zip file into temp directory
		path = os.path.expanduser('~') + '/upload/app/arc.zip'
		zip_ref = zipfile.ZipFile(zippath, 'r')
		zip_ref.extractall(dirpath)
		zip_ref.close()

	# List image files
	print(os.listdir(dirpath))

	# Check to make sure files are still images
	for filename in os.listdir(dirpath):
		imagepath = dirpath + '/' + filename
		print(img.what(imagepath))


