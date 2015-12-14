class backup_client {
  file { "/root/.ssh" :
    ensure => directory,
    mode => 644,
  }

  file { "/root/.ssh/authorized_keys" :
    ensure => present, 
    require => File['/root/.ssh'],
    source => 'puppet:///modules/backup_client/authorized_keys',
  }
}
