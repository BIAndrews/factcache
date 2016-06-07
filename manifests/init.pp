# Class: factcache
# ===========================
#
# Factcache caches facter facts locally for 3rd party offline integration
#
# Parameters
# ----------
#
# * `json`
#   Bool, enable/disable to enable JSON file save.
#
# * `yaml`
#   Bool, enable/disable to enable YAML file save.
#
# * `file_json`
#   File name of the JSON cache file. undef or "" to disable.
#
# * `file_yaml`
#   File name of the YAML cache file. undef or "" to disable.
#
# * `minute`
#   Array of minutes to run the cron job. For a single job use an array like this [30], not a string or an int.
#
class factcache (

  $json        = true,        
  $yaml        = true,        
  $file_json   = 'facts.json',
  $file_yaml   = 'facts.yaml',
  $minute      = [00,59],

) inherits ::factcache::params {

  #
  # validation
  #
  validate_bool($yaml)
  validate_bool($json)
  validate_string($file_json)
  validate_string($file_yaml)
  validate_array($minute)

  #
  #BUG: we should be using && to make sure it worked before we move the file from /tmp but a bug in PE prevents that
  #BUG LINK: https://tickets.puppetlabs.com/browse/FACT-1227
  #
  $update_json = "/bin/sh -c 'facter --puppet --json >${::factcache::params::tmp}/${file_json}; mv -f ${::factcache::params::tmp}/${file_json} ${::factcache::params::vardir}/${file_json}'"
  $update_yaml = "/bin/sh -c 'facter --puppet --yaml >${::factcache::params::tmp}/${file_yaml}; mv -f ${::factcache::params::tmp}/${file_yaml} ${::factcache::params::vardir}/${file_yaml}'"

  #
  # setup the cron job and exec for the json file
  #
  if $json {

    cron { "$name JSON file":
      ensure  => 'present',
      command => $update_json,
      minute  => $minute,
      require => File[$::factcache::params::vardir],
    }

    #
    # if this is a fresh install create the cache file right away
    #
    exec { "$name update JSON now":
      command     => $update_json,
      logoutput   => on_failure,
      refreshonly => true,
      subscribe   => File[$::factcache::params::vardir],
    }

  }

  #
  # setup the cron job and exec for the yaml file
  #
  if $yaml {

    cron { "$name YAML file":
      ensure  => 'present',
      command => $update_yaml,
      minute  => $minute,
      require => File[$::factcache::params::vardir],
    }

    #
    # if this is a fresh install create the cache file right away
    #
    exec { "$name update YAML now":
      command     => $update_yaml,
      logoutput   => on_failure,
      refreshonly => true,
      subscribe   => File[$::factcache::params::vardir],
    }

  }

  class { '::factcache::install': } ->
  Class['::factcache']
}
