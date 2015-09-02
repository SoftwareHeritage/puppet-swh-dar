# == Defined Type: dar::remote_backup
#
# dar::remote_backup creates a crontab fetching a remote backup from dar
#
# === Parameters
#
# [*remote_backup_storage*]
#   The directory for backups on the remote host (default: '/srv/backups')
#
# [*remote_backup_name*]
#   The name for the remote backup to retreive (default: "$::hostname")
#
# [*local_backup_storage*]
#   The directory the remote backups are copied to on the backup server (default: '/srv/remote-backups')
#
# [*hour*]
#   Passed to the cron specification for the remote backup (optional)
#
# [*minute*]
#   Passed to the cron specification for the remote backup (optional)
#
# [*month*]
#   Passed to the cron specification for the remote backup (optional)
#
# [*monthday*]
#   Passed to the cron specification for the remote backup (optional)
#
# [*weekday*]
#   Passed to the cron specification for the remote backup (optional)
#

define dar::remote_backup (
  $remote_backup_storage = '/srv/backups',
  $remote_backup_name    = "$::hostname",
  $local_backup_storage  = '/srv/remote-backups',
  $hour                  = undef,
  $minute                = undef,
  $month                 = undef,
  $monthday              = undef,
  $weekday               = undef,
) {
  cron { "dar_remote_backup.${::hostname}.${remote_backup_name}":
    ensure   => present,
    user     => 'root',
    command  => "/usr/local/bin/swh-dar-copy-remote-backup \"${::hostname}\" \"${remote_backup_name}\" \"${remote_backup_storage}\" \"${local_backup_storage}\"",
    hour     => $hour,
    minute   => $minute,
    month    => $month,
    monthday => $monthday,
    weekday  => $weekday,
    require  => File['/usr/local/bin/swh-dar-copy-remote-backup'],
  }
}
