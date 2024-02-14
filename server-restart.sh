#! /bin/bash

uwsgi_id=$(ps -e | grep uwsgi | awk '{print $1}')

if [ -z $uwsgi_id ]; then
	sudo systemctl start fossee.service
else
	sudo systemctl restart fossee.service
fi
