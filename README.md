[ ![Codeship Status for inoda/meetings](https://www.codeship.io/projects/ae492720-3981-0132-a05a-4664fd0eaf1d/status)](https://www.codeship.io/projects/42219)

# [Standup](http://meetingz.herokuapp.com/)
#### Version 1.0 _beta_
###Meetings suck.
**Standup** helps make them better. We believe collaborative preparation allows for more effective meetings. Share what you think should be discussed in advance and get clear feedback from other meeting members. Spend less time documenting and organizing information and more time solving problems.

#### What are the problems?
* Meetings are a hassle to organize, and sometimes the distinction between who should attend and who should not is unclear.
* Meeting agendas are often unplanned or unannounced, leaving meeting members left out or unprepared. 
* The person organizing and running the meeting is often not aware of all the issues that need to be addressed. 
* During the meeting, it is often difficult to establish what actions will actually be taken, and who is responsible for what.
* If someone is unable to make the meeting, it is often difficult for them to get a good grasp of what happened.
* After a few days, it is often hard to remember everything that was discussed and decided during the meeting.

#### How do we fix them?
* Upon creating a meeting, Standup makes a Google Calendar event for you and invites the people you listed as meeting members. This makes organizing a meeting easy, and stating who should attend obvious.
* Anybody invited to the meeting has access to a page where agenda topics can be suggested. These agenda topics are then voted on by other invitees. This opens the door for unprecedented issues to come to light. And, it is more likely for meeting members to be prepared when they can easily see what issues are on the table. This leads to a more productive meeting.
* During the meeting, actionables are documented and assigned to meeting members. Responsibilities are made explicit, and people can be held accountable. 
* After the meeting is closed, all invited members are e-mailed a summary of the meeting. Anybody who missed the meeting will be on the same page as everyone else just moments after the it ends.
* An archived record of the meeting will be accessible, serving as a reference should there be any confusion in the future.

### Contribute
To contribute to this project or even just give us feedback (we love feedback), submit a pull request or create a GitHub issue.

#### Get Up And Running
#####Requirements
* Ruby 2.x
* Rails 4.x
* Postgresql
* Redis
* Google API credentials 

##### Config
* Create an initializer file that sets ENV['CLIENT_ID'], ENV['CLIENT_SECRET'], and ENV['REDIRECT_URI'] to match your Google API credentials.
* To utilize WebSockets, deploy a Heroku app that just runs a [PrivatePub](https://github.com/ryanb/private_pub) Faye web server, then create an initializer file that holds your PrivatePub secret as ENV['FAYE_TOKEN']. Or, contact one of our team members and we might be able to help you link up to our PrivatePub server.

##### Get Going
* Run 'bundle install'
* Run 'bundle exec rake db:create' and 'bundle exec rake db:migrate'
* Start your Redis server on port 6379
* Run 'rails s'
* Go to 'http://localhost:3000/' in your browser


### The Standup Team
We are four super-rad [Dev Bootcamp Chicago](http://devbootcamp.com/) grads.

* Isaac Noda - [LinkedIn](https://www.linkedin.com/profile/view?id=344664589) | [GitHub](https://github.com/inoda)
* Joseph Timmer - [LinkedIn](https://www.linkedin.com/in/jtimmer89) | [GitHub](https://github.com/jtimmer89)
* Samuel Spread - [Google+](https://plus.google.com/117925567488555774987/) | [GitHub](https://github.com/sspread)
* Henry Perschk - [Henry Perschk](https://www.linkedin.com/profile/view?id=76929566) | [GitHub](https://github.com/henry-p)
