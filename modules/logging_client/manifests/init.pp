class logging_client {
    exec { 'rsyslogd':
        path => "/usr/bin/:/usr/sbin/:/usr/local/bin:/bin/:/sbin",
        command => "echo '*.* @@10.1.1.4:5514' >> /etc/rsyslog.d/50-default.conf",
        unless => "cat /etc/rsyslog.d/50-default.conf | grep -q 10.1.1.4" 
    }
    service { 'rsyslog' :
        ensure => running,
        subscribe => Exec['rsyslogd'],
    }

}
