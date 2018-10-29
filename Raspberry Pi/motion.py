#!/usr/bin/env python3

import RPi.GPIO as GPIO
import time


def motion_detected():
        GPIO.setwarnings(False)         # Don't report warnings
        GPIO.setmode(GPIO.BOARD)        # Use the numbers located on pins
        GPIO.setup(11, GPIO.IN)         # Read output from PIR motion sensor

        while True:
                input = 1  # 0 for Low  :  1 for HIGH
                           # Set to high for testing purposes

                # If the sensor is reporting HIGH then it see's something
                if input == 1:
                        return
                time.sleep(0.1)



#-----------------------------------------------------------------------------

def main():
        motion_detected()

if __name__=="__main__":
        main()
