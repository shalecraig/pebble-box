exec { "apt-get update":
    path => "/usr/bin",
}

package { "python2.7":
    ensure => present,
    require => Exec["apt-get update"],
}

package { "unzip":
    ensure => present,
    require => Package["python2.7"]
}

package { "libmpc2":
    ensure => present,
    require => Package["unzip"]
}

package { "dpkg-dev":
    ensure => present,
    require => Package["libmpc2"]
}

package { "python-dev":
    ensure => present,
    require => Package["dpkg-dev"]
}

package { "python-pip":
    ensure => present,
    require => Package["python-dev"]
}

exec { "download-sdk":
    command => "wget https://developer.getpebble.com/2/download/PebbleSDK-2.0.1.tar.gz",
    timeout => 0,
    path => "/bin",
    cwd => "/home/vagrant",
    creates => "/home/vagrant/PebbleSDK-2.0.1.tar.gz",
    require => Package["python-pip"]
}

exec { "untar-sdk":
    command => "tar -xjf PebbleSDK-2.0.1.tar",
    path => "/usr/bin",
    cwd => "/home/vagrant",
    creates => "/home/vagrant/PebbleSDK-2.0.1",
    require => Exec["download-sdk"]
}

exec { "download-toolchain":
    command => "wget http://assets.getpebble.com.s3-website-us-east-1.amazonaws.com/sdk/arm-cs-tools-ubuntu-universal.tar.gz",
    timeout => 0,
    cwd => "/home/vagrant",
    path => "/usr/bin",
    creates => "/home/vagrant/arm-cs-tools-ubuntu-universal.tar.gz",
    require => Exec["untar-sdk"]
}

exec { "untar-toolchain":
    command => "tar -xjf arm-cs-tools-ubuntu-universal.tar.gz",
    path => "/bin",
    cwd => "/home/vagrant",
    creates => "/home/vagrant/arm-cs-tools",
    require => Exec["download-toolchain"]
}

$pebble_env = "export PATH=~/arm-cs-tools/bin:\$PATH
               export PEBBLEDIR=/home/vagrant/PebbleSDK-2.0.1
               cd /vagrant"

file { "/etc/profile.d/set-pebble-env.sh":
    ensure => file,
    content => $pebble_env,
    require => Exec["untar-toolchain"]
}

exec { "run-pip":
    command => "pip install --user -r requirements.txt",
    cwd => "/home/vagrant/pebble-sdk-release-001/sdk/",
    path => "/usr/bin",
    require => File["/etc/profile.d/set-pebble-env.sh"]
}
