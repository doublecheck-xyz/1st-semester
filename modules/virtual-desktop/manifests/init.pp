class virtual-desktop {

        package { "xfce4" :
                ensure => present,
        }

        package { "xfce4-goodies" :
                ensure => present,
		require => Package['xfce4'],
        }

        package { "tightvncserver" :
                ensure => present,
		require => Package['xfce4-goodies'],
        }

        package { "ubuntu-desktop" :
                ensure => present,
        }
}
