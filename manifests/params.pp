# == Class factcache::params
#
# This class is meant to be called from factcache.
# It sets variables according to platform.
#
class factcache::params (

  $mode  = '0664',
  $owner = 'root',
  $group = 'root',

){

  # Future use if ever needed
  case $::osfamily {
    #'Debian': {
    #  $vardir = '/var/cache/facts'
    #}
    #'RedHat', 'Amazon': {
    #  $vardir = '/var/cache/facts'
    #}
    default: {
      $vardir     = '/var/cache/facts' # location to save json/yaml files in
      $tmp        = '/tmp'             # OS tmp directory to use
    }
  }

}
