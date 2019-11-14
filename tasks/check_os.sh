#!/bin/sh
OS=$(facter osfamily)
puppetdir_usage=$(df $(puppet config print libdir) | awk '{print $5}' | grep -v Use% | cut -d '%' -f 1)
codedir_usage=$(df $(puppet config print codedir) | awk '{print $5}' | grep -v Use% | cut -d '%' -f 1)
version=$(cat /opt/puppetlabs/server/pe_version)
agent_status=$(puppet resource service puppet | grep ensure | cut -d "'" -f2)
pxp_status=$(puppet resource service pxp-agent | grep ensure | cut -d "'" -f2)
licensed_nodes=$(grep nodes $(puppet config print confdir)/../license.key | cut -d ':' -f 2)
license_end=$(grep end $(puppet config print confdir)/../license.key | cut -d ':' -f 2)
printf '{"PuppetDirectoryUsage":"%s","CodeDirectoryUsage":"%s","puppet-agent":"%s","pxp-agent":"%s","LicensedNodes":"%s","LicenseEndDate":"%s"}\n' "$puppetdir_usage" "$codedir_usage" "$agent_status" "$pxp_status" "$licensed_nodes" "$license_end"

