#!/bin/sh

# (c) 2015 Daniel Schosser
# schosser-it.de
#
#
# This script will deploy an application from github to a specified folder
# on your server

# Github repository to deploy from
# e.g. https://github.com/username/repository (public repository)
# e.g. https://username:password@github.com/username/repository (private repository)
githubRepository=""

# Server folder to deploy to
# e.g. /var/www/projectname
serverDeployFolder=""

# File within the repository which contains the credentials
# e.g. "/configs/application.ini"
serverFileCredentials=""

# Find strings for password, username, database
findUsernameString="InsertUsernameHere"
findPasswordString="InsertPasswordHere"
findDatabaseString="InsertDatabaseHere"

# Replace string for password, username, database
replaceUsernameString="username"
replacePasswordString="MySuperSecretPassword"
replaceDatabaseString="testDatabase"

# Check if github repository is specified
if [ "$githubRepository" == "" ]
    then
        # Ask user for github repository
        echo "Please specify the github repository, where the application should be cloned from."
        read -p "(e.g. https://github.com/username/repository.git):" githubRepository
        # Exit if still no github repository specified
        if [ "$githubRepository" == "" ]
            then
                echo "Exit: Github repository must be specified"
                exit
        fi
fi

# Check if server folder is specified
if [ "$serverDeployFolder" == "" ]
    then
        # Ask user for server folder
        echo "Please specify the server folder, where the application should be deployed to."
        read -p "(e.g. /var/www/projectname):" serverDeployFolder
        # Exit if still no server folder specified
        if [ "$serverDeployFolder" == "" ]
            then
                echo "Exit: Server folder must be specified"
                exit
        fi
fi

# Check if server file for credentials is specified
if [ "serverFileCredentials" == "" ]
    then
        # Ask user for server folder
        echo "Please specify the file which contains the server credentials."
        read -p "(e.g. /configs/application.ini):" serverFileCredentials
        # Exit if still no credential file specified
        if [ "serverFileCredentials" == "" ]
            then
                echo "Exit: Credential file must be specified"
                exit
        fi
fi

# Check if server folder exists
if [ ! -d "$serverDeployFolder" ]
    then
        mkdir -p "$serverDeployFolder"
fi

# Change to server folder
cd "$serverDeployFolder"

if [ "$(ls -A $serverDeployFolder)" ]
    then
        # Folder already contains files, try git pull
        echo "Folder already contains files, try pulling new commits"
        git pull
    else
        # Clone repository into the folder
        git clone "$githubRepository" "$serverDeployFolder"
fi

# Search and replace password
sed -i -e "s/$findUsernameString/$replaceUsernameString/g" "$serverDeployFolder$serverFileCredentials"
sed -i -e "s/$findPasswordString/$replacePasswordString/g" "$serverDeployFolder$serverFileCredentials"
sed -i -e "s/$findDatabaseString/$replaceDatabaseString/g" "$serverDeployFolder$serverFileCredentials"

echo "Credentials replaced. Have a nice day!"