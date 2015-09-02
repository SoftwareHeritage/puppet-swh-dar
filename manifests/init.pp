# == Class: dar
#
# dar allows the specification of a backup through the dar::backup defined type.
#
# === Examples
#
#  include ::dar
#
# === Authors
#
# Nicolas Dandrimont <nicolas@dandrimont.eu>
#
# === Copyright
#
# Copyright 2015 Nicolas Dandrimont
#
class dar {
  package {'dar':
    ensure => present,
  }

  file {'/usr/local/bin/swh-dar-backup':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/dar/swh-dar-backup'
  }
}
