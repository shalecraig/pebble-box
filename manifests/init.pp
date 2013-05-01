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
    command => "wget https://dl.dropboxusercontent.com/u/2135156/pebble-sdk-release-001.zip",
    timeout => 0,
    cwd => "/home/vagrant",
    path => "/usr/bin",
    creates => "/home/vagrant/pebble-sdk-release-001.zip",
    require => Package["python-pip"]
}

exec { "unzip-sdk":
    command => "unzip pebble-sdk-release-001.zip",
    path => "/usr/bin",
    cwd => "/home/vagrant",
    creates => "/home/vagrant/pebble-sdk-release-001",
    require => Exec["download-sdk"]
}

exec { "download-toolchain":
    command => "wget http://developer.getpebble.com/files/sdk-release-001/arm-cs-tools-ubuntu-12.04-2012-12-22.tar.bz2",
    timeout => 0,
    cwd => "/home/vagrant",
    path => "/usr/bin",
    creates => "/home/vagrant/arm-cs-tools-ubuntu-12.04-2012-12-22.tar.bz2",
    require => Exec["unzip-sdk"]
}

exec { "untar-toolchain":
    command => "tar -xjf arm-cs-tools-ubuntu-12.04-2012-12-22.tar.bz2",
    path => "/bin",
    cwd => "/home/vagrant",
    creates => "/home/vagrant/arm-cs-tools",
    require => Exec["download-toolchain"]
}

$pebble_env = "export PATH=~/arm-cs-tools/bin:\$PATH
               export PEBBLEDIR=/home/vagrant/pebble-sdk-release-001
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
