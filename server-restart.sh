#! /bin/bash

uwsgi_id=$(ps -e | grep uwsgi | awk '{print $1}')
if [ -z "$uwsgi_id" ]; then
    uwsgi --socket project.sock --module sysad_intern.wsgi
else
    kill $uwsgi_id
    uwsgi --socket project.sock --module sysad_intern.wsgi
fi
