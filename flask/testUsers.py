'''
Users endpoint only has a get method to return all users
'''

import requests

userURL = 'http://52.91.107.223:5000/users'

r = requests.get(userURL)

print('Users endpoint works correctly')
print(r.content)
print(' ')
