class demo_manager {
    $repo_base = "/srv/www/htdocs/ceph-demo"
    $rpm_src = "/home/ec2-user/SUSE-Storage-1.0-M1/dist.suse.de/install/SLP/SUSE-Storage-1.0-M1/x86_64/CD1/suse/x86_64/"
    $rpm_src2 = "/home/ec2-user/SUSE-Storage-1.0-M1/dist.suse.de/install/SLP/SUSE-Storage-1.0-M1/x86_64/CD1/suse/noarch/"
    package { 'apache':
        ensure => latest,
        name => 'apache2',
        allow_virtual => false
    }
    service { 'apache2':
        ensure  => "running",
        enable    => true,
        hasstatus => false,
        require   => Package["apache"],
    }
    file { 'reporoot':
        path => $repo_base,
        ensure => "directory",
        owner  => "root",
        group  => "root",
        mode   => 755,
        require => Service['apache2'],
    }
    cron { "rpm_repu_update":
        command => "rsync -ca $rpm_src/*.rpm $rpm_src2/*.rpm $repo_base",
        user    => 'root',
        minute  => [35],
        require =>  File [ 'reporoot' ],
    }
    cron { "createrepo":
        command => "/usr/bin/createrepo $repo_base",
        user    => 'root',
        minute  => [45],
        #minute  => "*",
        hour  => "*",
    }
}

