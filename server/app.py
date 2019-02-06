from flask import Flask, render_template, request, jsonify, redirect, Response
from flask_mail import Message
from flask_mail import Mail

import requests
import os
import pickle
import random 

app =Flask(__name__)

mail=Mail(app)

app.config['MAIL_SERVER']='smtp.gmail.com'
app.config['MAIL_PORT'] = 465
app.config['MAIL_USERNAME'] = 'callmedanemailacc@gmail.com'
app.config['MAIL_PASSWORD'] = ''
app.config['MAIL_USE_TLS'] = False
app.config['MAIL_USE_SSL'] = True

mail = Mail(app)
session_tracker = []

class SessionTracker():
    def __init__(self):
        self.currentEmail = ""
        self.currentName = ""
        self.genericImgURLs = ["https://content-calpoly-edu.s3.amazonaws.com/orientation/1/images/our-team/join-us/wowLeaders.jpg", "https://www.volunteer.va.gov/images/youth01.jpg", "https://www.utdallas.edu/news/imgs/photos-2013-11/student-volunteers-700-2013-11.jpg", "https://www.signupgenius.com/cms/images/college/college-volunteers.jpg"]
        self.salvation = "https://salvationarmynorth.org/wp-content/uploads/2015/01/Volunteer-story-562x374.jpg"
        self.dog = "https://i0.wp.com/www.pawsforirvinganimals.org/wp-content/uploads/2014/02/volunteer3.jpg"
        self.kid = "https://www.adoptuskids.org/_assets/images/AUSK/pages/ways-to-help-575x385.jpg"

    def updateSession(self, x, y):
        self.currentEmail = x
        self.currentName = y

    def getEmail(self):
        return self.currentEmail
    
    def getName(self):
        return self.currentName
    
    def getImage(self, x=0):
        if (x == 0):
            return random.choice(self.genericImgURLs)
        elif (x == 1):
            return self.salvation
        elif (x == 2):
            return self.dog
        else:
            return self.kid
    
    def getAllImages():
        return self.genericImgURLs


@app.route("/checkin/<email>", methods=["GET", "POST"])
def auth(email):
    ##actually add the points here
    other_data_dict = {}
    with open('userdata', 'rb') as handle:
        other_data_dict = pickle.load(handle)

    try:
        other_data_dict[email]['points'] = other_data_dict[email]['points'] + 20
        send_name = other_data_dict[email]['name']
        return render_template("auth.html", Person_name=send_name)
    except:
        return render_template("auth.html", Person_name="Daniel")
    

@app.route("/redeem", methods=["POST"])
def redeem():
    #remove points
    content = request.json
    points = content['points']
    email = content['email']
    other_data_dict = {}

    with open('userdata', 'rb') as handle:
        other_data_dict = pickle.load(handle)

    other_data_dict[email]['points'] = other_data_dict[email]['points'] - points

    with open('userdata', 'wb') as handle:
        pickle.dump(other_data_dict, handle)

    res = requests.post('http://localhost:5000/sendMail', json={"name":"Daniel", "organisation":"UCI", "email":"chase19@ymail.com", "message":"You've redeemed "+ content['product']})
    response = Response(status=200)
    return response
    
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

@app.route("/register", methods=["POST"])
def register():
    content = request.json
    email = content['email']
    name = content['Organization']
    event = content['EventName']
    data_dict = {}
    with open('eventdata', 'rb') as handle:
        data_dict = pickle.load(handle)
    
    data_dict[name+event]['UserList'].append(email)
    with open('eventdata', 'wb') as handle:
        pickle.dump(data_dict, handle)

    response = Response(status=200)
    return response

@app.route('/host', methods=["GET", "POST"])
def host():
    return render_template("hostevent.html")

