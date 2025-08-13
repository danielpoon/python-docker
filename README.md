# Python on Docker

## Why?

* Replace Mac's Python but without installing any Python locally
* The Docker image sits and replace the default python and you can have all the PIPs you need by just modifying requirements.txt
* The python command runs the same way, across all your directories in a terminal, just like the native 'python' command on your scripts
* Skip the need to learn the tedious process of installing Python and its libraries
* Built for Mac
* Compatible with VS Code
  
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
```
% cd ~/Documents/GitHub/python-docker
% cp zshrc-example ~/.zshrc
```
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
