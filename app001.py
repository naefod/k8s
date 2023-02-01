from unittest import result
import json
from cgitb import reset
from flask import Flask, request, jsonify
from pymongo import MongoClient
from flask_pymongo import PyMongo
from flask_mongoengine import MongoEngine
from mongoengine import connect
import mongoengine as me
import urllib
from bson.json_util import dumps
from datetime import datetime, timedelta

app = Flask(__name__)
# host variables for MongoDB

app.config["MONGODB_DB"] = 'gitlabcddb'

DOMAIN = '172.20.202.200'
PORT = 31871
MONGO_HOST = "172.20.202.200" 
MONGO_PORT = "31871"
MONGO_DB = "gitlabcddb"
MONGO_USER = "root"
MONGO_PASS = urllib.parse.quote("p@ssw0rd4ate")

uri = "mongodb://root:" + urllib.parse.quote("p@ssw0rd4ate") + "@172.20.202.200:31871/gitlabcddb?authSource=admin"
app.config["MONGO_URI"] = uri
mongo = PyMongo(app)


db = MongoEngine(app)

class VersionInf():
    versionnum = db.StringField()
    versionuser = db.StringField()
    branch = db.StringField()
    pipelineurl = db.StringField()

    def __init__(self, versionnum, versionuser, branch, pipelineurl):
        db.Document.__init__(self, versionnum=versionnum)
        self.versionuser = versionuser
        self.branch = branch
        self.pipelineurl = pipelineurl


class K8sapp(db.Document):
    appname = db.StringField()
    username = db.StringField()
    facility = db.StringField()
    imagename = db.StringField()
    projecturl = db.StringField()
    appurl = db.StringField()
    applogs = db.StringField()
    version = db.ListField()

    def __init__(self, appname, username, facility, version, imagename, projecturl, appurl, applogs):
        db.Document.__init__(self, appname=appname)
        self.username = username
        self.facility = facility
        self.imagename = imagename
        self.projecturl = projecturl
        self.appurl = appurl
        self.applogs = applogs
        self.version = version


    def to_json(self):
        return {"appname": self.appname,
                "username": self.username,
                "facility": self.facility,
                "imagename": self.imagename,
                "projecturl": self.projecturl,
                "appurl": self.appurl,
                "applogs": self.applogs,
                "version": self.version}

    

@app.route('/', methods=['POST'])
def create_app():
    record = json.loads(request.data)
    k8sapp = K8sapp(appname=record['appname'],
                    username=record['username'], 
                    facility=record['facility'],
                    imagename=record['imagename'],
                    projecturl=record['projecturl'],
                    appurl=record['appurl'],
                    applogs=record['applogs'],
                    version=record['version']
                    )
    obj = k8sapp.to_json()
    mongo.db.user.insert_one(obj)
    return jsonify(k8sapp.to_json())


@app.route('/<facility>/<appname>', methods=['GET'])
def query_app(facility, appname):
    k8sapp = mongo.db.user.find({"facility": facility ,"appname": appname})
    if not k8sapp:
        return jsonify({'error': 'data not found'})
    else:
        return dumps(k8sapp)
    

@app.route('/u/<facility>/<appname>', methods=['POST'])
def update_app(facility, appname):
    record = json.loads(request.data)
    k8sapp = mongo.db.user.find({"facility": facility ,"appname": appname})
    if not k8sapp:
        return jsonify({'error': 'data not found'})
    else:
        mongo.db.user.update_one({'_id': k8sapp[0]['_id']}, {'$push': {"version": { '$each' :[{'versionnum':record['versionnum'],'versionuser':record['versionuser'], 'branch':record['branch'], 'pipelineurl':record['pipelineurl']}], '$position': 0, '$slice': 4}}})
        return (k8sapp[0]['version'])

@app.route('/delete/<facility>/<appname>', methods=['POST'])
def delete_app(facility, appname):
    k8sapp = mongo.db.user.find({"facility": facility ,"appname": appname})
    if not k8sapp:
        return jsonify({'error': 'data not found'})
    else:
        mongo.db.user.delete_many({'_id': k8sapp[0]['_id']})
        return ('documents deleted !!')

@app.route("/health")
def health():
    return ("it's up and running")

# Run Server
if __name__ == '__main__':
  app.run(debug=True, port=5000)