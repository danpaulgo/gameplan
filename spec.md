# Specifications for the Sinatra Assessment

Specs:
- [x] Use Sinatra to build the app: Used Sinatra classes and methods to build controller methods

- [x] Use ActiveRecord for storing information in a database: Used ActiveRecord to build models and migrations for my application

- [x] Include more than one model class (list of model class names e.g. User, Post, Category): Category, Gameplan, Star, Step, User (Comment model created but not utilized in final product)

- [x] Include at least one has_many relationship (x has_many y e.g. User has_many Posts): Category has many Gameplans. User has_many gameplans. Gameplan has many steps. User has many stars. Gameplan has many stars. User has many starred_gameplans through stars. User has many comments. Gameplan has many comments.

- [x] Include user accounts: Users are able to sign up, login, log out, and delete accounts

- [x] Ensure that users can't modify content created by other users: Any routes that lead to pages where content may be edited require that the current user is the user associated with that content. If not, the user will be redirected.

- [x] Include user input validations: Gameplan, Step, and User models all use validations so that an instance may not be saved without including all necessary data

- [x] Display validation failures to user with error message (example form URL e.g. /posts/new): Any time a user attempts to save or update data using a form and they do not satisfy all validation requirements, they will be redirected to the form with a flash message on top explaining why the form could not submit successfully. The form will maintain all values already entered. 

- [x] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code: Completed README file with description, installation instructions, usage instructions, and credits

Confirm
- [x] You have a large number of small Git commits: 26 commits and counting. I should have more but at the beginning of my project I did not pay close attention to this step and on a few occasions worked for hours at a time without committing. I fixed this problem later on by utilizing an 8 minute interval timer that I found on Youtube. Each time the timer went off I would commit if necessary.

- [x] Your commit messages are meaningful: Each of my commits provide a brief explanation of the work I completed since my last commit

- [x] You made the changes in a commit that relate to the commit message: Each of my commits provide a brief explanation of the work I completed since my last commit

- [x] You don't include changes in a commit that aren't related to the commit message: My earlier commits may include some changes that are not specified in the commit message due to the fact that I did not commit often at first. I fixed this problem once I began using the interval timer. 
