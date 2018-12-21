from flask import Flask, url_for, render_template, send_file, send_from_directory, request, jsonify
from flask_uploads import UploadSet, configure_uploads, IMAGES
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
from sqlalchemy import create_engine, or_, desc
from sqlalchemy.orm import sessionmaker
from zipfile import ZipFile
from io import BytesIO
import json
import os


from Users import Users, UsersSchema
from households import Households, Households_Users, HouseholdsSchema, HouseholdsUsersSchema
from pictures import Pictures, PicturesSchema
from exposures import Exposures, Exposures_Pictures, ExposuresSchema, ExposuresPicturesSchema
from pi import Pi, PiSchema
from base import app, db, ma;

connection = create_engine('mysql://spuser:SeniorProjectMysql987#$@localhost/spdb')
db.metadata.create_all(connection)

Session = sessionmaker(bind=connection)
session = Session()

# Schemas used to parse database
user_schema = UsersSchema()
users_schema = UsersSchema(many=True)
household_schema = HouseholdsSchema()
households_schema = HouseholdsSchema(many=True)
householdsUser_schema = HouseholdsUsersSchema()
householdsUsers_schema = HouseholdsUsersSchema(many=True)
exposure_schema = ExposuresSchema()
exposures_schema = ExposuresSchema(many=True)
exposuresPicture_schema = ExposuresPicturesSchema()
exposuresPictures_schema = ExposuresPicturesSchema(many=True)
picture_schema = PicturesSchema()
pictures_schema = PicturesSchema(many=True)
pi_schema = PiSchema()
pis_schema = PiSchema(many=True)


@app.route("/users", methods=["GET"])
def users():
	# Get all users in the database
	if request.method == 'GET':
		all_users = session.query(Users).all()
		result = users_schema.dump(all_users)
		return jsonify(result.data)

	return

@app.route("/user", methods=["GET", "PUT", "POST", "DELETE"])
def user():
	user_id = request.args.get('id')
	email_address = request.args.get('email')
	fname = request.args.get('fname')
	lname = request.args.get('lname')
	password = request.args.get('password')
	if (user_id == None) and (email_address == None) and (fname == None) and (lname == None) and (password == None):
		data = request.get_json(force=True)
		if request.method in {'GET', 'PUT', 'DELETE'}:
			user_id = data['user_id']
		if request.method in {'PUT', 'POST'}:
			email_address = data['email_address']
			fname = data['fname']
			lname = data['lname']
			password = data['password']


	# Get a specific user based on user id
	if request.method == 'GET':
		user = session.query(Users).filter_by(user_id=user_id).one()
		return user_schema.jsonify(user)

	# Update a specific user based on user id and new information
	if request.method == 'PUT':
		editedUser = session.query(Users).filter_by(user_id=user_id).one()
		editedUser.email_address = email_address
		editedUser.fname = fname
		editedUser.lname = lname
		editedUser.password = password

		session.commit()
		return user_schema.jsonify(editedUser)

	# Create a new user
	if request.method == 'POST':
		newUser = Users(email_address, fname, lname, password)

		session.add(newUser)
		session.commit()
		return user_schema.jsonify(newUser)

	# Delete at existing user
	if request.method == 'DELETE':
		deletedUser = session.query(Users).filter_by(user_id=user_id).one()

		session.delete(deletedUser)
		session.commit()
		return user_schema.jsonify(deletedUser)

	return

#-----------------------------------------------------------------------------

@app.route("/households", methods=["GET"])
def households():
	# Grab all households in the database
	if request.method == 'GET':
		all_households = session.query(Households).all()
		result = households_schema.dump(all_households)
		return jsonify(result.data)

	return

