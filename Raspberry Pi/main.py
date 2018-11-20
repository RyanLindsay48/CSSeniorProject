#!/usr/bin/env python3

from datetime import datetime as dt
from datetime import timedelta
from time import sleep
import argparse
import requests
import camera
import motion
import io
import os


# This script will control all that happens between the PI modules, and
# be responsible for sending pictures to the server


# Get a unique identifier for the Raspberry Pi (Serial Number)
def getSerial():
        # Extract serial from cpuinfo file
        cpuserial = "0000000000000000"
        try:
           f = open('/proc/cpuinfo','r')
           for line in f:
              if line[0:6]=='Serial':
                cpuserial = line[10:26]
              f.close()
        except:
           cpuserial = "ERROR000000000"

        return cpuserial


# Wait for a specified  time
def wait(delay_type, multiplier):
        # Determine delay time based on input
        now = dt.now()
        delay_hr = timedelta(hours=multiplier)
        delay_min = timedelta(minutes=multiplier)
        delay_sec = timedelta(seconds=multiplier)

        # Determine delay time based on input
        next_time = {
                'hr': (now + delay_hr).replace(minute=0,second=0,microsecond=0),
                'min': (now + delay_min).replace(second=0,microsecond=0),
                'sec': (now + delay_sec).replace(microsecond=0)
        }

        # Delay the amount of time required
        delay = (next_time.get(delay_type) - dt.now()).seconds
        sleep(delay)


#-----------------------------------------------------------------------------
debug = 0  # debug flag. Different levels activate different print statements

def main(args):
        # Gather user specific  information
        pi_id = getSerial()
        username = args.username
        password = args.password
        # Setup url to send information to
        imageURL = 'http://52.91.107.223:5000/exposure/picture'
        resetURL = ''

        # Tests for argument parsing
        if debug > 1:
                print(args.username)
                print(args.password)
                print(args.delay_type)
                print(args.multiplier)
                print(args.location)
        
        
        # Initialize camera object
        cameraObj = camera.setup()

        while True:
                # Check for motion, will not continue until motion is detected
                motion.motion_detected()

                # Debugging print
                if debug > 0:
                        print('Motion detected!')
                
                while True:
              	# Wait until correct time to take picture
                        cur_time = dt.now() # Does this do anything?
                        wait(args.delay_type, args.multiplier)

                        # Begin recording images
                        cur_time = dt.now()

                        # Setup folder to save to
                        dir = os.path.expanduser('~') + args.location + cur_time.strftime('%m-%d-%Y')
                        if not os.path.exists(dir):
                               os.makedirs(dir)

                        # Capture picture and send it to endpoint
                        filename = dir + '/image-' + cur_time.strftime('%H:%M:%S') + '.jpg'
                        print("" + filename)
                        camera.capture_picture(cameraObj, filename, cur_time)
                        payload = {
                                'photo': open(filename, 'rb')
              		}
                        r = requests.post(imageURL, files=payload, timeout=5)

             		# Debugging prints
                        if debug > 0:
                                print('Image file was sent to endpoint')
                                print('Endpoint: ' + imageURL)
                                print('Image name: ' + filename)
                        
                        
                        # Check for reset signal from the user
              		#r = requests.get(resetURL, auth=(username, password))
              		#signal_reset = r.json()['reset']
              		#if signal_reset =  true
              		# Reset signal back to default
              		#requests.put(resetURL, auth=(username, password), false)
                        #break

              		# Remove when reset signal testing works
                        if True:
                                break

        # Release camera resources
        cameraObj.close()


if __name__=="__main__":
        # Parse input for potential important values
        parser = argparse.ArgumentParser(description="Main script arg parser")
        parser.add_argument('-d', default='sec', type=str,
                            action='store', dest='delay_type',
                  	    help='Type of delay requested')
        parser.add_argument('-l', default='/Pictures/', type=str,
                            action='store', dest='location',
                            help='Location to save image files to on rpi')
        parser.add_argument('-m', default=5, type=int,
                  	    action='store', dest='multiplier',
                  	    help='Time multiplier for delay')
        parser.add_argument('-p', default='password', type=str,
                            action='store', dest='password',
                            help='User specific password for user auth')
        parser.add_argument('-u', default='username', type=str,
                            action='store', dest='username',
                            help='User specific username for user auth')
        args = parser.parse_args()

        main(args)
