#!/usr/bin/env python3

from picamera import PiCamera


# Setup camera with specified settings and initialize
def setup():
        camera = PiCamera()
        camera.start_preview()
        return camera


# Close current camera
def close(camera):
        camera.stop_preview()
        camera.close()


# Capture the image and return it
def capture_picture(camera, location, date_time):
        camera.annotate_text = date_time.strftime('%H:%M:%S')
        camera.capture(str(location))