@app.route("/household", methods=["GET", "PUT", "POST", "DELETE"])
def household():
	household_id = request.args.get('household_id')
	user_id = request.args.get('user_id')
	street_address = request.args.get('street_address')
	apartment_num = request.args.get('apartment_num')
	city = request.args.get('city')
	state = request.args.get('state')
	zip_code = request.args.get('zip_code')
	if (user_id == None) and (household_id == None) and (street_address == None) and (apartment_num == None) and (city == None) and (state == None) and (zip_code == None):
		data = request.get_json(force=True)
		if request.method in {'GET', 'PUT', 'DELETE'}:
			household_id = data['household_id']
		if request.method in {'PUT', 'POST'}:
			street_address = data['street_address']
			apartment_num = data['apartment_num']
			city = data['city']
			state = data['state']
			zip_code = data['zip_code']
		if request.method in {'POST'}:
			user_id = data['user_id']


	# Get a specific household based on household id
	if request.method == 'GET':
		household = session.query(Households).filter_by(household_id=household_id).one()
		return household_schema.jsonify(household)

	# Update a specific households information
	if request.method == 'PUT':
		editedUser = session.query(Households).filter_by(household_id=household_id).one()
		editedUser.street_address = street_address
		editedUser.apartment_num = apartment_num
		editedUser.city = city
		editedUser.state = state
		editedUser.zip_code = zip_code

		session.commit()
		return household_schema.jsonify(editedUser)

	# Create a new household based on household id and information given
	if request.method == 'POST':
		newHousehold = Households(street_address, apartment_num, city, state, zip_code)
		session.add(newHousehold)
		session.commit()

		# Create a link to the user in the linking table
		newHouseholdUser = Households_Users(newHousehold.household_id, int(user_id))
		session.add(newHouseholdUser)
		session.commit()

		return household_schema.jsonify(newHousehold)

	# Delete a specific household from the database
	if request.method == 'DELETE':
		deletedHousehold = session.query(Households).filter_by(household_id=household_id).one()

		session.delete(deletedHousehold)
		session.commit()
		return household_schema.jsonify(deletedHousehold)

	return

#-----------------------------------------------------------------------------

@app.route("/pis", methods=["GET"])
def pis():
	# Grab all pis in the database
	if request.method == 'GET':
		all_pis = session.query(Pi).all()
		result = pis_schema.dump(all_pis)
		return jsonify(result.data)

	return

@app.route("/pi", methods=["GET", "PUT", "POST", "DELETE"])
def pi():
	pi_id = request.args.get('pi_id', None)
	user_id = request.args.get('user_id', None)
	location = request.args.get('location', None)
	serial_number = request.args.get('serial_number', None)
	if (pi_id == None) and (user_id == None) and (location == None) and (serial_number == None):
		data = request.get_json()
		if request.method in {'GET', 'PUT', 'DELETE'}:
			pi_id = data['pi_id']
		if request.method in {'PUT', 'POST'}:
			user_id = data['user_id']
			location = data['location']
			serial_number = data['serial_number']


	# Get a specific pi based on pi id
	if request.method == 'GET':
		pi = session.query(Pi).filter_by(pi_id=pi_id).one()
		return pi_schema.jsonify(pi)

	# Update a specific pi based on pi id and information given
	if request.method == 'PUT':
		updatedPi = session.query(Pi).filter_by(pi_id=pi_id).one()
		updatedPi.user_id = user_id
		updatedPi.location = location

		session.commit()
		return pi_schema.jsonify(updatedPi)

	# Create a new pi in the database
	if request.method == 'POST':
		newPi = Pi(user_id, location, serial_number)

		session.add(newPi)
		session.commit()
		return pi_schema.jsonify(newPi)

	# Delete an existing pi from the database
	if request.method == 'DELETE':
		deletedPi = session.query(Pi).filter_by(pi_id=pi_id).one()

		session.delete(deletedPi)
		session.commit()
		return pi_schema.jsonify(deletedPi)

	return

#-----------------------------------------------------------------------------

@app.route("/exposures", methods=["GET"])
def exposures():
	# Grab all exposures in the database
	if request.method == 'GET':
		all_exposures = session.query(Exposures).all()
		result = exposures_schema.dump(all_exposures)
		return jsonify(result.data)

	return

@app.route("/exposure", methods=["GET", "PUT", "POST", "DELETE"])
def exposure():
	pi_id = request.args.get('pi_id', None)
	expo_id = request.args.get('expo_id', None)
	if (expo_id == None) and (pi_id == None):
		data = request.get_json(force=True)
		if request.method in {'GET', 'PUT', 'DELETE'}:
			expo_id = data['expo_id']
		if request.method in {'PUT', 'POST'}:
			pi_id = data['pi_id']


	# Get a specific exposure in the database based on exposure id
	if request.method == 'GET':
		exposure = session.query(Exposures).filter_by(exposures_id=expo_id).one()
		return exposure_schema.jsonify(exposure)

	# Update an existing exposure based on the exposure id
	if request.method == 'PUT':
		updatedExposure = session.query(Exposures).filter_by(exposures_id=expo_id).one()
		updatedExposure.pi_id = pi_id

		session.commit()
		return exposure_schema.jsonify(updatedExposure)

	# Create a new exposure in the database using information given
	if request.method == 'POST':
		newExposure = Exposures(pi_id)

		session.add(newExposure)
		session.commit()

		### Delete this to put it back to normal
		# Notify the user that a new exposure has been created
		user_pi = session.query(Pi).filter_by(pi_id=pi_id).one()
		user_id = row2dict(user_pi)['user_id']
		updatedUser = session.query(Users).filter_by(user_id=user_id).one()
		updatedUser.updated = 1
		session.commit()
		###

		return exposure_schema.jsonify(newExposure)

	# Delete an existing exposure from the database
	if request.method == 'DELETE':
		deletedExposure = session.query(Exposures).filter_by(exposures_id=expo_id).one()

		session.delete(deletedExposure)
		session.commit()
		return exposure_schema.jsonify(deletedExposure)

	return

