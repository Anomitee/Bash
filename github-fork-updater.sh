#!/bin/bash
# GitHub forked repository updater Bash script
# By Anomitee

# This script fetches 
# It assumes that you have added the original repository as a remote named "upstream".
# For more information on forks, visit https://help.github.com/articles/fork-a-repo

# Put this script in the directory that contains your forked repository.
# It is recommended to run this in a terminal

# Go to the directory the script is in
cd $(dirname $0)

# Fetch changes made upstream
git fetch upstream

# Merge these changes.
# Uncomment this line to have the script merge the changes automatically
# git merge upstream/master

# Uncomment to have the script pause before finishing
# read -sn 1 -p 'Press any key to continue'
