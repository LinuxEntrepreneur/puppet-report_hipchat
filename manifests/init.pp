# Class: report_hipchat
#
# Send Puppet report information to HipChat

class report_hipchat (
  $api_key,
  $room,
  $server         = 'https://api.hipchat.com',
  $notify_color   = 'red',
  $notify_room    = false,
  $statuses       = [ 'failed' ],
  $config_file    = "${::report_hipchat::params::puppetconf_path}/hipchat.yaml",
  $package_name   = $::report_hipchat::params::package_name,
  $install_hc_gem = $::report_hipchat::params::install_hc_gem,
  $provider       = $::report_hipchat::params::provider,
  $owner          = $::report_hipchat::params::owner,
  $group          = $::report_hipchat::params::group,
  $puppetboard    = $::report_hipchat::params::puppetboard,
  $dashboard      = $::report_hipchat::params::dashboard,
  $api_version    = $::report_hipchat::params::api_version,
  $proxy          = $::report_hipchat::params::proxy,
) inherits report_hipchat::params {

  exec { 'create_report_directory':
    command => '/bin/mkdir -p /var/lib/puppet/lib/puppet/reports/',
    unless  => 'test -d /var/lib/puppet/lib/puppet/reports/',
    require => Class['puppet'],
  }

  file { '/var/lib/puppet/lib/puppet/reports/hipchat.rb':
    ensure  => 'file',
    source  => 'puppet:///modules/report_hipchat/hipchat_report.rb',
    require => Exec['create_report_directory'],
  }

  file { $config_file:
    ensure  => file,
    owner   => $owner,
    group   => $group,
    mode    => '0440',
    content => template('report_hipchat/hipchat.yaml.erb'),
  }

  if $install_hc_gem {
    package { $package_name:
      ensure   => installed,
      provider => $provider,
    }
  }
}
