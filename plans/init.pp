plan preupgrade_check(
  TargetSpec $nodes,
  Boolean    $fail_plan_on_errors = true,
  Integer    $time_skew = 60,
) {
  if $nodes.empty { return ResultSet.new([]) }

  #apply_prep([$nodes])

  $os_results = run_task(preupgrade_check::check_os, $nodes, '_catch_errors' => true ) 
  
  $failed_results = $os_results.error_set()

  $failed_targets = ResultSet($failed_results).targets()

  $agent_failures = $os_results.filter | $result | {
    if !$result['puppet-agent'] != 'running' {
      true
    }
  }

  $agent_fail_targets = ResultSet($agent_failures).targets()

  $proc_err = {
    msg  => 'Target has an error with a service',
    kind => 'bolt/check_os',
  }

  if !$agent_fail_targets.empty {
    $agent_set = $agent_fail_targets.map | $target | {
      Result.new($target, {
        _output => 'does not have a running puppet agent.',
        _error  => $proc_err,
      })
    }
  }

  $pxp_failures = $os_results.filter | $result | {
    if !$result['pxp-agent'] != 'running' {
      true
    }
  }

  $pxp_fail_targets = ResultSet($pxp_failures).targets()
  if !$pxp_fail_targets.empty {
    $pxp_set = $pxp_fail_targets.map | $target | {
      Result.new($target, {
        _output => 'does not have a running pxp-agent.',
        _error  => $proc_err,
      })
    }
  }

  $fs_err = {
     msg  => 'Target has an error with a service',
     kind => 'bolt/check_os',
  }

  $codedir_failures = $os_results.filter | $result | {
    if $result['CodeDirectoryUsage'] > '50' {
      true
    }
  }

  $codedir_fail_targets = ResultSet($codedir_failures).targets()
  if !$codedir_fail_targets.empty {
    $codedir_set = $codedir_failures.map | $target | {
      Result.new($target, {
        _output => 'has a code directory filesystem greater than 50% utilized.',
        _error  => $fs_err,
      })
    }
  }

  $puppetdir_failures = $os_results.filter | $result | {
    if $result['PuppetDirectoryUsage'] > '50' {
      true
    }
  }

  $puppetdir_fail_targets = ResultSet($puppetdir_failures).targets()
  if !$puppetdir_fail_targets.empty {
    $puppetdir_set = $puppetdir_failures.map | $target | {
      Result.new($target, {
        _output => 'has a puppet directory filesystem greater than 50% utilized.',
        _error  => $fs_err,
      })
    }
  }

  $time_results = run_task(preupgrade_check::check_time, $nodes, '_catch_errors' => true )
  $ca_time = $time_results.filter_set |$result| { $result['is_ca'] }.first['catime'] 
  $catime = Integer("${ca_time}")

  $time_failures = $time_results.filter | $result | {
    $mytime = Integer("${result['mytime']}")
    $delta = ( $catime - $mytime )
    if (-60 >= $delta) and ($delta >= 60) {
      true
    }
  }
  
  $time_err = {
    msg  => 'Target has an error with time syncronization',
    kind => 'bolt/check_time',
  }

  $time_fail_targets = Resultset($time_failures).targets()
  if !$time_fail_targets.empty {
    $time_set = $time_failures.map | $target | {
      Result.new($target, {
        _output => 'has a date/time with too great of a delta of that of the PuppetCA.',
        _error  => $time_err,
      })
    }
  }

  $os_ok = Resultset($os_results)
  #  if !$os_ok.empty {
  #  $ok_os_set = $os_ok.map |$target| {
  #    Result.new($target, {
  #      _output => "
  #        pe_build           = ${target['pe_build']} \n
  #        pe_server_version  = ${target['pe_server_version']} \n
  #        Licensed Nodes     = ${target['LicensedNodes']} \n
  #        License End Date   = ${target['LicenseEndDate']} \n
  #        CA Cert Expiration = ${target['CAcertExpiration']} \n
  #      ",
  #    })
  #  }
  #}

  $result_set = ResultSet.new($os_ok)
  #$result_set = ResultSet.new($os_ok + $agent_set + $pxp_set + $codedir_set + $puppetdir_set + $time_set)
  if ($fail_plan_on_errors and !$result_set.ok) {
    fail_plan('One or more targets have failed the checks.', {
        action         => 'plan/preupgrade_check',
        result_set     => $result_set,
        failed_targets => $result_set.error_set.targets,
    })
  }
  else {
    return($result_set)
  }
}
