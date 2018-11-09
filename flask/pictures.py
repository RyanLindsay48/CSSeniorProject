'''
Created on 5 November 2018

Creates an ORM model of the pictures table
'''
from datetime import datetime
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
from sqlalchemy import Column, String, PrimaryKeyConstraint, Index, ForeignKey, ForeignKeyConstraint
from sqlalchemy.dialects.mysql import SMALLINT, TIMESTAMP
from sqlalchemy.orm import relationship
from base import db, ma;

class Pictures(db.Model):
	__tablename__ = 'pictures'

	picture_id = Column(SMALLINT(unsigned=True), nullable=False, primary_key=True)
	timestamp = Column(TIMESTAMP, nullable=False)
	filepath = Column(String(50), nullable=False)

	exposure = relationship("Exposures", secondary="exposures_pictures", viewonly=True)

	def __init__(self):
		self.timestamp = datetime.today()
		#Should exposures have a filepath and that just gets grabbed from there?
		self.filepath = ""


class PicturesSchema(ma.Schema):
	class Meta:
		fields = ('picture_id', 'timestamp', 'filename')