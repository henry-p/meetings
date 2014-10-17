Meeting.delete_all
Invite.delete_all

user1 = User.find(1)
user2 = User.find(2)

meeting1 = Meeting.create!(creator: user1, title: "App naming conference", location: "Chicago", start_time: Time.parse("March 19, 2012, 9:00 AM"), :end_time => Time.parse("March 19, 2012, 10:00 AM"))
meeting2 = Meeting.create!(creator: user2, title: "App building conference", location: "Chicago", start_time: Time.parse("March 19, 2012, 4:00 AM"), :end_time => Time.parse("March 19, 2012, 6:00 AM"))

Invite.create!(invitee: user1, meeting: meeting1)
Invite.create!(invitee: user2, meeting: meeting1)
Invite.create!(invitee: user1, meeting: meeting2)
Invite.create!(invitee: user2, meeting: meeting2)
