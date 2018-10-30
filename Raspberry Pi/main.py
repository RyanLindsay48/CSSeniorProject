#!/usr/bin/env python3

from datetime import datetime as dt
from datetime import timedelta
from time import sleep
import motion as motion
import camera as camera
import requests
import argparse
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
def wait(delay_type):
        # Determine delay time based on input
        now = dt.now()
        delay_hr = timedelta(hours=1)
        delay_min = timedelta(minutes=1)
        delay_sec = timedelta(seconds=1)

        # Determine delay time based on input
        next_time = {
                'hr': (now + delay_hr).replace(minute=0,second=0,microsecond=0),
                'min': (now + delay_min).replace(second=0,microsecond=0),
                'sec': (now + delay_sec).replace(microsecond=0)
        }

        # Delay the amount of time required
        delay = (next_time.get(delay_type) - dt.now()).seconds
        sleep(delay)


# Save image file to a specified location on the Pi
#def save_image(dir, image, date_time):
#        dest_folder = expanduser('~') + dir + date_time.strftime('%m-%d-%y')
#       if not os.path.exists(dest_folder):
#               os.makedirs(dest_folder)
#
#       # Save image to destination folder
#       img = cv2.imread(image, 1)
#       image_name = + '/image' + date_time.strftime('%H-%M-%S')+ '.jpg'
#       cv2.imwrite(os.path.join(dest_folder, image_name),img)
#       cv2.waitKey(0)


#-----------------------------------------------------------------------------

def main(args):
        # Gather user specific  information
        pi_id = getSerial()
        username = args.username
        password = args.password

        # Setup url to send information to
        imageURL = 'http://52.91.107.223:5000/upload'
        resetURL = 'http://52.91.107.223:5000/resetPi'

        while True:
                # Check for motion
                motion.motion_detected()

                try:
                        # Setup camera information
                        cameraObj = camera.setup()

                        while True:
                                # Wait until correct time to take picture
                                cur_time = dt.now()
                                wait(args.delay_type)

                                # Begin recording images
                                cur_time = dt.now()

                                # Setup folder to save to
                                dir = os.path.expanduser('~') + args.location + cur_time.strftime('%m-%d-%Y')
                                if not os.path.exists(dir):
                                        os.makedirs(dir)

                                # Capture picture and send it to endpoint
                                filename = dir + '/image-' + cur_time.strftime('%H:%M:%S') + '.jpg'
                                camera.capture_picture(cameraObj, filename, cur_time)
                                payload = {
                                        'media': open(filename, 'rb')
                                }
                                requests.post(imageURL, files=payload)

                                # Remove when test for reset
                                cameraObj.close()
                                break

                                #############################
                                # Update to check for reset #
                                #############################
                                # Check for reset signal from user
                                # r = requests.get(resetURL, auth=(username, password))
                                # signal_reset = r.json()['reset']
                                # if signal_reset = true
                                #       break
                                #############################

                finally:
                        cameraObj.close()

                        # Reset controls back to default states
                        # r = requests.put(resetURL, auth=(username, password), false)


if __name__=="__main__":
        # Parse input for potential important values
        parser = argparse.ArgumentParser(description="Main script arg parser")
        parser.add_argument('-d', default='sec', type=str,
                            action='store', dest='delay_type')
        parser.add_argument('-l', default='/Pictures/', type=str,
                            action='store', dest='location',
                            help='Location to save image files to')
        parser.add_argument('-p', default='password', type=str,
                            action='store', dest='password',
                            help='Password for user information')
        parser.add_argument('-t',
                            action='store_false', dest='transfer',
                            help='Delay type for wait period')
        parser.add_argument('-u', default='username', type=str,
                            action='store', dest='username',
                            help='Unique name for a specific user')
        args = parser.parse_args()

        main(args)

