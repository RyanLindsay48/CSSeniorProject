#!/usr/bin/env python3

import RPi.GPIO as GPIO
import time
import Camera
import sys


def run_camera(argument):
        Camera.main(argument)



#-----------------------------------------------------------------------------

def main(argv):
        GPIO.setwarnings(False)            # Don't report warnings
        GPIO.setmode(GPIO.BOARD)        # Use the numbers located on pins
        GPIO.setup(11, GPIO.IN)         # Read output from PIR motion sensor

        while True:
                input = 1 #GPIO.input(11)  # 0 for Low  :  1 for HIGH

                # If the sensor is reporting HIGH then it see's something
                if input == 1:
                        run_camera(sys.argv[1])

                time.sleep(0.1)

if __name__=="__main__":
        main(sys.argv)

