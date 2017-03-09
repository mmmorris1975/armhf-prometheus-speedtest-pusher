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

### Notes for running in Docker Swarm
Define the speedtest-pusher as a service in the swarm stack with the number of replicas set to 0 or 1, and the restart_policy set to none.
This will allow to service to be defined, but once the test is complete, the swarm container manager will not attempt to restart the container,
avoiding an endless loop of speedtest runs.

The systemd unit file to run the container is called systemd-speedtest-pusher-swarm.service, and along with the systemd-speedtest-pusher.timer,
are the files to install to scale up the service periodically to perform the test.

The environment variables are a bit different, since the options used for running an ephemeral container are specified in the swarm service definition.
When running under a Docker swarm, use these env vars instead:

  * `SWARM_STACK` the name of the docker swarm stack
  * `SWARM_SERVICE` The name of the speedtest-pusher service in the swarm stack configuration.
