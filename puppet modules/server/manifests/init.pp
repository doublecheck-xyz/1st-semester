class server {
        package { "ntp" :
                ensure => present,
        }
        exec { "enable_password_login" :
                command => '/bin/sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config; service ssh restart',
                onlyif => '/bin/grep -q "PasswordAuthentication no" /etc/ssh/sshd_config',
        }
        package { "emacs" :
                ensure => present,
        }
        group { "webadmins" :
                ensure => present,
        }
        user { "tom" :
                ensure => present,
                password => '$6$nr7OwZ9R$N8eyKxdj6CyeZQj/WB8dPyIx0uInHzGhtxj/KopaUYRhBjR927PWczYApYeoQw63Yham61ndvjaoh8V5BprwL.',
                gid => 'webadmins',
                groups => 'sudo',
                shell => '/bin/bash',
                home => '/home/tom',
                managehome => true,
        }
        user { "brady" :
                ensure => present,
                password => '$6$ClVYYojT$D0Px/msmYQAFxUkhwkI4h4mEkCVdJTFwktX0LAHixnX2jAmsbqXTHMubfUs04sg65exdZG9WTUwGtUz1ZZ4Ap.',
                gid => 'webadmins',
                groups => 'sudo',
                shell => '/bin/bash',
                home => '/home/brady',
                managehome => true,
        }
        user { "janet" :
                ensure => present,
                password => '$6$Xrxxaggc$O2hr4ETX38Ndu826kGveh8mnscS0Mi.5h2pIuHD/0/iynCibBGYhRWSq4YvPWQF5d/Ti9K2LXrejZyIeZzXHl1',
                gid => 'webadmins',
                groups => 'sudo',
                shell => '/bin/bash',
                home => '/home/janet',
                managehome => true,
        }
}

