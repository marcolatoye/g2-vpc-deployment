#!/bin/bash

export ${HOME}

sudo apt-get update -y

DD_API_KEY=${DD_KEY} DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)"

sudo apt install curl git

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.3

echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc

echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc

sudo apt install curl git gcc g++ make zlib1g-dev autoconf bison build-essential libnss3-dev libssl-dev libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev libpq-dev -y

ASDF_BIN=${asdf_bin}

$ASDF_BIN/asdf plugin add ruby

$ASDF_BIN/asdf plugin-update ruby

$ASDF_BIN/asdf install ruby 3.2.2

$ASDF_BIN/asdf global ruby 3.2.2


ASDF_RUBY_BIN=${asdf_ruby_bin}

$ASDF_RUBY_BIN/ruby -v

sudo apt-get install postgresql -y

$ASDF_RUBY_BIN/gem install rails

$ASDF_RUBY_BIN/gem install bundler

$ASDF_RUBY_BIN/gem update --system

curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -

sudo apt-get install -y nodejs

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -

echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update
 
sudo apt-get install yarn

# After mounting, check if the the rails app has been mounted previously
if [[ -d ${RAILS_APPNAME} ]]
then
    echo "Rail app ${RAILS_APPNAME} already exists"
    sleep 5
else
    echo "Rail app: ${RAILS_APPNAME} does not exist
          Proceed build a new app called ${RAILS_APPNAME}" 

    $ASDF_RUBY_BIN/rails new ${RAILS_APPNAME} --database=postgresql

    cd ${RAILS_APPNAME}
fi

sed -i "/pool: /a \\\
  username: <%= ENV['RDS_USERNAME'] %>\\n\
  password: <%= ENV['RDS_PASSWORD'] %>\\n\
  host: <%= ENV['RDS_HOSTNAME'] %>\\n\
  port: <%= ENV['RDS_PORT'] %>" config/database.yml

export RDS_USERNAME=${rds_username}

export RDS_PASSWORD=${rds_password}

export RDS_HOSTNAME=${rds_hostname}

export RDS_PORT=${rds_port}

$ASDF_RUBY_BIN/bundle install
$ASDF_RUBY_BIN/gem install rails
yarn install

$ASDF_RUBY_BIN/rails db:create

$ASDF_RUBY_BIN/rails db:migrate
#Mount on EFS
#sudo apt-get install nfs-common -y

#sudo chmod 744 ${HOME}/${RAILS_APPNAME}
#sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${efs_dnsname}:/ ${HOME}/${RAILS_APPNAME}

#echo ${efs_dnsname}:/ ${HOME}/${RAILS_APPNAME} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0 >> /etc/fstab
#mount -a -t nfs4
$ASDF_RUBY_BIN/rails s -p 3003 -b 0.0.0.0


