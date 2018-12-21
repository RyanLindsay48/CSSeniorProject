from flask import Flask, render_template, request, redirect, url_for, send_from_directory, jsonify
from flask_uploads import UploadSet, configure_uploads, IMAGES
import sys

app = Flask(__name__)

photos = UploadSet('photos', IMAGES)

app.config['UPLOADED_PHOTOS_DEST'] = 'piPics'
configure_uploads(app, photos)

@app.route('/')
def index():
	return '''<html><body><h1>'Hello World'</h1></body></html>'''

@app.route('/upload', methods=['GET', 'POST'])
def upload():
    if request.method == 'POST' and 'photo' in request.files:
	filename = photos.save(request.files['photo'])
        return redirect(url_for('uploaded_img', filename=filename))
    return render_template('upload.html')

@app.route('/uploads/<filename>')
def uploaded_img(filename):
	return send_from_directory(app.config['UPLOADED_PHOTOS_DEST'], filename)


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
