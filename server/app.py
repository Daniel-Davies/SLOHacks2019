from flask import Flask, render_template, request, jsonify, redirect, Response
from flask_mail import Message
from flask_mail import Mail

import requests
import os
import pickle

app =Flask(__name__)

mail=Mail(app)

app.config['MAIL_SERVER']='smtp.gmail.com'
app.config['MAIL_PORT'] = 465
app.config['MAIL_USERNAME'] = 'callmedanemailacc@gmail.com'
app.config['MAIL_PASSWORD'] = 'Danio12345'
app.config['MAIL_USE_TLS'] = False
app.config['MAIL_USE_SSL'] = True

mail = Mail(app)
session_tracker = []

class SessionTracker():
    def __init__(self):
        self.currentEmail = ""

    def updateSession(self, x):
        self.currentEmail = x

    def getIt(self):
        return self.currentEmail
    

@app.route('/omg', methods=["GET", "POST"])
def omg():
    res = requests.post('http://localhost:5000/sendMail', json={"name":"Daniel", "organisation":"Facebook", "email":"daviesdg@uci.edu", "message":"Hello"})
    print (res)
    return redirect("/")

@app.route('/sendMail', methods=["GET", "POST"])
def sendMail():
    content = request.json
    name = content["name"]
    organisation = content["organisation"]
    email = content["email"]
    message = content["message"]
    msg = Message(message,
                  sender=email,
                  recipients=[email])
    mail.send(msg)
    return redirect("/")

@app.route('/allevents', methods=["GET"])
def allEvents():
    #sort by date
    retVal = []

    imgs = ["https://pbs.twimg.com/media/DybYTOaW0AACWjX.jpg", "https://images.pexels.com/photos/248797/pexels-photo-248797.jpeg", "https://images.pexels.com/photos/34950/pexels-photo.jpg", "https://images.pexels.com/photos/257840/pexels-photo-257840.jpeg", "https://images.pexels.com/photos/4827/nature-forest-trees-fog.jpeg", "https://images.pexels.com/photos/462118/pexels-photo-462118.jpeg", "https://images.pexels.com/photos/302804/pexels-photo-302804.jpeg", "https://images.pexels.com/photos/145939/pexels-photo-145939.jpeg", "https://images.pexels.com/photos/158607/cairn-fog-mystical-background-158607.jpeg", "https://images.pexels.com/photos/247431/pexels-photo-247431.jpeg"]
    names = ["Event1", "Event2", "Event3", "Event4", "Event5", "Event6", "Event7", "Event8", "Event9", "EventA"]
    charities = ["Char1", "Char2", "Char3", "Char4", "Char5", "Char6", "Char7", "Char8", "Char9", "CharA"]
    dates = ["02/02/19", "02/03/19", "02/04/19", "02/05/19", "02/06/19", "02/07/19", "02/08/19", "02/09/19", "02/10/19", "02/1/19"]
    descs = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
    
    for i in range(10):    
        testDict = {}
        testDict['pictureUrl'] = imgs[i]
        testDict['name'] = names[i]
        testDict['charity'] = charities[i]
        testDict['date'] = dates[i]
        testDict['description'] = descs[i]
        retVal.append(testDict)
    
    return jsonify(retVal)

@app.route('/')
def landing():
    return render_template("landing.html")

@app.route("/getusers")
def dasdass():
    k = {}
    with open('userdata', 'rb') as handle:
        k = pickle.load(handle)
        print(k)
    return jsonify(k)

@app.route("/login", methods=["POST"])
def login():
    data_dict = {}
    x = request.form['login_email']
    session_tracker.updateSession(x)
    with open('charitydata', 'rb') as handle:
        data_dict = pickle.load(handle)
        print(data_dict)
    
    try:
        data = data_dict[x]
        return render_template("fff.html", Name=data[0])
    except:
        return render_template("landing.html")

@app.route('/past')
def past():
    return render_template("past.html")

@app.route('/createuser', methods=["POST"])
def createuser():
    data_dict = {}
    content = request.json
    with open('userdata', 'rb') as handle:
        data_dict = pickle.load(handle)
    data_dict[content['email']] = content['name']
    with open('userdata', 'wb') as handle:
        pickle.dump(data_dict, handle)
    response = Response(status=200)
    return response

@app.route('/createevent', methods=["POST"])
def createevent():
    data_dict = {}
    content = request.json
    with open('eventdata', 'rb') as handle:
        data_dict = pickle.load(handle)
    data_dict[content['email']] = content['name']
    with open('eventdata', 'wb') as handle:
        pickle.dump(data_dict, handle)
    response = Response(status=200)
    return response

@app.route('/charity')
def charitypage():
    return render_template("createuser.html")

@app.route('/createcharity', methods=["POST"])
def createcharity():
    x1 = request.form['name']
    x2 = request.form['email']
    x3 = request.form['phone']
    data_dict = {}
    with open('charitydata', 'rb') as handle:
        data_dict = pickle.load(handle)
        print(data_dict)
    data_dict[x2] = [x1 ,x3]
    with open('charitydata', 'wb') as handle:
        pickle.dump(data_dict, handle)
    response = Response(status=200)
    return redirect("/")

@app.route('/mkay/<email>')
def cjsdjd(email):
    res = requests.post('http://localhost:5000/createuser', json={"name":"Daniel", "email":email})
    print (res)
    return "5"

if __name__ == '__main__':
    app.debug = True
    b = {}
    if (not os.path.isfile(os.getcwd() + "/userdata")):
        with open('userdata', 'wb') as handle:
            pickle.dump(b, handle)
        
    if (not os.path.isfile(os.getcwd() + "/charitydata")):
        with open('charitydata', 'wb') as handle:
            pickle.dump(b, handle)
        
    if (not os.path.isfile(os.getcwd() + "/charitydata")):
        with open('eventdata', 'wb') as handle:
            pickle.dump(b, handle)
    
    session_tracker = SessionTracker()
    app.run(host = '0.0.0.0',port=5000)
