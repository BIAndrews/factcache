# Class: factcache
# ===========================
#
# Factcache caches facter facts locally for 3rd party offline integration
#
# Parameters
# ----------
#
# * `file_json`
#   File name of the JSON cache file. undef or "" to disable.
#
# * `file_yaml`
#   File name of the YAML cache file. undef or "" to disable.
#
# * `minute`
#   Array of minutes to run the cron job.
#
# * `ensure_cron`
#   present to ensure the cron jobs is present.
#
class factcache (

  $file_json   = 'facts.json',   # undef or "" to disable
  $file_yaml   = 'facts.yaml',   # undef or "" to disable
  $minute      = [00,59],        # cronjob minute array
  $ensure_cron = present,

) inherits ::factcache::params {

  #
  # validation
  #
  validate_array($minute)
  validate_string($ensure_cron)

  #
  #BUG: we should be using && to make sure it worked before we move the file from /tmp but a bug in PE prevents that
  #BUG LINK: https://tickets.puppetlabs.com/browse/FACT-1227
  #
  $update_json = "/bin/sh -c 'facter --puppet --json >${::factcache::params::tmp}/${file_json}; mv -f ${::factcache::params::tmp}/${file_json} ${::factcache::params::vardir}/${file_json}'"
  $update_yaml = "/bin/sh -c 'facter --puppet --yaml >${::factcache::params::tmp}/${file_yaml}; mv -f ${::factcache::params::tmp}/${file_yaml} ${::factcache::params::vardir}/${file_yaml}'"

  #
  # setup the cron job and exec for the json file
  #
  if $file_json != undef or $file_json == "" {

    cron { "$name json file":
      ensure  => $ensure_cron,
      command => $update_json,
      minute  => $minute,
      require => File[$::factcache::params::vardir],
    }

    #
    # if this is a fresh install create the cache file right away
    #
    exec { "$name update json":
      command     => $update_json,
      logoutput   => on_failure,
      refreshonly => true,
      subscribe   => File[$::factcache::params::vardir],
    }

  }

  #
  # setup the cron job and exec for the yaml file
  #
  if $file_yaml != undef or $file_yaml == "" {

    cron { "$name yaml file":
      ensure  => $ensure_cron,
      command => $update_yaml,
      minute  => $minute,
      require => File[$::factcache::params::vardir],
    }

    #
    # if this is a fresh install create the cache file right away
    #
    exec { "$name update yaml":
      command     => $update_yaml,
      logoutput   => on_failure,
      refreshonly => true,
      subscribe   => File[$::factcache::params::vardir],
    }

  }

  class { '::factcache::install': } ->
  Class['::factcache']
}
