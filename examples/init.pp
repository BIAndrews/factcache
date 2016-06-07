# Both YAML and JSON
#class { ::factcache: }

# YAML  only
#class { '::factcache':
#  json => false,
#}

# JSON only
class { '::factcache':
  yaml => false,
}
