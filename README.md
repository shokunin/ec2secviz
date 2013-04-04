ec2secviz
=========

Get a better idea of your security settings in ec2

Installation
------------

1) *Optional* Install RVM https://rvm.io/rvm/install/
2) Clone the repo - git clone git@github.com:shokunin/ec2secviz.git
3) Run bundle install
4) Copy  ec2_credentials.yml.example to ec2_credentials.yml and edit
5) Run rackup on the commandline
6) run curl http://localhost:9292/download/cache_nodes  to Download all node information
7) run curl http://localhost:9292/download/cache_groups to Download all security group information


