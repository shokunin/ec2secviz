ec2secviz
=========

Get a better idea of your security settings in ec2

Installation
------------

- *Optional* Install RVM https://rvm.io/rvm/install/
- Clone the repo - git clone git@github.com:shokunin/ec2secviz.git
- Run bundle install
- Copy  ec2_credentials.yml.example to ec2_credentials.yml and edit
- Run rackup on the commandline
- run curl http://localhost:9292/download/cache_nodes  to Download all node information
- run curl http://localhost:9292/download/cache_groups to Download all security group information


