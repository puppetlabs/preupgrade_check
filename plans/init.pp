plan preupgrade_check(
  TargetSpec $servers,
  Boolean    $fail_plan_on_errors = true,
) {
  apply_prep([$servers])
  
  if $servers.empty { return ResultSet.new([]) }

  $os_results = run_task(preupgrade_check::check_os, '_catch_errors' => true ) 
  
  $failed_results = $os_results.filter |$os_result| {
    if !$os_result.ok() {
      true
    }
  }

  $failed_targets = ResultSet($failed_results).targets()

  $agent_failures = $os_results.filter | $result | {
    if !$result['puppet-agent'] != 'running' {
      true
    }
  }

  $pxp_failures = $os_results.filter | $result | {
    if !$result['pxp-agent'] != 'running' {
      true
    }
  }

  $codedir_failures = $os_results.filter | $result | {
    if $result['CodeDirectoryUsage'].value > '50' {
      true
    }
  }

  $puppetdir_failures = $os_results.filter | $result | {
    if $result['PuppetDirectoryUsage'].value > '50' {
      true
    }
  }


  $time_results = run_task(preupgrade_check::check_time, '_catch_errors' => true )
  
  


  
}
