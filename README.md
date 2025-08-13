# Python on Docker

## Why?

* Deploy custom flavor of Python and its libraries across machines/environments. This is different than doing VENV because the advantage is that by tweaking the requirements.txt and rebuilding the docker image, you can have a different Python that is clean and running without adding more junk on the existing. You also won't have to keep track of all the PIPs you installed should you ever need to repeat the same process elsewhere because it's self documenting on what it will install, nothing more nothing less.
* The cool factor for this is it will run like your native Python command. Say your Macbook is vanilla which probably has Apple's Python 3.9 installed, that doesn't matter because let say if you use Python 3.11.13 on the docker here, when you execute any python commands in a terminal, that will automatically be using Python 3.11.13 and not the old, achieving our goal to run a very clean python without adding or leaving any trace of it being there except for the docker image's existance.
* Works with VS Code meaning you can directly edit and test codes inside VS Code using this Python, even with other projects or folders.
  
## Quick Start

* Install [HomeBrew](https://brew.sh)
* Install OrbStack. This is a faster & better version of Docker on MacOS
```
% brew install orbstack
```
* Install [GitHub Desktop for Mac](https://github.com/apps/desktop)
* File | Clone Repository | URL: ```https://github.com/danielpoon/postgres-docker.git```
* In a terminal:
```
% cd ~/Documents/GitHub/python-docker
% cp env-example .env
```
* Edit the .env file ```% nano .env```
* Build and start the container
```
% sh ./build.sh
```
That's it. You should be able to test it with
```
% python requirements-test.py
```

## The Details

- We're using Python 3.11.13

## Python Requirements

- Edit the requirements.txt for your needs and then do a ./build.sh to get it done
  
- psycopg2: pip install psycopg2
- dotenv: pip install python-dotenv
