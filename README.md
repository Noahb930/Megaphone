# <img src="app/assets/images/megaphone.png" width="400"></img>
An open-source platform designed to provide New York based activist organizations with digital infrastructure.
## Features
### Representatives and Report Cards
Megaphone allows activist groups to provide a rating and summary for all NY State Senators, NY State Assembly Members, Members of the US House of Representatives, and US Senators.
### Issues and Beliefs
Organizations can define an unlimited number of custom issues and track the beliefs of all representatives with respect to each of them.
### Bills and Voting Records
Organizations can also input bills into their database along with a description and statement of endorsement or opposition. Megaphone then updates the voting records of representatives using the roll call vote for the bill.
### Lobbyists and Campaign Contributions
Megaphone can additionally track the total amount of campaign contributions recieved from specified lobbyists, PACs and Super PACs.
### Email Templates
Lastly, at the press of a button, organizations can direct targeted email campaigns by creating templates that users can edit before being sent out.
## Installation and Setup
### Install Dependencies
Before you clone the Megaphone respository, install the following dependencies onto your empty Ubuntu server.
#### Install Ubuntu Packages
 ```bash
sudo apt-get update
sudo apt install -y git curl autoconf bison build-essential \
    libssl-dev libyaml-dev libreadline6-dev zlib1g-dev \
    libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev
```
#### Install Node.js
```bash
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt install -y nodejs
```
#### Install Yarn
```bash
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install -y  yarn
```
#### Install RVM
```bash
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
```
#### Install Ruby 3.0.1 and Rails 6
```bash
rvm install 3.0.1
rvm use 3.0.1 --default
gem install rails
```
#### Install PostgreSQL
```bash
sudo apt install postgresql postgresql-contrib libpq-dev
sudo -u postgres createuser -s YOUR_UBUNTU_USERNAME -P
```
### Clone Megaphone and Create Database
```bash
git clone https://github.com/Noahb930/megaphone.git
cd megaphone
bundle install
rake db:create
rake db:migrate
```
### Signup for API Keys
Request API keys from the following APIs and input them into `/.env` according to the nomenclature below:
* [Bing Maps API](https://www.microsoft.com/en-us/maps/create-a-bing-maps-key)
* [ProPublica Congress API](https://www.propublica.org/datastore/api/propublica-congress-api)
* [Open States API](https://openstates.org/accounts/login/?next=/accounts/profile/)
* [OpenFEC API](https://api.open.fec.gov/developers) 
* [MapBox API](https://docs.mapbox.com/api/overview/) 

```bash
export BING_API_KEY = "API_KEY"
export PROPUBLICA_API_KEY = "API_KEY"
export OPEN_STATES_API_KEY = "API_KEY"
export OPEN_FEC_API_KEY  = "API_KEY"
export MAPBOX_ACCESS_TOKEN  = "ACCESS_TOKEN"
```
### Update Styling
* Put the HTML for your organizations Navbar in `/app/views/layouts/_header.html.erb`
* Put the CSS for the Navbar in `/app/assets/stylesheets/header.css`
* Update global styling in `/app/assets/stylesheets/application.css`
* Update form styling in `/app/assets/stylesheets/forms.css`
* Update card styling in `/app/assets/stylesheets/cards.css`
* Upload your organization's logo as `/app/assets/images/logo.png`

> While all other aspects of Megaphone can be customized, I would appreicate if you do not edit the footer so that other organizations can be instructed on how to implement Megaphone as well.

### Start the Rails Server
To access the webpage at https://YOUR_SERVER_IP_ADDRESS:3000, run the following command
```bash
rails s -b=YOUR_SERVER_IP_ADDRESS
```