#-----------------------------------------------------------------------------

@app.route("/exposure/pictures", methods=["GET"])
def exposure_pics():
	# Get all pictures that match an exposure
	if request.method == 'GET':
		expo_id = request.args.get('expo_id', None)
		if expo_id == None:
			data = request.get_json(force=True)
			expo_id = data['expo_id']

		pic_list = []

		# Grab all pictures for the exposure
		pic_query = session.query(Exposures_Pictures).filter_by(exposures_id=expo_id).all()
		for pic in pic_query:
			pic_dict = row2dict(pic)
			pic_list.append(int(pic_dict['picture_id']))
		pictures = session.query(Pictures).filter(Pictures.picture_id.in_(pic_list)).all()

		# Create a json to of all pictures
		results = pictures_schema.dump(pictures)
		return jsonify(results.data)

	return

@app.route("/exposure/picture", methods=["GET", "POST"])
def exposure_pic():
	# Get a single picture from an exposure
	if request.method == 'GET':
		image_name = request.args.get('image_name', None)
		pi_id = request.args.get('pi_id', None)
		expo_id = request.args.get('expo_id', None)
		if (image_name == None) and (pi_id == None) and (expo_id == None):
			data = request.get_json(force=True)
			image_name = data['image_name']
			pi_id = data['pi_id']
			expo_id = data['expo_id']

		# Construct filepath from information provided
		expo_dir = os.path.expanduser('~') + '/Pictures/' + pi_id + '/' + expo_id

		# Send image from server to url
		return send_from_directory(expo_dir, image_name, as_attachment=True)

	# Add a new picture to an exposure
	if request.method == 'POST':
		# Grab required information from the request
		timestamp = request.form['timestamp']
		filename = request.form['filename']
		pi_id = request.form['pi_id']
		expo_id = request.form['expo_id']
		image_capture = request.files['photo']

		# Check that the directory for the pi is on the server
		pi_base = os.path.expanduser('~') + '/Pictures/'
		pi_dir = pi_base + pi_id
		if not os.path.exists(pi_dir):
			os.makedirs(pi_dir)

		# Check that the specific exposure directory is there
		expo_base = os.path.expanduser('~') + '/Pictures/' + pi_id + '/'
		expo_dir = expo_base + expo_id
		if not os.path.exists(expo_dir):
			os.makedirs(expo_dir)

		# Create picture specific filepath
		pic_path = expo_dir + '/' + filename

		# Save image to server
		photos = UploadSet('photos', IMAGES)
		app.config['UPLOADED_PHOTOS_DEST'] = expo_dir
		configure_uploads(app, photos)
		photos.save(image_capture)

		# Save image information to database
		# Create and save new picture
		newPicture = Pictures(pic_path)
		session.add(newPicture)
		session.commit()

		# Save link to exposure_pictures
		newExposure = Exposures_Pictures(expo_id, newPicture.picture_id)
		session.add(newExposure)
		session.commit()

		''' Uncomment this to put it back to previous
		# Update user to let them know new exposures
		user_pi = session.query(Pi).filter_by(pi_id=pi_id).one()
		user_id = row2dict(user_pi)['user_id']
		updatedUser = session.query(Users).filter_by(user_id=user_id).one()
		updatedUser.updated = 1
		session.commit()
		'''

		return picture_schema.jsonify(newPicture)

	return

#-----------------------------------------------------------------------------

@app.route("/user/login", methods=["GET"])
def user_login():
	# Grab a specific user based on their email address
        if request.method == 'GET':
                email = request.args.get('email', None)
                if email == None:
                        data = request.get_json(force=True)
                        email = data['email']
                user = session.query(Users).filter_by(email_address=email).one()
                return user_schema.jsonify(user)

        return

@app.route("/user/pis", methods=["GET"])
def user_pis():
	# Get all pis associated with a user
	if request.method == 'GET':
		user_id = request.args.get('id', None)
		if user_id == None:
			user_id = request.get_json(force=True)
		all_pis = session.query(Pi).filter_by(user_id=user_id).all()
		result = pis_schema.dump(all_pis)
		return jsonify(result.data)

	return

