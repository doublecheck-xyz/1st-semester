class loadbalancer {
        package { "pound" :
                ensure => present,
        }
}

