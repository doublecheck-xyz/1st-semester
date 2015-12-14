class apache-php {
        package { "apache2" :
                ensure => present,
        }

        package { "php5" :
                ensure => present,
        }

        package { "php-mysql" :
                ensure => present,
        }

}

