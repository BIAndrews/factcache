#### Table of Contents

1. [Overview](#overview)
2. [Setup - The basics of getting started with factcache](#setup)
    * [What factcache affects](#what-factcache-affects)
    * [Setup requirements](#setup-requirements)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)

## Overview

Factcache caches facter facts locally for 3rd party offline integration in both YAML and/or JSON format. Cron jobs are setup to keep local cache in sync.

## Setup

### What factcache affects

* Cron jobs are setup, 1 job per file type.
* `/var/cache/facts` is created to store cache files.
* `facts.yaml` - Default YAML file name.
* `facts.json` - Default JSON file name.
* YAML/JSON cron jobs can be disabled by leaving the file name `undef` or the string `""`.

### Setup Requirements

This module requires `puppetlabs-stdlib`.

## Usage

To cache facts in both YAML and JSON format:
```
class { 'factcache': }
```

To cache facts in YAML only:
```
class { 'factcache': 
  file_json => undef,
}
```

To cache facts in JSON only:
```
class { 'factcache': 
  file_json => undef,
}
```

## Reference

Here, list the classes, types, providers, facts, etc contained in your module. This section should include all of the under-the-hood workings of your module so people know what the module is touching on their system but don't need to mess with things. (We are working on automating this section!)
* `factcache::file_json` - JSON file name. Default _facts.json_. `Undef` or `""` to disable.
* `factcache::file_yaml` - YAML file name. Default _facts.yaml_. `Undef` or `""` to disable.
* `factcache::minute` - Array, minutes to run the cron job(s).
* `factcache::ensure_cron` - Default: present.
* `factcache::params::mode` - File mode, default 0664.
* `factcache::params::owner` - File owner, default _root_.
* `factcache::params::group` - File group , default _root_.

## Limitations

Unix family OS support only.
