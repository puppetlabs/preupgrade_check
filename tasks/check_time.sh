#!/bin/sh
# Task to check the time on Puppet Infrastructure.
# Additionally this task checks to see if server is PuppetCA.
caServer=$(puppet config print ca_server)
catest=$(puppet config print hostcert | grep $(puppet config print ca_server))
catime=''
mytime=$(date --utc --date '2017-08-17 04:00:01' +%s)
if [ -z $catest ];
then
  is_ca='false'
else
  is_ca='true'
  catime=$(date --utc --date '2017-08-17 04:00:01' +%s)
fi

# Output in json format
printf '{"CAserver":"%s","mytime":"%s","is_ca":"%s","catime":"%s"}\n' "${caServer}" "${mytime}" "${is_ca}" "${catime}"
