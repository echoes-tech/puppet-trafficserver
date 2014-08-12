class trafficserver::firewall
(
  $todest   = undef,
)
{
firewall { '010 Foreward http to ats':
  dport   => [ 80 ],
  proto   => 'tcp',
  jump    => 'DNAT',
  chain   => 'PREROUTING',
  table   => 'nat',
  iniface => 'eth0',
  todest  => "${todest}:80",
  }
}
