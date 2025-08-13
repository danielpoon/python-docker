#!/bin/bash

echo ""
echo "Python 3 Container"
echo "=================="
echo "TL;TR This script is everything you need to run python3 as a"
echo "container on your Mac (mine is M2)."
echo ""
echo "You do not need to do this again. You can simply:"
echo ""
echo "  Start container: docker-compose up -d"
echo "  End container:   docker-compose down"
echo ""

# Exit on any error
set -e

# Step 1: Drop the existing python-app container and image if they exist
echo "Removing existing python-app container if it exists..."
if [ $(docker ps -a -q -f name=python-app) ]; then
    docker rm -f python-app
    echo "Container python-app removed."
else
    echo "No python-app container found."
fi

# Remove all images related to python-app and dangling images
echo "Removing existing python-app images and dangling images..."
# Get the image name from docker-compose (defaults to <project_dir>_python-app)
COMPOSE_PROJECT_NAME=$(docker-compose config | awk '/image:/ {print $2}')
if [ ! -z "$COMPOSE_PROJECT_NAME" ]; then
    docker rmi -f $COMPOSE_PROJECT_NAME 2>/dev/null || true
    echo "Image $COMPOSE_PROJECT_NAME removed."
else
    echo "No python-app image found in docker-compose config."
fi

# Remove dangling images
docker images -f "dangling=true" -q | sort -u | xargs -r docker rmi -f 2>/dev/null || true
echo "Dangling images removed."

# Step 2: Write the current username, UID, GID to .env file and this will be used
# later in Dockerfile, docker-compose.yml and entrypoint
echo "Creating .env file with current username..."
USERNAME=$(whoami)
USER_ID=$(id -u)
GROUP_ID=$(id -g)

echo "USERNAME=$USERNAME" > .env
echo "USER_ID=$USER_ID" >> .env
echo "GROUP_ID=$GROUP_ID" >> .env

echo ".env file created with USERNAME=$USERNAME (userID: $USER_ID) belonging to (groupID: $GROUP_ID)"

# Step 3: Run docker-compose to build and start the container
echo "Building and starting Docker container with docker-compose..."
docker-compose build
docker-compose up -d
echo "Docker container built and started."

# Step 4: Backup ~/.zshrc with a random number and overwrite with /home/$CURRENT_USER/src/zshrc-example
echo "Backing up ~/.zshrc..."
if [ -f ~/.zshrc ]; then
    RANDOM_NUM=$((RANDOM % 1000000))
    cp ~/.zshrc ~/.zshrc.bak.$RANDOM_NUM
    echo "Backed up ~/.zshrc to ~/.zshrc.bak.$RANDOM_NUM"
else
    echo "No ~/.zshrc file found, skipping backup."
fi

echo "Overwriting ~/.zshrc with ./zshrc-example..."
if [ -f "./zshrc-example" ]; then
    cp ./zshrc-example ~/.zshrc
    echo "./zshrc-example copied to ~/.zshrc"
else
    echo "Error: ./zshrc-example file not found."
    exit 1
fi

# Step 5: Source ~/.zshrc to apply changes
echo "Sourcing ~/.zshrc..."
source ~/.zshrc
echo "~/.zshrc sourced."

# Step 6: Verify the container is running and notify the user
echo "Verifying container status..."
if [ $(docker ps -q -f name=python-app) ]; then
    echo "Docker container 'python-app' is active."
    echo "Good to go!"
else
    echo "Error: Docker container 'python-app' failed to start."
    exit 1
fi

echo ""
echo "Check for any error  messages before this line and if"
echo "everything is good then you can try:"
echo ""
echo "     % python requirements-test.py"
echo ""

