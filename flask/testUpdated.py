from time import sleep
import datetime as dt
import requests


resetURL = 'http://52.91.107.223:5000/user/updated'
user_id = 1

#reset_pre_r = requests.get(resetURL, json={'user_id':user_id})
#reset_pre_json = reset_pre_r.json()
#reset_sent = reset_pre_json['updated']

requests.put(resetURL, json={'user_id':user_id, 'updated':0})

print ('updated user!')
#print (str(reset_sent))
