# preupgrade_check

Preupgrade_check provides a plan and tasks to automate some of the common data collection and calculations needed to determine if the upgrade is safe to proceed.

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with preupgrade_check](#setup)
    * [Setup requirements](#setup-requirements)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

This module provides the plan preupgrade_check that performs an initial automated assessment of some common items to consider prior to upgrading Puppet Enterprise.

## Setup

### Setup Requirements

This plan can be ran from Puppet Bolt against all your infrastructure nodes.
Please add mod `'itgrl/preupgrade_check'` to your Puppet file and perform `bolt puppetfile install`


## Usage

To run the preupgrade_check you would prepare a list of puppet infrastructure nodes, one entry per line, in a text file and run the command.
`bolt plan run preupgrade_check -n @<mynodelist>`

### Optional arguments
To run in debug mode, add debug=true to the command line.
`bolt plan run preupgrade_check debug=true -n @<mynodelist>`

## Limitations

To be determined...

## Development

Assistance in keeping this module up to date is welcome.
Please fork the repository and create a Pull Request with description of what you are changing.

