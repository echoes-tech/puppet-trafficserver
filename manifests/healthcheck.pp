class trafficserver::healthcheck
(
  $balancer_map     = balancer_map,
  $balancer_algo    = balancer_algo,
  $balancer_backend = balancer_backend,
) inherits trafficserver
{
  file { "$bindir/traffic_healthcheck.sh":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0754',
    content => template('trafficserver/healthcheck.sh.erb'),
  }->

  exec { 'trafficserver-healthcheck':
    command     => "$bindir/traffic_healthcheck.sh", 
    #refreshonly => true,
  }->

  Exec['trafficserver-config-reload']

  file { "$bindir/traffic_healthcheck_daemon.sh":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0754',
    content => template('trafficserver/healthcheck_daemon.sh.erb'),
  }->

  exec { "$bindir/traffic_healthcheck_daemon.sh &":
  path    => [
    '/usr/local/bin',
    '/usr/bin',
    '/bin'],
  unless  => 'ps aux | grep \'[t]raffic_healthcheck_daemon.sh\' > /dev/null',
  }
}
