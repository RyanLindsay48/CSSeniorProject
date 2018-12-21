from time import sleep
import datetime as dt
import requests


resetURL = 'http://52.91.107.223:5000/pi/reset'
pi_id = 1

reset_pre_r = requests.get(resetURL, json={'pi_id':pi_id})
reset_pre_json = reset_pre_r.json()
reset_sent = reset_pre_json['reset']

counter = 0
while reset_sent == 0:
	print ('Reset signal: ' + str(reset_sent))
	print (dt.datetime.now().strftime('%H:%M:%S'))

	sleep(5)

	reset_json = (requests.get(resetURL, json={'pi_id':pi_id})).json()
	reset_sent = reset_json['reset']

	counter += 1
	print (str(counter))
	if counter > 2:
		requests.put(resetURL, json={'pi_id':pi_id})

print ('Reset was hit!')
print (str(reset_sent))
