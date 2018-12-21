'''
Created on 5 November 2018

Creates an ORM model of the pi table
'''
from datetime import datetime
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
from sqlalchemy import Column, String, PrimaryKeyConstraint, Index, ForeignKey, ForeignKeyConstraint
from sqlalchemy.dialects.mysql import SMALLINT, TINYINT, TIMESTAMP
from sqlalchemy.orm import relationship, backref
from base import db, ma;

class Pi(db.Model):
	__tablename__ = 'pi'

	pi_id = Column(SMALLINT(unsigned=True), nullable=False, primary_key=True)
	user_id = Column(SMALLINT(unsigned=True), ForeignKey('Users.user_id'), nullable=False)
	location = Column(String(25), nullable=False)
	serial_number = Column(String(16), nullable=False, unique=True)
	reset = Column(TINYINT(unsigned=True), nullable=False)

	user = relationship("Users", backref=backref('pi'))
	#household = relationship("Households", secondary="pi_households", viewonly=True)

	def __init__(self, user_id, location, serial_number):
		self.user_id = user_id
		self.location = location
		self.reset = 0
		self.serial_number = serial_number

	__table_args__ = (
		PrimaryKeyConstraint('pi_id', name='PRIMARY'),
		#ForeignKeyConstraint(['user_id'], ['Users.user_id'])
	)

class PiSchema(ma.Schema):
	class Meta:
		fields = ('pi_id', 'user_id', 'location', 'reset', 'serial_number')


'''
class Pi_Households(db.Model):
	__tablename__ = 'pi_households'

	pi_house_id = Column(SMALLINT(unsigned=True), nullable=False, primary_key=True)
	household_id = Column(SMALLINT, ForeignKey('households.household_id'), nullable=False)
	pi_id = Column(SMALLINT, ForeignKey('pi.pi_id'), nullable=False)

	pi = relationship("Pi", backref="pi_households")
	household = relationship("Households", backref="pi_households")

	__table_args__ = (
		PrimaryKeyConstraint('pi_house_id', name='PRIMARY'),
		ForeignKeyConstraint(['household_id'], ['households.household_id']),
		ForeignKeyConstraint(['pi_id'], ['pi.pi_id']) )

	def __init__(self, household_id, pi_id):
		self.household_id = household_id
		self.pi_id = pi_id


class PiHouseholdsSchema(ma.Schema):
	class Meta:
		fields = ('pi_house_id', 'household_id', 'pi_id')
'''
