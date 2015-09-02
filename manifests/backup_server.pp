# == Class: dar::backup_server
#
# dar::backup_server allows the collection of remote backups registered through the dar::remote_backup defined type.
#
# === Examples
#
#  include ::dar::backup_server
#
# === Authors
#
# Nicolas Dandrimont <nicolas@dandrimont.eu>
#
# === Copyright
#
# Copyright 2015 Nicolas Dandrimont
#
class dar::backup_server {
  file {'/usr/local/bin/swh-dar-copy-remote-backup':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/dar/swh-dar-copy-remote-backup'
  }

  Dar::Remote_Backup <<| |>>
}
