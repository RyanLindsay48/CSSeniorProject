'''
Created on 5 November 2018

Creates an ORM model of the exposures table
'''
from datetime import datetime
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
from sqlalchemy import Column, String, PrimaryKeyConstraint, Index, ForeignKey, ForeignKeyConstraint
from sqlalchemy.dialects.mysql import SMALLINT, TIMESTAMP
from sqlalchemy.orm import relationship
from base import db, ma;

class Exposures(db.Model):
	__tablename__ = 'exposures'

	exposures_id = Column(SMALLINT(unsigned=True), nullable=False, primary_key=True)
	pi_id 		 = Column(SMALLINT, ForeignKey('pi.pi_id'), nullable=False) 
	start_time   = Column(TIMESTAMP, nullable=False)
	end_time 	 = Column(TIMESTAMP)

	pictures = relationship("Pictures", secondary="exposures_pictures", viewonly=True)

	def __init__(self, pi_id):
		self.pi_id = pi_id
		self.start_time = datetime.today()
		self.end_time = None


class ExposuresSchema(ma.Schema):
	class Meta:
		fields = ('exposures_id', 'pi_id', 'start_time', 'end_time')


class Exposures_Pictures(db.Model):
	__tablename__ = 'exposures_pictures'

	expo_pic_id  = Column(SMALLINT(unsigned=True), nullable=False, primary_key=True) 
	exposures_id = Column(SMALLINT, ForeignKey('exposures.exposures_id'), nullable=False)
	picture_id 	 = Column(SMALLINT, ForeignKey('pictures.picture_id'), nullable=False)

	exposure = relationship("Exposures", backref="exposures_pictures")
	picture  = relationship("Pictures", backref="exposures_pictures")

	__table_args__ = (
		PrimaryKeyConstraint('expo_pic_id', name='PRIMARY'),
		ForeignKeyConstraint(['exposures_id'], ['exposures.exposures_id']),
		ForeignKeyConstraint(['picture_id'], ['pictures.picture_id']) )

	def __init__(self, exposures_id, picture_id):
		self.exposures_id = exposures_id
		self.picture_id = picture_id


class ExposuresPicturesSchema(ma.Schema):
	class Meta:
		fields = ('expo_pic_id', 'exposures_id', 'picture_id')