#!/usr/bin/env python3
import requests
import time


userJsonURL = 'http://52.91.107.223:5000/user'
userGetURL = 'http://52.91.107.223:5000/user?id=10'
userPutURL = 'http://52.91.107.223:5000/user?id=10&email=blank@email.com&fname=first_name&lname=last_name&password=password'
userPostURL = 'http://52.91.107.223:5000/user?email=bobob@email.com&fname=first_name&lname=last_name&password=password'
userDeleteURL = 'http://52.91.107.223:5000/user?id=10'


getPayload = {
	'user_id': 35
}
putPayload = {
	'user_id': 17,
	'email_address': 'pickleboy@email.com',
	'fname': 'first_name',
	'lname': 'last_name',
	'password': 'password'
}
postPayload = {
        'email_address': 'tomthetank@engine.com',
        'fname': 'thomas',
        'lname': 'tank',
        'password': 'toottoot'
}
deletePayload = {
	'user_id': 35
}

r = requests.post(userJsonURL, json=postPayload)
print(r.content)
