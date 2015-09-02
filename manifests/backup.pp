# == Defined Type: dar::backup
#
# dar::backup creates a local backup with dar. The basename of the backup
#
# === Parameters
#
# [*backup_storage*]
#   The target directory for backups (default: '/srv/backups')
#
# [*flag_dir*]
#   The directory in which we create the flag file when backups are done inside $backup_storage (default: 'backups_done')
#
# [*lock_dir*]
#   The directory where we store locks for backups inside $backup_storage (default: 'locks')
#
# [*config_dir*]
#   The directory where we store config files for backups inside $backup_storage (default: 'config')
#
# [*hour*]
#   Passed to the cron specification for the backup (optional)
#
# [*minute*]
#   Passed to the cron specification for the backup (optional)
#
# [*month*]
#   Passed to the cron specification for the backup (optional)
#
# [*monthday*]
#   Passed to the cron specification for the backup (optional)
#
# [*weekday*]
#   Passed to the cron specification for the backup (optional)
#
# [*keep_backups*]
#   The number of backups to keep (default: 1)
#
# [*backup_base*]
#   The base directory to backup
#
# [*backup_selection*]
#   The folders to backup (optional, array)
#
# [*backup_exclusion*]
#   The folders to exclude (optional, array)
#
# [*backup_options*]
#   Extra options to pass to dar (optional, string)
#
# === Examples
#
#  dar::backup {'root':
#    target_dir => '/srv/local-backups',

#  }
#
# === Authors
#
# Nicolas Dandrimont <nicolas@dandrimont.eu>
#
# === Copyright
#
# Copyright 2015 Nicolas Dandrimont
#

define dar::backup (
  $backup_storage   = '/srv/backups',
  $flag_dir         = 'backups_done',
  $lock_dir         = 'locks',
  $config_dir       = 'config',
  $hour             = undef,
  $minute           = undef,
  $month            = undef,
  $monthday         = undef,
  $weekday          = undef,
  $keep_backups     = 1,
  $backup_base      = '/',
  $backup_selection = [],
  $backup_exclusion = [],
  $backup_options   = [],
  ) {

  include dar

  validate_absolute_path($backup_storage)
  validate_string($flag_dir)
  validate_string($lock_dir)
  validate_string($config_dir)
  validate_integer($keep_backups, undef, 1)
  validate_absolute_path($backup_base)

  $real_flag_dir   = "${backup_storage}/${flag_dir}"
  $real_lock_dir   = "${backup_storage}/${lock_dir}"
  $real_config_dir = "${backup_storage}/${config_dir}"

  $flag_path     = "${real_flag_dir}/${title}"
  $lock_path     = "${real_lock_dir}/${title}"
  $config_path   = "${real_config_dir}/${title}.config"
  $includes_path = "${real_config_dir}/${title}.includes"
  $excludes_path = "${real_config_dir}/${title}.excludes"

  file { $backup_storage:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

  file { [
      "${real_flag_dir}",
      "${real_lock_dir}",
      "${real_config_dir}",
    ]:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => File[$backup_storage],
  }

  cron { "dar.${title}":
    ensure   => present,
    user     => 'root',
    command  => "/usr/local/bin/swh-dar-backup \"${config_path}\"",
    hour     => $hour,
    minute   => $minute,
    month    => $month,
    monthday => $monthday,
    weekday  => $weekday,
    require  => [
      File['/usr/local/bin/swh-dar-backup'],
      File[$config_path],
    ],
  }

  file { $config_path:
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('dar/config.erb'),
    require => [
      File[$real_config_dir],
      File[$includes_path],
      File[$excludes_path],
    ],
  }

  file { $includes_path:
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('dar/include.erb'),
  }

  file { $excludes_path:
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('dar/exclude.erb'),
  }
}
