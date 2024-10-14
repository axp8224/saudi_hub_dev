# README 

## Introduction 

The Saudi Community Hub is a web platform for the SSA at Texas A&M to bring the community together and share helpful resources. It was developed for CSCE 431 credit by a team of 5 developers in the Fall of 2024. 

## Requirements 

This code has been run and tested on: 

- Ruby - 3.1.2p20 

- Rails - 6.1.4.1 

- Ruby Gems - Listed in `Gemfile` 

- PostgreSQL - 13.7 

- Nodejs - v16.15.0 

- Yarn - 1.22.18 

- Docker (Latest Container) 

## External Deps 

- Docker - Download latest version at https://www.docker.com/products/docker-desktop 

- Heroku CLI - Download latest version at https://devcenter.heroku.com/articles/heroku-cli 

- Git - Downloat latest version at https://git-scm.com/book/en/v2/Getting-Started-Installing-Git 

- GitHub Desktop (Not needed, but HELPFUL) at https://desktop.github.com/ 

## Installation 

Download this code repository by using git: 

`git clone https://github.com/FA24-CSCE431-software-engineering/saudi_hub.git` 

 

 

## Tests 

An RSpec test suite is available and can be ran using: 

`rspec spec/` 

## Execute Code 

Run the following code in Powershell if using windows or the terminal using Linux/Mac 

`cd saudi_hub_dev` 

`docker run --rm -it --volume "$(pwd):/rails_app" -e DATABASE_USER=test_app -e DATABASE_PASSWORD=test_password -p 3000:3000 paulinewade/csce431:latest` 

Install the app 

`bundle install && rails db:create && db:migrate` 

Run the app 

`rails server --binding:0.0.0.0` 

The application can be seen using a browser and navigating to http://localhost:3000/ 

 

## Deployment 

Setup a Heroku account: https://signup.heroku.com/ 

From the heroku dashboard select `New` -> `Create New Pipline` 

Name the pipeline, and link the respective git repo to the pipline 

Our application does not need any extra options, so select `Enable Review Apps` right away 

Click `New app` under review apps, and link your test branch from your repo 

Under staging app, select `Create new app` and link your main branch from your repo 

For every app created you will have to attach a Postgres database as an addon 

 

-------- 

To add environment variables to enable google oauth2 functionality, head over to the settings tab on the pipeline dashboard 

 

Scroll down until `Reveal config vars` 

Add both your client id and your secret id, with fields `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` respectively 

Now once your pipeline has built the apps, select `Open app` to open the app 

With the staging app, if you would like to move the app to production, click the two up and down arrows and select `Move to production` 

And now your application is setup and in production mode! 

## CI/CD 

CI/CD has been implemented in the GitHub Actions in the repo here -> https://github.com/FA24-CSCE431-software-engineering/saudi_hub.git 

## Support 

For support, contact any member of the team. The product owner is Brigham Pettit, b.pettit@tamu.edu. We'll do our best to respond quickly to any concerns. 

## Extra Help 

Please contact Pauline Wade paulinewade@tamu.edu for help outside of the team. 