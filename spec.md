# Specifications for the Sinatra Assessment

Specs:
- [x] Use Sinatra to build the app
  - Sinatra handled all of my routing for
    - ApplicationController
    - UserController
    - AdventureController
  - I was able to redirect from the control action blocks as well as render .erb  view files 
- [x] Use ActiveRecord for storing information in a database
  - ActiveRecord allowed me to create a database, persist user information, as well as Create, Read, Update, and Delete instances of Users and Adventures. 
- [x] Include more than one model class (e.g. User, Post, Category)
  - I had User, Adventure, State, and Activity models to represent the domain model I was recreating
- [x] Include at least one has_many relationship on your User model (e.g. User has_many Posts)
  - My user had many adventures, as well as adventures, states, and activities having many of each, through a adventurestateactivity join table.
- [x] Include at least one belongs_to relationship on another model (e.g. Post belongs_to User)
  - The adventure belongs to a user
- [x] Include user accounts with unique login attribute (username or email)
  - The username must be unique, as well as a few other validations upon login or sign up
- [x] Ensure that the belongs_to resource has routes for Creating, Reading, Updating and Destroying
  - A user can create, read, and delete their user instance. They can also create, read, update, and delete the adventure instances.
- [x] Ensure that users can't modify content created by other users
  - The buttons to edit adventure content and delete profiles are not visible unless they are the #adventure_creator? or #profile_creator?. There are also other validations to check routes are manually entered into the URL
- [x] Include user input validations
  - A username, email, and passward is required upon signup, the password must be at least 7 characters long, and the email must include and @ symbol. The adventure must have a title, highlight, summary, and state to create an adventure instance.
- [x] BONUS - not required - Display validation failures to user with error message (example form URL e.g. /posts/new)
  - The user receives flash-messages at login, signup, and logout. There are a few other locations that trigger a flash-message, but I didn't want to go overboard on them.
- [x] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code
  - Everything has been included, I went through the instruction process to make sure that everything executed properly.
Confirm
- [x] You have a large number of small Git commits
  - I tried to commit everytime I started another task as well as inbetween if the task was larger
- [x] Your commit messages are meaningful
  - I tried to use concise language to alert what changes were made in the code
- [x] You made the changes in a commit that relate to the commit message
  - If I had to do two things at once, I tried to go back and sort the file changes out so that each commit was as specific as it could be within reason.
- [x] You don't include changes in a commit that aren't related to the commit message
  - As stated above, I tried to do my best to make sure each commit was specific to the code that was written or changed
