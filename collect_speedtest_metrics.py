#!/usr/bin/env python2.7

import os, json
from prometheus_client import CollectorRegistry, Gauge, push_to_gateway

speedtest_cli_opts = ['--json']

speedtest_server_id = os.getenv('SPEEDTEST_SERVER')
if speedtest_server_id:
  speedtest_cli_opts.append('--server ' + speedtest_server_id)
  
registry = CollectorRegistry()

#g = Gauge('job_last_success_unixtime', 'Last time a batch job successfully finished', registry=registry)
#g.set_to_current_time()

push_to_gateway(os.getenv('PUSH_GW'), job='speedtest', registry=registry)
