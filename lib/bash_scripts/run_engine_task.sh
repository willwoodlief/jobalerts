#!/bin/bash


#check for environmental variables that should be set
x="check helper"
if [ -z ${webjob_path+x} ]; then printf "webjob_path is unset\n"; exit 1; else printf "webjob_path is set to '$webjob_path'\n"; fi
if [ -z ${eeid+x} ]; then printf "eeid is unset\n"; exit 1; else printf "eeid is set to '$eeid'\n"; fi
if [ -z ${rvm_base_directory+x} ]; then printf "rvm_base_directory is unset\n"; exit 1; else printf "rvm_base_directory is set to '$rvm_base_directory'\n"; fi
if [ -z ${rails_environment+x} ]; then printf "rails_environment is unset\n"; exit 1; else printf "rails_environment is set to '$rails_environment'\n"; fi
if [ -z ${engine+x} ]; then printf "engine is unset\n"; exit 1; else printf "engine is set to '$engine'\n"; fi


rversion=$( cat $webjob_path/.ruby-version )
gemset=$( cat $webjob_path/.ruby-gemset )
rvm_env_path="${rvm_base_directory}/environments/${rversion}@${gemset}"
echo "rvm source path is $rvm_env_path "
log_path="${webjob_path}/log/${engine}_task.log"
echo "log path is $log_path"
cd $webjob_path
# load rvm ruby

source $rvm_env_path

bundle exec rake ${engine} RAILS_ENV="${rails_environment}" EEID=$eeid # &>> $log_path
