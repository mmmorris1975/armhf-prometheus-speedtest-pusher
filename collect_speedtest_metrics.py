#!/usr/bin/env python2.7

import os, json, subprocess, time
from prometheus_client import CollectorRegistry, push_to_gateway
from prometheus_client.core import GaugeMetricFamily

def run_speedtest(server_id):
  speedtest_cmd = ['speedtest-cli', '--json']

  if server_id:
    speedtest_cmd.append('--server')
    speedtest_cmd.append(server_id)

  output = subprocess.check_output(speedtest_cmd)
  return json.loads(output)

def send_to_prom(results, push_gw='localhost:9091'):
  ping_sec = results['ping'] / 1000.0

  class SpeedtestCollector(object):
    def collect(self):
      yield GaugeMetricFamily('speedtest_latency_seconds', 'Ping latency to speedtest.net server, in seconds', value=ping_sec)

      g = GaugeMetricFamily('speedtest_transfer_bits_per_second', 'Transfer speed in bits per second, label determines transfer direction', labels=['direction'])
      g.add_metric(['upload'], results['upload'])
      g.add_metric(['download'], results['download'])
      yield g

      yield GaugeMetricFamily('speedtest_execution_seconds', 'Time to execute speedtest, in seconds', value=results['exec_sec'])

  registry = CollectorRegistry()
  registry.register(SpeedtestCollector())

  push_to_gateway(push_gw, job='speedtest', registry=registry)

if __name__ == '__main__':
  t0 = time.time()
  res = run_speedtest(os.getenv('SPEEDTEST_SERVER'))
  res['exec_sec'] = time.time() - t0

  send_to_prom(res, os.getenv('PUSH_GW'))
