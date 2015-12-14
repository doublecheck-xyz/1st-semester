class storage {
    package { "nfs-kernel-server" :
        ensure => present,
    }
    package { "rpcbind" :
        ensure => present,
    }
    file { "/etc/exports" :
        ensure => present,
        source => 'puppet:///modules/storage/exports',
        notify => Exec['exportfs'],
    }
    exec { "exportfs" :
        path => "/usr/bin/:/usr/sbin/:/usr/local/bin:/bin/:/sbin",
        command => "exportfs -ra",
        refreshonly => true,
    }
	service { "nfs-kernel-server" :
		ensure => running,
		require => [ Package['nfs-kernel-server', 'rpcbind'], File['/etc/exports'] ],
	}
}

