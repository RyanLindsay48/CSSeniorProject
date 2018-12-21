from flask import Flask, url_for, render_template, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
import json

from Users import Users, UsersSchema
from households import Households, Households_Users, HouseholdsSchema, HouseholdsUsersSchema
from pictures import Pictures, PicturesSchema
from exposures import Exposures, Exposures_Pictures, ExposuresSchema, ExposuresPicturesSchema
from pi import Pi, Pi_Households, PiSchema, PiHouseholdsSchema
from base import app, db, ma;

connection = create_engine('mysql://spuser:SeniorProjectMysql987#$@localhost/spdb')
db.metadata.create_all(connection)

Session = sessionmaker(bind=connection)
session = Session()

# We could probably delete whatever of these we don't need
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
piHousehold_schema = PiHouseholdsSchema()
piHouseholds_schema = PiHouseholdsSchema(many=True)

@app.route("/create", methods=["POST"])
def new_user():
	if request.method == 'POST':
		data = request.get_json(force=True)
		'''
		If something here isn't working, try commenting out line 40 and changing the rest to:
		email_address = request.form['email_address']
		fname = request.form['fname']
		lname = request.form['lname']
		password = request.form['password']
		'''

		email_address = data['email_address']
		fname = data['fname']
		lname = data['lname']
		password = data['password']

	  	# Might be Users(email_address=email_address, fname=fname, lnam=lname, password=password)
		newUser = Users(email_address, fname, lname, password)
		session.add(newUser)
		session.commit()
	return user_schema.jsonify(newUser)

@app.route("/user", methods=["GET"])
def get_user():
	if request.method == 'GET':
		all_users = session.query(Users).all()
		result = users_schema.dump(all_users)
	return jsonify(result.data)

# Unused
@app.route("/user/name", methods=["GET"])
def get_user_by_name():
	if request.method == 'GET':
		fname  = request.args.get('fname', None)
		lname  = request.args.get('lname', None)
		user = session.query(Users).filter_by(fname=fname,lname=lname).one()
	return user_schema.jsonify(user)

@app.route("/user/<int:user_id>", methods=["PUT"])
def updateUser(user_id):
	editedUser = session.query(Users).filter_by(user_id = user_id).one()
	if request.method == 'PUT':
		data = request.get_json(force=True)
		#email_address = request.json['email_address']
		email_address = data['email_address']
		fname = data['fname']
		lname = data['lname']
		password = data['password']
		editedUser.email_address = email_address
		editedUser.fname = fname
		editedUser.lname = lname
		editedUser.password = password
		session.commit()
	return user_schema.jsonify(editedUser)

@app.route("/user/email_address/<string:email>", methods=["GET"])
def user_login(email):
	if request.method == 'GET':
		user = session.query(Users).filter_by(email_address=email).one()
		result = user_schema.dump(user)
		print (jsonify(result.data))
		#print (jsonify(user))
		#print(result)
		print(result.data)
	return (jsonify(result.data))

@app.route("/user/<int:user_id>/delete", methods=["DELETE"])
def user_delete(user_id):
	if request.method == 'DELETE':
		deletedUser = session.query(Users).filter_by(user_id = user_id)
		session.delete(deletedUser)
		session.commit()
	return user_schema.jsonify(deletedUser)

@app.route("/pi", methods=["POST"])
def new_pi():
	if request.method == 'POST':
		#pi_id = request.json['pi_id']
		data = request.get_json(force=True)
		location = data['location']
		#newPi = Pi(pi_id, location)
		newPi = Pi(location)
		session.add(newPi)
		session.commit()
	return 'bypassed'

@app.route("/pi", methods=["GET"])
def get_pi():
	if request.method == 'GET':
		all_pis = session.query(Pi).all()
		result = pis_schema.dump(all_pis)
	return jsonify(result.data)

@app.route("/pi/<int:pi_id>", methods=["PUT"])
def updatePi(pi_id):
	updatedPi = session.query(Pi).filter_by(pi_id = pi_id).one()
	if request.method == 'PUT':
		data = request.get_json()
		location = data['location']
		updatedPi.location = location
		session.commit()
	return pi_schema.jsonify(updatedPi)

@app.route("/pi/<int:pi_id>/delete", methods=["DELETE"])
def pi_delete(pi_id):
	if request.method == 'DELETE':
		deletedPi = session.query(Pi).filter_by(pi_id = pi_id)
		session.delete(deletedPi)
		session.commit()
	return pi_schema.jsonify(deletedPi)

@app.route("/pi/<int:pi_id>/reset", methods=["GET"])
def pi_reset(pi_id):
	if request.method == 'GET':
		pi = session.query(Pi).filter_br(pi_id=pi_id).one()
		pi_json = pi_schema.jsonify(pi)
	return pi_json['reset']

@app.route("/pi/sn/<int:serial_num>", methods=["GET"])
def get_pi_by_sn(serial_num):
        if request.method == 'GET':
                #serial_num = request.args.get('sn', None)
                pi = session.query(Pi).filter_by(serial_number=serial_num).one()
        return pi_schema.jsonify(pi)

@app.route("/exposure", methods=["POST"])
def new_exposure():
	if request.method == 'POST':
		#exposures_id = request.json['exposures_id']
		data = request.get_json(force=True)
		#print(data)
		pi_id = data['pi_id']
		#start_time = data['start_time'] #automatically set with datetime.today()
		#end_time = data['end_time'] #can't be set until exposure is done?
		newExposure = Exposures(pi_id)
		session.add(newExposure)
		session.commit()
		#session.flush()
		print(newExposure.exposures_id)
	return str(newExposure.exposures_id)

@app.route("/exposure", methods=["GET"])
def get_exposure():
	if request.method == 'GET':
		all_exposures = session.query(Exposures).all()
		result = exposures_schema.dump(all_exposures)
	return jsonify(result.data)

@app.route("/exposure/<int:exposures_id>", methods=["PUT"])
def updateExposure(exposures_id):
	updatedExposure = session.query(Exposures).filter_by(exposures_id = exposures_id)
	if request.method == 'PUT':
		data = request.get_json(force=True)
		pi_id = data['pi_id']
		end_time = data['end_time']
		updatedExposure.pi_id = pi_id
		updatedExposure.end_time = end_time
		session.commit()
	return exposure_schema.jsonify(updatedExposure)

@app.route("/exposure/<int:exposures_id>/pictures", methods=["POST"])
def newPicture(exposures_id):
	if request.method == 'POST':
		data = request.get_json(force=True)
		timestamp = data['timestamp']
		filepath = data['filepath']

		newPicture = Pictures(exposures)
	return

if __name__ == '__main__':
	app.debug=True
	app.run(host='0.0.0.0')
