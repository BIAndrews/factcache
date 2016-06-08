[![Build Status](https://travis-ci.org/BIAndrews/factcache.svg?branch=master)](https://travis-ci.org/BIAndrews/factcache)

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
* YAML or JSON cron jobs can be disabled if you only want type.

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
  json => false,
  yaml => true, # implied
}
```

To cache facts in JSON only:
```
class { 'factcache': 
  json => true, # implied
  yaml => false,
}
```

## Reference

List of classes, types, providers, facts, scripts, etc contained in this module.
* `factcache::json` - Boolean. To cache in JSON or not. Default: _true_.
* `factcache::yaml` - Boolean. To cache in YAML or not. Default: _true_.
* `factcache::file_json` - JSON file name. Default: _facts.json_.
* `factcache::file_yaml` - YAML file name. Default: _facts.yaml_.
* `factcache::minute` - Array, minutes to run the cron job(s). Default: _[00,59]_.
* `factcache::params::mode` - File mode, default: 0664.
* `factcache::params::owner` - File owner, default: _root_.
* `factcache::params::group` - File group , default: _root_.
* `qa.sh` - Shell script for lint, syntax, and rspec QA testing.

## Limitations

Unix family OS support only right now but it could be adapted for Windows.
