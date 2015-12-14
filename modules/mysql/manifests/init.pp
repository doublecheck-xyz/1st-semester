class mysql {
        package { "mysql-server" :
                ensure => present,
        }
        exec { 'enable_bin_log':
                command => '/bin/sed -i "s/#log_bin/log_bin/g" /etc/mysql/my.cnf; /usr/sbin/service mysql restart',
                onlyif => '/bin/grep -q "#log_bin" /etc/mysql/my.cnf',
                require => Package['mysql-server'],
        }
}

