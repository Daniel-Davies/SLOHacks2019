# PhilanthroPoints
Incentivising members of the community to volunteer for local charities.

## The Team
<html>
    <img src="https://raw.githubusercontent.com/Daniel-Davies/SLOHacks2019/master/photos/team_photo.jpg" alt="Team Photo" width="550">
</html>  

|[Chase Carnaroli](https://www.linkedin.com/in/ChaseCarnaroli/)|[Syrsha Harvey](https://www.linkedin.com/in/syrshaharvey/)| [Mugen Blue](https://www.linkedin.com/in/mugenblue/) | [Daniel Davies](https://www.linkedin.com/in/daniel-davies-943668160/)
|--|--|--|--| 

## Awards 🏆
"Best Social Good Hack" presented by [GoDaddy](https://www.godaddy.com/)  
"Best Hack from Hathway Challenge" presented by [Hathway](https://wearehathway.com/)

## The Project

PhilianthroPoints allows volunteers to find out about charity events in the local area, and upon participating an event, earn points through the app which they can then redeem for giftcards to partnering companies. The experience of volunteering time to a local charity is gamified by keeping a leaderboard (partitioned by location) of who has donated the most of their time to charities for a given time frame.  

Charities post their events on our platform.  
<img src='https://raw.githubusercontent.com/Daniel-Davies/SLOHacks2019/master/gifs/gif1.gif' title='PhilanthroPoints App Walkthrough' width='' alt='PhilanthroPoints App Walkthrough' />
Users can look at volunteer events in their area, sign up for events, see what events they are participating in, redeem points, and check their local leaderboard.  
<img src='https://raw.githubusercontent.com/Daniel-Davies/SLOHacks2019/master/gifs/iOS.gif' title='PhilanthroPoints App Walkthrough' width='' alt='PhilanthroPoints App Walkthrough' />

After an event, charities can review statistics on how it went.  
<img src='https://raw.githubusercontent.com/Daniel-Davies/SLOHacks2019/master/gifs/gif2.gif' title='PhilanthroPoints App Walkthrough' width='' alt='PhilanthroPoints App Walkthrough' />

## The Inspiration
Small, local charities form a key part of philanthrophic projects across the globe. Without them, millions of people around the world would be suffering with no one to help them. Volunteering your time at a local charity can be a fulfilling experience that can create a great positive impact in your local community.

In practice however, local charities can find it very difficult to sustain themselves due to the lack of people that many such charities have come through. Since getting volunteers can be hard for these charities, we thought we'd help them out by creating further incentive for people in the community to help with our app, PhilianthroPoints.

This means volunteers now have the feel good factor of helping a good cause, but also upon finding a charity they can connect to on our app, can also challenge themselves against their peers and earn small treats for doing so.

## Implementation

The idea of the project is to have two main platforms for our two main user types: charities that host/ run events, and the volunteers who sign up to these events and redeem the rewards for doing so. 

The website is designed for the charities, so that an organisation can access our resources from, let's say, a work computer, meanwhile the app is designed to be much less formal and can be accessed by anyone on their iOS mobile device.

#### Web Server

The web server has two main goals:

* Enable charities to host events and track their previous events by serving HTML pages
* Act as a centralising data storage and resource unit for the iOS app, which is accessed through supporting API calls

The server itself is written in python flask. More details can be found [here](http://flask.pocoo.org/). API calls for the app are provided as endpoints, as are webpage requests.

The email SMTP client uses the Flask-Mail plugin, which sends messages through an SMTP server. The SMTP server we have used is a google mail account linked to Flask-Mail, and is triggered to send a given message from the "/sendMail" endpoint in our server.

###### Web Frontend

The frontend pages are written in HTML code aided with features of the Flask framework for modular code where possible.

Page styling is done through the Twitter Bootstrap framework, along with custom CSS for more complicated page designs.

###### Data storage/ API calls

Data is managed and stored through calls to endpoints, which abstracts away data storage details for the user. We specifically use python pickle to store the data created by the users/ handed to the iOS app. More can be read about pickle [here](https://docs.python.org/3/library/pickle.html), but essentially, it is a way to efficiently store python data structures.

API calls then retrieve this data and process as necessary when called on by the iOS app. Examples include getUser/[email], which retrieves a user profile, or getEvents/, which retrieved all events etc.

#### iOS Interface

The iOS app consists of a 5 seperate views. "Events", "Leaderboard", "Profile", "EventsDescription", and "Prizes"
<img src='https://raw.githubusercontent.com/Daniel-Davies/SLOHacks2019/master/photos/ios_storyboard.png' title='PhilanthroPoints Storyboard' width='' alt='PhilanthroPoints Storyboard in Xcode' />

Events are loaded in from the server and shown in a Collection View. The Leaderboard and Prizes are both shown in Table Views.
All of the views are embedded within a Navigation Controller to allow for smooth navigation and backtracking.

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

## Future of the project

After our success at the hackathon, we would be keen to fully finish the project to see our idea come to a final, finished project and further develop our knowledge of both iOS and web design.

#### Website further development

Apart from general user interface aspects that there was no time left for (such as validation of input, hints and help functionality for users, and navigation maps), the analytics pages for the "upcoming events" and "past events" would need to linked to the backend in order to process real data rather than being based on static data. 

It would also be beneficial to rewrite the server code in node.js or another more robust/ high performance server code framework, before deploying to the cloud and letting the application go live.

#### iOS future work

Most of our time during the hackathon was dedicated towards creating models, mapping out the flow of the app, learning about CollectionViews, and getting the API requests to work with the server. Since everything is, for the most part, already well built out behind the scenes, any future iOS work would focus on improving the UI and adding animations. 

We would also like to add the ability to donate to charities directly through our app, however that was a little bit outside of the scope of this hackathon.
