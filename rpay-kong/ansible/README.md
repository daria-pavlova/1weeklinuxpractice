Prerequisites to run scripts on the new BMaaS server:
1. Update apt list https://confluence.rakuten-it.com/confluence/pages/viewpage.action?pageId=3599634063#BMaaSRepoServer(GeneralUser)-apt
2. Provide user root permissions to run scripts
3. Update cache
```bash
$ apt-get update
```
4. Apt install ansible
```bash
$ sudo apt-get -y install ansible
```
5. Clone the repo on the local machine and checkout to feature/gcp branch  
```bash
$ git clone https://gitlab-payment.intra.rakuten-it.com/unbreakable/rpay-kong.git
$ git checkout feature/gcp
```