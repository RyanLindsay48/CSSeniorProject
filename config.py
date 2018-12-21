import os

basedir = os.path.abspath(os.path.dirname(__file__))
SQLALCHEMY_ECHO = False
SQLALCHEMY_TRACK_MODIFICATIONS = True
SQLALCHEMY_DATABASE_URI = app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://spuser:SeniorProjectMysql987#$@localhost/spdb'
