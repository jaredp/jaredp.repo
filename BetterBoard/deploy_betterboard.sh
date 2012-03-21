#!/bin/bash

#scp -r -P 2282 /Users/Jared/Dropbox/Development/BetterBoard/ jared@hchs01.welinknyc.com:BBDeploymentStaging
rsync -avz -r -e "ssh -p 2282" /Users/Jared/Dropbox/Development/BetterBoard/ jared@hchs01.welinknyc.com:~/BetterBoard
ssh jared@hchs01.welinknyc.com -p 2282 /home/jared/deploy_betterboard.sh