@app.route("/user/updated", methods=["GET", "PUT"])
def user_updated():
	user_id = request.args.get('user_id', None)
	updated = request.args.get('value', None)
	if (user_id == None) and (updated == None):
		data = request.get_json(force=True)
		if request.method in {'GET', 'PUT'}:
			user_id = data['user_id']
		if request.method in {'PUT'}:
			updated = data['value']


	# Return a user given the user id provided
	if request.method == 'GET':
		user = session.query(Users).filter_by(user_id=user_id).one()
		return user_schema.jsonify(user)

	# Modify the updated parameter to value provided
	if request.method == 'PUT':
		user = session.query(Users).filter_by(user_id=user_id).one()
		user.updated = updated
		session.commit()
		return user_schema.jsonify(user)
	return

@app.route("/user/household", methods=["GET"])
def user_household():
	# Get the household based on the user id
	if request.method == 'GET':
		user_id = request.args.get('user_id', None)
		if user_id == None:
			data = request.get_json('user_id', None)
			user_id = data['user_id']


		# Grab the first link that matches a user id
		household_user = session.query(Households_Users).filter_by(user_id=user_id).one()
		household_user_dict = row2dict(household_user)
		household_user_id = int(household_user_dict['household_id'])

		household = session.query(Households).filter_by(household_id=household_user_id).one()
		return household_schema.jsonify(household)
	return

@app.route("/pi/exposures", methods=["GET"])
def pi_exposures():
	# Grab all exposures associated with a specific pi
	if request.method == 'GET':
		pi_id = request.args.get('pi_id', None)
		if pi_id == None:
			data = request.get_json(force=True)
			pi_id = data['pi_id']

		# Return a json of all exposures for a pi
		all_expos = session.query(Exposures).filter_by(pi_id=pi_id).all()
		result = exposures_schema.dump(all_expos)
		return jsonify(result.data)

	return

@app.route("/pi/reset", methods=["GET", "PUT"])
def pi_reset():
	pi_id = request.args.get('pi_id', None)
	reset = request.args.get('value', None)
	if (pi_id == None) and (reset == None):
		data = request.get_json(force=True)
		if request.method in {'GET', 'PUT'}:
			pi_id = data['pi_id']
		if request.method in {'PUT'}:
			reset = data['value']


	# Return a pi using the provided pi id
	if request.method == 'GET':
		pi = session.query(Pi).filter_by(pi_id=pi_id).one()
		return pi_schema.jsonify(pi)

	# Update the reset variable based on the user value provided
	if request.method == 'PUT':
		pi = session.query(Pi).filter_by(pi_id=pi_id).one()
		pi.reset = reset
		session.commit()
		return pi_schema.jsonify(pi)
	return

@app.route("/pi/sn", methods=["GET"])
def pi_sn():
	# Grab a pi based on the serial number
	if request.method == 'GET':
		pi_sn = request.args.get('sn', None)
		if pi_sn == None:
			data = request.get_json(force=True)
			pi_sn = data['pi_sn']

		pi = session.query(Pi).filter_by(serial_number=pi_sn).first()
		return pi_schema.jsonify(pi)

	return

@app.route("/exposure/recent", methods=["GET"])
def exposure_recent():
	user_id = request.args.get('id', None)
	if user_id == None:
		data = request.get_json(force=True)
		user_id = data['user_id']


	# Get the most recent exposure
	if request.method == 'GET':
		# Create a lists to store required information to
		pi_id_list = []
		expo_id_list = []
		expo_temp_list = []
		pic_id_list = []

		# Grab all pi's for that user
		for pi in session.query(Pi).filter_by(user_id=user_id).all():
			pi_dict = row2dict(pi)
			#pi_dict = dict(pi)
			pi_id_list.append(int(pi_dict['pi_id']))

		# Grab most recent exposures for the pi id's
		expo_list = session.query(Exposures).order_by(Exposures.start_time.desc()).filter(Exposures.pi_id.in_(pi_id_list)).first()
		expo_dict = row2dict(expo_list)
		expo_id_list.append(expo_dict['exposures_id'])

		# Grab all pictures for the exposures
		for expo in expo_id_list:
			pic_list = session.query(Exposures_Pictures).filter_by(exposures_id=expo)
			for pic in pic_list:
				pic_dict = row2dict(pic)
				pic_id_list.append(pic_dict['picture_id'])

		# Gather all matching pictures
		pics = session.query(Pictures).filter(Pictures.picture_id.in_(pic_id_list)).all()
		return pictures_schema.jsonify(pics)

	return

# Random function since dict(query) decided to not work
def row2dict(row):
    d = {}
    for column in row.__table__.columns:
        d[column.name] = str(getattr(row, column.name))

    return d

#-----------------------------------------------------------------------------

if __name__ == '__main__':
	app.debug=True   # Causes issues with uploading images to the server
	app.run()
	#(host='0.0.0.0')

