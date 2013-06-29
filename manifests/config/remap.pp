# This type handles adding values to remap.config
# array of url maps or redirects. Each entry corresponds
# to a line in remap.config. n.b.: The traffic server
# internal order of processing is: redirects, maps, regex remaps
#
# Example:
#
# redirects => {
#     'http://www.example.org' => 'http://example.org',
#     'http://git.example.org' => 'https://git.example.org',
#   },
#   # n.b.: We allow all methods on git.
# url_map => {
#     # This currently doesn't work:
#     # 'http://example.org http://app04-dev.dev.rz01.riseops.at:9001 @method=GET @method=POST @method=HEAD @method=OPTIONS @action=allow',
#     'https://git.example.org' => 'http://app05-dev.rz01.riseops.at:9002',
#   },
# reverse_map => {
#    'http://app04-dev.dev.rz01.riseops.at:9001' => 'http://example.org',
# }
#   # map everything else to:',
# regex_map => {
#     'http://.*\.dev.example\.org' => 'http://app06-dev.rz01.riseops.at:8000', }, # @method=GET @method=POST @method=HEAD @method=OPTIONS @action=allow',
#     'https://.*\.dev.example\.org' => 'http://app06-dev.rz01.riseops.at:8000, }, # @method=GET @method=POST @method=HEAD @method=OPTIONS @action=allow',
#   },
#
define trafficserver::config::remap (
  $map       = {},
  $rev_map   = UNDEF,
  $regex_map = {},
  $redirects = {},
) {

  include 'trafficserver'
  include 'trafficserver::params'

  $sysconfdir = $trafficserver::real_sysconfdir
  $configfile = "${sysconfdir}/remap.config"

  $lens    = 'Trafficserver_remap.remap_lns'
  $context = "/files${configfile}"
  $incl    = $configfile
  $comment = $title

  # if the reverse_map is empty, create one:
  $reverse_map = $rev_map ? {
    UNDEF   => parseyaml(inline_template('<%= @map.invert.to_yaml %>')),
    default => $reverse_map,
  }

  augeas { "${lens}_${comment}":
    lens    => $lens,
    context => $context,
    incl    => $incl,
    changes =>  template('trafficserver/remap.config.erb'),
  }
}