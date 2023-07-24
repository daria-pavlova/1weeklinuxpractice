# gcp-scripts

Deploy and common operations scripts for GCP. 

## Using gcp-scripts
Add this repo as a submodule in your project: https://git-scm.com/book/en/v2/Git-Tools-Submodules.

Carefully decide to update your submodule version depending on the setup of you environment. 

## Conventions
*gcp-scripts* are designed for fast typing with bash completion, confirmation prompts for critical operations and safer selection of target *project/cluster/zone/namespaces*.

Here are some of the conventions used (in the text below, 'X' refers to a digit character):
* *Deployment* scripts start with "00_"
* *Production operations* scripts such as logging into debug containers start with "1X_"
* *Network API token* scripts to fetch access tokens start with "6X_" 
* *Network deletion* scripts such as deleting load balancers start with "7X"
* *Network modification* scripts such as creating and updating load balancers start with "8X_" 
* *Build* scripts that call other build scripts start with "9X_"




