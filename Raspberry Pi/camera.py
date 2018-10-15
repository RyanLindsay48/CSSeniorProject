#!/usr/bin/env python3

import os
import sys
from time import sleep
from datetime import datetime, timedelta
from os.path import expanduser
from picamera import PiCamera


# Wait for a specified  time
def wait(delay_type, multiplier):
        # Determine delay time based on input
        now = datetime.now()
        delay_hr = timedelta(hours=1) # Default value is 1
        delay_min = timedelta(minutes=1) # Default value is 2
        delay_sec = timedelta(seconds=1) # Default value is 3

        # Determine delay time based on input
        next_time = {
                'hr': (now + delay_hr).replace(minute=0,second=0,microsecond=0),
                'min': (now + delay_min).replace(second=0,microsecond=0),
                'sec': (now + delay_sec).replace(microsecond=0)
        }

        # Delay the amount of time required
        delay = multiplier*(next_time.get(delay_type) - datetime.now()).seconds
        sleep(delay)


# Save the image to a file located on the PI
def capture_save(camera, save_folder):
        # Determine date-time information used for saving image
        dt = datetime.now()

        # Determine folder location to send image, create if not there
        dest_folder = expanduser('~') + save_folder + dt.strftime('%Y-%m-%d')
        if not os.path.exists(dest_folder):
                os.makedirs(dest_folder)

        # Capture picture and save to destination folder
        camera.annotate_text = dt.strftime('%H:%M:%S') # Current time
        file_name = dest_folder + '/image' + dt.strftime('%H-%M-%S')+ '.jpg'
        camera.capture(file_name)


# Transfer the image to a database located on the server
# def capture_transfer():



# ----------------------------------------------------------------------------

def main(argv):
        # Setup camera with specified settings
        camera = PiCamera()
        camera.resolution = "1080x720"
        camera.start_preview()

        # Setup delay type and wait for next time
        delay_type = sys.argv[1]
        multiplier = sys.argv[2]
        wait(delay_type, multiplier)

        # Keep taking pictures until reset is made and process is killed
        try:
                while True:
                        capture_save(camera, '/Pictures/')
                        # capture_transfer(image)
                        wait(delay_type)
        finally:
                camera.stop_preview()

if __name__ == '__main__':
        main()
