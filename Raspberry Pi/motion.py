#!/usr/bin/env python3

import RPi.GPIO as GPIO
from time import sleep

GPIO.setwarnings(False)         # Don't report warnings
GPIO.setmode(GPIO.BOARD)        # Use the numbers located on pins
GPIO.setup(11, GPIO.IN)         # Read output from PIR motion sensor

def motion_detected():
        while True:
                mode = GPIO.input(11)  # 0 for Low  :  1 for HIGH

                # If the sensor is reporting HIGH then it detects motion
                if mode == 1:
                        #print 'Intruder detected!'
                        return
                sleep(0.1)


#-----------------------------------------------------------------------------

def main():
        motion_detected()

if __name__=="__main__":
        main()
