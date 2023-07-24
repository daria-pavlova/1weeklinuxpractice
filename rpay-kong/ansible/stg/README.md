## To run the script for intial set up

1. Clone the repo on the local machine and checkout to feature/gcp branch
2. cd to the directory env directory ansible/{{env}}
```bash
cd rpay-kong
git checkout feature/gcp
```
3. Run install script to install kong, haproxy and filebeat

```bash
bash ansible/{{ env }}/10_install.sh
```
## To run blue/green deployment
If configs are identical script will exit on the stepShow diff. If you wanna test switcher - skip the step show diff.

4. Run the 00_deploy.sh script

```bash
cd rpay-kong
sudo bash ansible/{{ env }}/00_deploy.sh
```

## For advanced use cases

You can use the individual playbooks to run the tasks. 


```bash
ansible-playbook -i inventorystg ../playbooks/1_install_kong.yaml --check
```
> the above command is just a sample, it will not do any action.