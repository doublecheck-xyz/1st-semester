class mongodb {
	exec { "import-public-key" :
	    path => "/usr/bin/:/usr/sbin/:/usr/local/bin:/bin/:/sbin",
	    command => "apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10",
	    unless => "apt-key list |grep 7F0CEB10",
	}

	exec { "create-file-list" :
	    path => "/usr/bin/:/usr/sbin/:/usr/local/bin:/bin/:/sbin",
	    command => 'echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list',
	    unless => "ls /etc/apt/sources.list.d/mongodb-org-3.0.list",
	    require => Exec['import-public-key'],
	}
        
	exec { "apt-get-update" :
	    path => "/usr/bin/:/usr/sbin/:/usr/local/bin:/bin/:/sbin",
	    command => 'apt-get update',
	    refreshonly => true,
	    subscribe => Exec['create-file-list'],
	}

	#Exec["apt-get-update"] -> Package <| |>
        package { "mongodb-org" :
                ensure => present,
		require => [ Exec['create-file-list'], Exec['apt-get-update'] ],
        }

	service { "mongod" :
		ensure => running,
		require => Package['mongodb-org'],
	}

}

