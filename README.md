# preupgrade_check

Preupgrade_check provides a plan and tasks to automate some of the common data collection and calculations needed to determine if the upgrade is safe to proceed.

#### Table of contents

1. [Description](#description)
2. [Setup - The basics of getting started with preupgrade_check](#setup)
    * [Setup requirements](#setup-requirements)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

This module provides the plan `preupgrade_check`, which performs an initial automated assessment of Puppet Enterprise infrastructure nodes prior to upgrading them.

## Setup

### Prerequisites

- Puppet Bolt: https://puppet.com/docs/bolt/latest/bolt_installing.html
- A user account on the infrastructure nodes that can gain elevated (`sudo`) privileges without a password prompt
- A valid SSH key for the workstation used to run this plan, added to the infrastructure nodes' `authorized_keys`

### Installation

1. Add `mod 'puppetlabs/preupgrade_check'` to your workstation's Bolt Puppetfile.
2. Run `bolt puppetfile install`.

## Usage

1.  Prepare a list of Puppet Enterprise infrastructure nodes' full hostnames in a text file, adding one entry per line.
2.  Execute the plan as `root` on the targets:
    ```
    bolt plan run preupgrade_check --run-as root --targets @<NODE LIST FILE>
    ```

    Replace `<NODE LIST FILE>` with the path to the file you prepared in step 1.

If the check does not find any problems with the target nodes, it reports:

```
Plan completed successfully with no result
```

Otherwise, it reports either an error message or a JSON object with warnings about the node's state.

### Optional arguments

If the plan reports any problems, run it in debug mode and report the result by opening a ticket with Puppet Support before proceeding with the upgrade.

To run in debug mode, add the `debug=true` option:

```
bolt plan run preupgrade_check debug=true --run-as root --targets @<NODE LIST FILE>
```

This outputs details about the infrastructure nodes, which Support can use to help identify any issues and advise on next steps before proceeding.

## Limitations

The plan and tasks are intended to be run using Bolt from the command line.We do not test running them from the PE Console.

The plan uses Bolt's SSH transport, and relies on having a user on the target nodes that can gain elevated permissions without a password prompt. Bolt has additional options for authentication; for details, see [its documentation](https://puppet.com/docs/bolt/latest/bolt_command_reference.html).

Bolt assumes that the target nodes have been connected to via SSH before, and are in your workstation's `known_hosts` file. If not, the plan might report unexpected errors. Confirm that you can SSH into the affected nodes and gain elevated permissions, then re-run the plan.

The tasks copy and run scripts to the nodes as root. You can run these scripts to gather data manually by copying and running the `check_os.sh` and `check_time.sh` scripts from the `tasks` directory on the infrastructure nodes. Note that this only produces the debug mode JSON output; the logic to check the output for potential issues is in the plan, not the tasks.

## Development

We welcome assistance in keeping this module up to date.

Please fork the repository and create a Pull Request with description of what you are changing.

### Credits

This module was written by [Rebecca Robinson](https://github.com/itgrl/preupgrade_check) and is maintained by the Puppet technical support team.
