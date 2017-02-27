A python-based Docker image for the armhf (RPi) platform with the python speedtest-cli and prometheus_client modules installed from PyPi.

Should be called as an ephemeral (vs. long-running) container, and the speedtest results will be pushed to
a Prometheus Pushgateway.

Set the PUSH_GW environment variable specifying the HOST:PORT of the Pushgateway to send the metrics to.

Set the SPEEDTEST_SERVER environment variable specifying the speedtest server ID to use (by default
it will connect to the closest server, based on ping)

For a method to execute this container periodically using systemd (vs cron), see:
https://matthiasadler.info/blog/running-scheduled-tasks-in-docker-containers-with-systemd/

The install.sh script will do the steps necessary to setup a periodic execution of this job on a systemd-based system. 
The systemd service can be customized (in increasing order of preference) by setting variables in

  * /etc/default/speedtest-pusher
  * /etc/sysconfig/speedtest-pusher
  * /etc/systemd/system/speedtest-pusher-container.service.d/*.conf

Accepted env vars to set are:

  * `IMAGE_VER` to specify the version of the docker image to run, defaults to 'latest'
  * `DOCKER_OPTS` to provide command-line options for the `docker` command which is run by the systemd service unit.
    * This way you are able to pass in the container env vars and other docker params (like --network) as your needs dictate.
      The most common override will be something like `DOCKER_OPTS="-e PUSH_GW=pushgateway.local:9091"` to specify the endpoint to send the metrics.
