#!/usr/bin/env python3

import datetime as dt
from datetime import timedelta
from time import sleep
import time
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


# Wait for a specified time
def wait(delay_type, multiplier):
        # Determine delay time based on input
        if delay_type == 'hr':
                time_delay = timedelta(hours = multiplier).total_seconds()
        elif delay_type == 'min':
                time_delay = timedelta(minutes = multiplier).total_seconds()
        elif delay_type == 'sec':
                time_delay = timedelta(seconds = multiplier).total_seconds()
                
        # Delay the amount of time required
        delay = time_delay - (time.time() % time_delay)

        sleep(delay)


#-----------------------------------------------------------------------------
debug = 0  # debug flag. Different levels activate different print statements

def main(args):
        try:
                # Gather user specific  information
                pi_serial = getSerial()
                        
                # Setup url to send information to
                imageURL = 'http://52.91.107.223:5000/exposure/picture'
                resetURL = 'http://52.91.107.223:5000/pi/reset'
                snURL = 'http://52.91.107.223:5000/pi/sn'
                expoURL = 'http://52.91.107.223:5000/exposure'
        
                # Tests for argument parsing
                if debug > 1:
                        print(args.username)
                        print(args.password)
                        print(args.delay_type)
                        print(args.multiplier)
                        print(args.location)
                        print(args.MAX_NUM)
                        
                        
                # Initialize camera object
                cameraObj = camera.setup()

                pi_json = requests.get(snURL, json={'pi_sn': pi_serial}).json()
                pi_id = pi_json['pi_id']
                        
                while True:
                        # Check for motion, will not continue until motion is detected
                        motion.motion_detected()
                        
                        # Debugging print
                        if debug > 0:
                                print('Motion detected!')
                                        
                        expo_json = requests.post(expoURL, json={'pi_id': pi_id}).json()
                        expo_id = expo_json['exposures_id']
                                        
                        counter = 0
                                
                        while counter < args.MAX_NUM:
                                # Check for reset signal from the user
                                r = requests.get(resetURL, json={'pi_id' : pi_id})
                                signal_reset = r.json()['reset']
                                if signal_reset == 1: # Reset signal back to default
                                        requests.put(resetURL, json={'value' : 0})
                                        break
                                                
                                # Wait until correct time to take picture
                                wait(args.delay_type, args.multiplier)
                                        
                                # Begin recording images
                                cur_time = dt.datetime.now()
                                        
                                # Setup folder to save to
                                dir = os.path.expanduser('~') + args.location + cur_time.strftime('%m-%d-%Y')
                                if not os.path.exists(dir):
                                        os.makedirs(dir)
                                                
                                # Capture picture and send it to endpoint
                                filename = dir + '/image-' + cur_time.strftime('%H%M%S') + '.jpg'
                                print("" + filename)
                                camera.capture_picture(cameraObj, filename, cur_time)
                                metadata = {
                                        'timestamp': cur_time.strftime('%H%M%S'),
                                        'filename': ('image-' + cur_time.strftime('%H%M%S') + '.jpg'),
                                        'expo_id': expo_id,
                                        'pi_id': pi_id
                                }
                                payload = {
                                        'photo': open(filename, 'rb')
              		        }
                                r = requests.post(imageURL, files=payload, data=metadata)
                                                
                                counter += 1
                                        
             		        # Debugging prints
                                if debug > 0:
                                        print('Image file was sent to endpoint')
                                        print('Endpoint: ' + imageURL)
                                        print('Image name: ' + filename)
                                                
                        # Wait at least 10 seconds between exposures
                        wait('sec', 10)
                                                        
                # Release camera resources
                cameraObj.close()
                
        except KeyboardInterrupt:
                print("\rCamera Terminated")
                


if __name__=="__main__":
        # Parse input for potential important values
        parser = argparse.ArgumentParser(description="Main script arg parser")
        parser.add_argument('-d', default='sec', type=str,
                            action='store', dest='delay_type',
                  	    help='Type of delay requested')
        parser.add_argument('-l', default='/Pictures/', type=str,
                            action='store', dest='location',
                            help='Location to save image files to on rpi')
        parser.add_argument('-m', default=2, type=int,
                  	    action='store', dest='multiplier',
                  	    help='Time multiplier for delay')
        parser.add_argument('-n', default=5, type=int,
                            action='store', dest='MAX_NUM',
                            help='Maximum number of pictures for one exposure')
        parser.add_argument('-p', default='password', type=str,
                            action='store', dest='password',
                            help='User specific password for user auth')
        parser.add_argument('-u', default='username', type=str,
                            action='store', dest='username',
                            help='User specific username for user auth')
        args = parser.parse_args()

        main(args)
