class trafficserver::firewall
(
  $todest80   = undef,
  $todest443  = undef,
)
{
firewall { '010 Foreward http to ats':
  dport   => [ 80 ],
  proto   => 'tcp',
  jump    => 'DNAT',
  chain   => 'PREROUTING',
  table   => 'nat',
  iniface => 'eth0',
  todest  => "${todest80}:80",
  }

firewall { '011 Foreward https to ats':
  dport   => [ 443 ],
  proto   => 'tcp',
  jump    => 'DNAT',
  chain   => 'PREROUTING',
  table   => 'nat',
  iniface => 'eth0',
  todest  => "${todest443}:443",
  }
}
