# -*- coding: utf-8 -*-
__version__ = '0.1'

# import flask
from flask import Flask

# create app
app = Flask('project')

# debug
app.debug = True

#import controllers
from project.controllers import *
