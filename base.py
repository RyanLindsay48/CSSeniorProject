'''
Created on 5 November 2018

Creates a declarative base constant that will be shared by other class modules
'''

from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow

app = Flask(__name__)
db = SQLAlchemy(app)
ma = Marshmallow(app)