@app.route('/createhost', methods=["POST"])
def createhost():
    x1 = request.form['Organization']
    x2 = request.form['EventName']
    x3 = request.form['Description']
    x4 = request.form['Location']
    x5 = request.form['Day/Time']

    data_dict = {}
    with open('eventdata', 'rb') as handle:
        data_dict = pickle.load(handle)
    picType = 0
    if ("animal" in x2 or "animal" in x3):
        picType = 2
    elif ("child" in x2 or "child" in x3):
        picType = 3
    elif ("homeless" in x2 or "homeless" in x3):
        picType = 1

    data_dict[x1+x2] = {'Charity':x1, 'EventName':x2, 'Description':x3, 'Location':x4, 'DateTime':x5, 'UserList':[], 'pictureUrl':session_tracker.getImage(picType)}
    with open('eventdata', 'wb') as handle:
        pickle.dump(data_dict, handle)
    return redirect("/alreadyLogged")

@app.route('/allevents', methods=["GET"])
def allEvents():
    #sort by date
    retVal = []
    data_dict = {}
    with open('eventdata', 'rb') as handle:
        data_dict = pickle.load(handle)
    
    for i in data_dict.keys():    
        testDict = {}
        testDict['pictureUrl'] = data_dict[i]['pictureUrl']
        testDict['EventName'] = data_dict[i]['EventName']
        testDict['Charity'] = data_dict[i]['Charity']
        testDict['DateTime'] = data_dict[i]['DateTime']
        testDict['Description'] = data_dict[i]['Description']
        retVal.append(testDict)
    
    retVal = retVal[::-1]
    return jsonify(retVal)

@app.route('/')
def landing():
    return render_template("landing.html")

@app.route("/getusers")
def dasdass():
    k = {}
    retVal = []

    with open('userdata', 'rb') as handle:
        k = pickle.load(handle)
    dataList = [(i, k[i]['points']) for i in k.keys()]
    new = sorted(dataList, key=lambda x: x[1])
    for item in new:
        myDict = {}
        myDict['email'] = item[0]
        myDict['name'] = k[item[0]]['name']
        myDict['points'] = item[1]
        retVal.append(myDict)
    return jsonify(retVal[::-1])

@app.route("/getUser/<email>")
def dasdadhjsdasss(email):
    k = {}
    with open('userdata', 'rb') as handle:
        k = pickle.load(handle)
        print(k)
    try:
        return jsonify(k[email])
    except:
        return jsonify({})

@app.route('/alreadyLogged')
def loginAgain():
    return render_template("fff.html", Name=session_tracker.getName())


@app.route("/login", methods=["POST"])
def login():
    data_dict = {}
    x = request.form['login_email']
    try:
        with open('charitydata', 'rb') as handle:
            data_dict = pickle.load(handle)
            session_tracker.updateSession(x, data_dict[x]['name'])
    except:
        return render_template("landing.html")

    try:
        data = data_dict[x]
        return render_template("fff.html", Name=data['name'])
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

@app.route('/getevents/<email>', methods=["GET"])
def getevenetstuff(email):
    retVal = []
    data_dict = {}
    with open('eventdata', 'rb') as handle:
        data_dict = pickle.load(handle)
    
    for i in data_dict.keys():
        if email in data_dict[i]['UserList']:
            retDict = {}
            retDict["Charity"] = data_dict[i]['Charity']
            retDict["DateTime"] = data_dict[i]['DateTime']
            retDict["Description"] = data_dict[i]['Description']
            retDict["EventName"] = data_dict[i]['EventName']
            retDict["Location"] = data_dict[i]['Location']
            retDict["pictureUrl"] = data_dict[i]['pictureUrl']
            retVal.append(retDict)

    retVal = retVal[::-1]
    return jsonify(retVal)

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
    data_dict[x2] = {'name':x1 ,'phone':x3, 'points':0}
    with open('charitydata', 'wb') as handle:
        pickle.dump(data_dict, handle)
    response = Response(status=200)
    return redirect("/")

if __name__ == '__main__':
    app.debug = True
    b = {}
    if (not os.path.isfile(os.getcwd() + "/userdata")):
        with open('userdata', 'wb') as handle:
            pickle.dump(b, handle)
        
    if (not os.path.isfile(os.getcwd() + "/charitydata")):
        with open('charitydata', 'wb') as handle:
            pickle.dump(b, handle)
        
    if (not os.path.isfile(os.getcwd() + "/eventdata")):
        with open('eventdata', 'wb') as handle:
            pickle.dump(b, handle)
        
    
    session_tracker = SessionTracker()
    app.run(host = '0.0.0.0',port=5000)
