# CSCE606 - Project PlaNXT

Team Fall 2024  


Fall 2024 Heroku link: https://planxt.herokuapp.com  

Fall 2024 PlaNXT code climate report: https://codeclimate.com/github/CSCE-606-Event360/Fall2024-PlaNXT  

[Team Working Agreement](TWA.md)






## Get Started
```
## Clone the repository 
git clone https://github.com/CSCE-606-Event360/Fall2024-PlaNXT.git
cd Fall2024-PlaNXT
```
### Setup the environment 
Verify you have Ruby, Rails, and Heroku CLI installed

* Check your Ruby version. If no ruby, follow this [instruction](docs/install_ruby.md).
* Check your Rails version. If no rails, run `gem install rails`.
* Check your Bundler version. If bundle -v fails, run gem install bundler to install it. (Normally, though, installing the rails gem will also install bundler.)
* Verify [the heroku command line tool](https://devcenter.heroku.com/articles/heroku-cli) has been installed in the development environment. If not, follow the [instructions](https://devcenter.heroku.com/articles/heroku-cli#install-with-ubuntu-debian-apt-get) to install it.

In terminal:
```
ruby -v &&\
rails -v &&\
bundle -v &&\
heroku -v
```



## To run App in development environment
```
## install the gem and setup the database
bundle install
rails db:migrate

## start server
rails s
```

### Problems
1. If Bundler complains that the wrong Ruby version is installed,

    * rvm: verify that rvm is installed (for example, rvm --version) and run rvm list to see which Ruby versions are available and rvm use <version> to make a particular version active. If no versions satisfying the Gemfile dependency are installed, you can run rvm install <version> to install a new version, then rvm use <version> to use it.
    
    * rbenv: verify that rbenv is installed (for example, rbenv --version) and run rbenv versions to see which Ruby versions are available and rbenv local <version> to make a particular version active. If no versions satisfying the Gemfile dependency are installed, you can run rbenv install <version> to install a new version, then rbenv local <version> to use it.
    
    Then you can try bundle install again.

### Run Tests
#### Cucumber
In order to have the cucumber test be able to trigger javascript events, one have to make sure that selenium is installed. Here is the approach of doing it:
##### Step 1
We have to manually download the correct version of the chromedriver. Follow this link to download the chromedriver: https://googlechromelabs.github.io/chrome-for-testing/#stable

Under stable, choose the corresponding OS you have:
<img width="1256" alt="Screenshot 2023-11-20 at 8 43 37 AM" src="https://github.com/CSCE-606-Event360/Fall2023-PlaNXT/assets/32810188/5a32cd03-e603-41ac-bf80-e69331c44cbf">


##### Step 2
Setup the chromedriver
<b>Mac</b>
After downloading the chromedriver, unzip the folder and move the chromedriver executable file to the /usr/local/bin folder.
```
# assume you are in the unzip folder dir
mv chromedriver /usr/local/bin
```
After moving chromedriver in the **/usr/local/bin** dir, one can start running the cucumber test
* If you face “Error: “chromedriver” cannot be opened because the developer cannot be verified. Unable to launch the chrome browser“, you need to go to usr/local/bin folder and right-click chromeDriver file and open it. After this step, re-run your tests, chrome driver will work.
    
<b>Windows</b>
1. After the ChromeDriver executable file is extracted and moved to the desired location, copy that location to set its path in System’s environment variables (the path where the chromedriver.exe is put).

2. Add the path in the Environment Variables
    
    
##### Step 3
run cucumber test
```
rails cucumber
```
#### Rspec
```
rspec
```

## To deploy in production environment (Heroku)
In your heroku account, create a new app.

Deploy the github repo to heroku itself. 
under the deploy tab click github and connect
go to manual deploy and choose the main branch to deploy 
press deploy branch
press view
skip next section to the final section of the readme


Just keeping the steps below just in case but it does not work for Alex 

In your project terminal:
```
heroku login
    
git init
heroku git:remote -a <project_name>

# deploy
git add .
git commit -m "my first commit"
git push heroku main
heroku run rails db:migrate
```
When goes to the deployment website and click the "Continue with Event360" button, it will shows an error page. This is because you have connected your deployed app to the CRM system.
    
To do this, go to https://events360.herokuapp.com/users and login as the admin user.
1. Go to Application Management Tab -> New Application

2. Fill in the information like this: 
<img width="980" alt="Screenshot 2023-11-20 at 10 16 57 AM" src="https://github.com/CSCE-606-Event360/Fall2023-PlaNXT/assets/32810188/eca69a45-65db-493a-8077-6c14f5464aa9">

3. After creating the application, you will get an **UID** and **Secret** Token

4. Add thoses variable to the deployed app's Config Vars on Heroku:
<img width="809" alt="Screenshot 2023-11-20 at 9 23 22 AM" src="https://github.com/CSCE-606-Event360/Fall2023-PlaNXT/assets/32810188/253341d8-1e05-4469-ac40-5dfe072071bf">

5. Add postgres under resources tab on Heroku

