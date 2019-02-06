# PhilanthroPoints
Incestivising members of the community to volunteer for local charities.

### The Team
<html>
    <img src="https://raw.githubusercontent.com/Daniel-Davies/SLOHacks2019/master/photos/team_photo.jpg" alt="Team Photo" width="550">
</html>  

|[Chase Carnaroli](https://www.linkedin.com/in/ChaseCarnaroli/)|[Syrsha Harvey](https://www.linkedin.com/in/syrshaharvey/)| [Mugen Blue](https://www.linkedin.com/in/mugenblue/) | [Daniel Davies](https://www.linkedin.com/in/daniel-davies-943668160/)
|--|--|--|--| 

### The Project

\**Insert project description here*\*
## Implementation

The idea of the project is to have two main platforms for our two main user types: charities that host/ run events, and the volunteers who sign up to these events and redeem the rewards for doing so. 

The website is designed for the charities, so that an organisation can access our resources from say a work computer, meanwhile the app is designed to be much less formal and can be accessed by anyone on their iOS mobile device.

#### Web Server

The website has two main goals:

* Enable charities to host events and track their previous events by serving HTML pages
* Act as a centralising data storage and resource for the iOS app through supporting API calls

The server itself is written in python flask. More details can be found [here](http://flask.pocoo.org/). API calls for the app are provided as endpoints, as are webpage requests.

The email SMTP client uses the Flask-Mail plugin, which sends messages through an SMTP server. The SMTP server we have used is a google mail account linked to Flask-Mail, and is triggered to send a given message from the "/sendMail" endpoint in our server.

###### Web Frontend

The frontend pages are written in simple HTML code, exploiting features of the Flask framework for modular code where possible.

Page styling is aided by the Twitter Bootstrap framework, along with custom CSS for more complicated page designs.

###### Data storage/ API calls

Data is managed and stored through calls to endpoints, which abstracts away data storage details for the user. We specifically use python pickle to store the data created by the users/ handed to the iOS app. More can be read about pickle [here](https://docs.python.org/3/library/pickle.html), but essentially, it is a way to efficiently store python data structures.

API calls then retrieve this data and process as necessary when called on by the iOS app. Examples include getUser/[email], which retrieves a user profile, or getEvents/, which retrieved all events etc.

#### iOS Interface

## Trying the project yourself

#### Website pre-requisites

The website uses a python server to support the website code and support API calls to the iOS app. In order to run our python server, please complete the following steps:

1. Download the latest version of python from [the python site](https://www.python.org/downloads/)
2. After successful install, pip (the python package installer) will have also been installed and will be available from the terminal. Run the following commands in your terminal:
    * pip install flask
    * pip install flask-mail
    * pip install requests
    * pip install jsonify
3. Clone this repository 
4. Pre-requisites for the site should now be satisifed, so run the server by navigating to PhilanthroPoints/server and entering "python app.py" in your terminal
5. Now copy and paste "localhost:5000" into your browser
6. The website front login page should appear.
7. Do some exploring! Create an account, and login to see the remainder of the site.