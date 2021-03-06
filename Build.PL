use strict;
use warnings;

use Module::Build;

my $build = Module::Build->new(
    module_name => 'Rrobin',
    dist_version_from
                => 'script/rrobin',
    requires    => {
        'perl'          => '5.10.1',
        'Log::Log4perl' => 0,
        'Games::Tournament::RoundRobin'
                        => 0,
    },
    recommends  => {
        'Net::CUPS'     => 0,
    }
)->create_build_script;
