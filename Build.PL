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
    build_requires
                => {
        'Test::Glade'   => 0,
        'Test::Command' => 0,
    }
);

# Place also the .glade file and the configuration file for the logger
# in the module's directory.
$build->add_build_element('glade');
$build->add_build_element('conf');

$build->create_build_script;
