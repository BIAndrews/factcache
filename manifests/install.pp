# == Class factcache::install
#
# This class is called from factcache for install.
#
class factcache::install {

  file { $::factcache::params::vardir:
    ensure => directory,
    mode   => $::factcache::params::mode,
    owner  => $::factcache::params::owner,
    group  => $::factcache::params::group,
  }

}
