class apache {

  package { 'httpd':
    ensure => installed,
  }

  service { 'httpd':
		ensure => running,
		enable => true,
	}
  
	file { '/mnt/ebs/':
    ensure => directory,
    owner => 'apache',
    group => 'apache',
    mode   => '0755',
  }

  file { '/etc/httpd/conf/httpd.conf':
    ensure => file,
    content => template('apache/httpd.conf.erb'), 
  }

  file { '/mnt/ebs/index.html':
    ensure => 'file',
    owner => 'apache',
    group => 'apache',
    mode => '0644',
    content => '<html><body><h1>Hello from EBS!</h1></body></html>',
    notify => Service['httpd'],
  }

  package { 'python3':
    ensure => 'latest',
  }

  package { 'chrony':
    ensure => 'present',
  }

  service { 'chronyd':
    ensure => running,
    enable => true,
  }

  file { '/etc/chrony.conf':
    content => "server time1.google.com iburst\nserver time2.google.com iburst\nserver time3.google.com iburst",
    notify => Service['chronyd'],
  }

  cron { 'puppet-agent':
    command => 'sudo /opt/puppetlabs/bin/puppet apply --modulepath=/tmp/packer-puppet-masterless/module-0 -e "include apache" --debug --detailed-exitcodes',
    user => 'root',
  }

}
