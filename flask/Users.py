'''
Created on 5 November 2018

Creates an ORM model of the Users table
'''

from datetime import datetime
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
from sqlalchemy import Column, String, PrimaryKeyConstraint, Index, ForeignKey
from sqlalchemy.dialects.mysql import SMALLINT, TIMESTAMP, TINYINT
from sqlalchemy.orm import relationship
from base import db, ma;

class Users(db.Model) :
	__tablename__ = 'Users'

	user_id 		= Column(SMALLINT(unsigned=True), nullable=False, primary_key=True)
	email_address 	= Column(String(45), nullable=False, unique=True)
	fname 			= Column(String(45))
	lname			= Column(String(45))
	password		= Column(String(45))
	updated			= Column(TINYINT(unsigned=True), nullable=False)
	#phone_id		= Column(String(45))

	household = relationship("Households", secondary="households_users", viewonly=True)

	def __init__(self, email_address, fname, lname, password):
		self.email_address = email_address
		self.fname = fname
		self.lname = lname
		self.password = password
		self.updated = 0

	def __repr__(self):
		return "Users(user_id = {self.user_id}, " \
					"\n\temail_address = {self.email_address}," \
					"\n\tfname = {self.fname}," \
					"\n\tlname = {self.lname}," \
					"\n\tpassword = {self.password}," \
					"\n\tupdated = {self.updated}.format(self=self)" #," \
					#"\n\tphone_id = {self.phone_id}".format(self=self)


class UsersSchema(ma.Schema):
	class Meta:
		fields = ('user_id', 'email_address', 'fname', 'lname', 'password', 'updated')
