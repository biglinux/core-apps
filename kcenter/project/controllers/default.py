# -*- coding: utf-8 -*-
from project import app
from flask import render_template, request
import subprocess

def shutdown_server():
    func = request.environ.get('werkzeug.server.shutdown')
    if func is None:
        raise RuntimeError('Not running with the Werkzeug Server')
    func()

@app.route('/')
def start():
	from project.includes import kinfoservices
	services = kinfoservices.getservices()
	return render_template('default/index.html', services=services)
    
    
@app.route('/shutdown')
def shutdown():
    shutdown_server()
    return 'Server shutting down...'
    
@app.route('/execute', methods=['GET', 'POST'])
def execute():
	app =  request.values.get("service")
	a = subprocess.Popen("kcmshell4 "+str(app), stdin=None, stdout=subprocess.PIPE, shell=True)
	return "Success!!!"
