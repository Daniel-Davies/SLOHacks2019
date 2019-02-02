from flask import Flask, render_template, request, jsonify, redirect, Response
from flask_mail import Message
import requests
import os
import pickle

app =Flask(__name__)

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
    x = request.form['login_email']
    if ("charity" in x):
        return render_template("fff.html")
    else:
        return render_template("hwtd.html")

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

@app.route('/createcharity', methods=["POST"])
def createcharity():
    data_dict = {}
    content = request.json
    with open('charitydata', 'rb') as handle:
        data_dict = pickle.load(handle)
    data_dict[content['email']] = content['name']
    with open('charitydata', 'wb') as handle:
        pickle.dump(data_dict, handle)
    response = Response(status=200)
    return response

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
    
    app.run(host = '0.0.0.0',port=5000)
