# Server Setup:

## Setting up self-hosted GitHub runner:
- Repository settings > Actions > Runners > New self-hosted runner.
- Follow the instructions given there.
- Install and start the service for the same.([Reference](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/configuring-the-self-hosted-runner-application-as-a-service))
- Run the `actions/checkout` action once to setup your repository on the server.

## Setting up Python environment:
- Installing dependencies: ```sudo apt install -y python3 python3-pip python3-venv nginx```
- Create python virtual environment: ```python3 -m venv venv``` this is located in home directory of `fossee` user.
- Installing project dependencies: ```pip install -r requirements.txt```

## Setting up `fossee.service`:
- Created a `systemd` service named `fossee.service`.
- Located at `/etc/systemd/systemd/`
- ```ini
    [Unit]
    Description=uWSGI instance for sysad_intern
    After=network.target

    [Service]
    User=fossee
    Group=fossee
    WorkingDirectory=/home/fossee/actions-runner/_work/sysad_intern/sysad_intern
    Environment="PATH=/home/fossee/venv/bin"
    ExecStart=/home/fossee/venv/bin/uwsgi --socket project.sock --module sysad_intern.wsgi
    ExecReload=/bin/kill -s HUP $MAINPID
    ExecStop=/bin/kill -s TERM $MAINPID
    ExecStopPost=/bin/rm -f /home/fossee/actions-runner/_work/sysad_intern/sysad_intern/project.sock

    [Install]
    WantedBy=multi-user.target
    ```
- This manages the `uWSGI` instance for the django app.
- The `server-restart.sh` script checks for the instance and starts/restarts it accordingly.

Now whenever code is pushed to the repository GitHub actions does checkout in the directory and runs the `server-restart.sh` script.
