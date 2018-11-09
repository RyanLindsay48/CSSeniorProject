'''
Created 5 November 2018

Creates ORM model of the Households table
'''
from datetime import datetime
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
from sqlalchemy import Column, String, PrimaryKeyConstraint, Index, ForeignKey, ForeignKeyConstraint
from sqlalchemy.dialects.mysql import SMALLINT, TIMESTAMP
from sqlalchemy.orm import relationship
from base import db, ma;

class Households(db.Model) :
	__tablename__ = 'households'

	household_id 	= Column(SMALLINT(unsigned=True), nullable=False, primary_key=True)
	street_address 	= Column(String(45), nullable=False, unique=True)
	apartment_num 	= Column(String(45))
	city			= Column(String(45), nullable=False)
	state			= Column(String(45), nullable=False)
	zip_code		= Column(String(45), nullable=False)

	users = relationship("Users", secondary="households_users", viewonly=True)

	def __init__(self, street_address, apartment_num, city, state, zip_code):
		self.street_address = street_address
		self.apartment_num = apartment_num
		self.city = city
		self.state = state
		self.zip_code = zip_code

	def __repr__(self):
		return "Households(household_id = {self.household_id}, " \
					"\n\tstreet_address = {self.street_address}," \
					"\n\tapartment_num = {self.apartment_num}," \
					"\n\tcity = {self.city}," \
					"\n\tstate = {self.state}," \
					"\n\tzip_code = {self.zip_code}".format(self=self)


class HouseholdsSchema(ma.Schema):
	class Meta:
		fields = ('household_id', 'street_address', 'apartment_num', 'city', 'state', 'zip_code')


class Households_Users(db.Model):
	__tablename__ = 'households_users'

	house_user_id = Column(SMALLINT(unsigned=True), nullable=False, primary_key=True)
	household_id  = Column(SMALLINT(unsigned=True), ForeignKey('households.household_id'), nullable=False)
	user_id 	  = Column(SMALLINT(unsigned=True), ForeignKey('Users.user_id'), nullable=False)

	house = relationship("Households", backref="households_users")
	user  = relationship("Users", backref="households_users")

	__table_args__ = (
		PrimaryKeyConstraint('house_user_id', name='PRIMARY'),
		ForeignKeyConstraint(['household_id'], ['households.household_id']),
		ForeignKeyConstraint(['user_id'], ['Users.user_id']) )

	def __init__(self, household_id, user_id):
		self.household_id = household_id
		self.user_id = user_id

class HouseholdsUsersSchema(ma.Schema):
	class Meta:
		fields = ('house_user_id', 'household_id', 'user_id')