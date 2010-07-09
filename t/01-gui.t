use 5.010;
use warnings;
use strict;

use Test::More 'no_plan';
use Test::Glade;

my $test = Test::Glade->new(file => 'lib/Games/Tournament/rrobin.glade');

# the main window
ok(my $mainwindow = $test->find_widget(
    {
        name        => 'mainwindow',
        type        => 'GtkWindow',
        properties  =>
            {
                title       => 'Rrobin',
            },
        signals     =>
            {
                destroy     => 'mainwindow_quit',
            },
    } ),
    'Mainwindow correct.'
    );

# the menubar
ok($test->find_widget(
    {
        name        => 'menubar',
        type        => 'GtkMenuBar',
        properties  =>
            {
            },
        packing     =>
            {
            },
        signals     =>
            {
            },
    } ),
    'Menubar correct.'
);

# the toolbar
ok($test->find_widget(
    {
        name        => 'toolbar',
        type        => 'GtkToolbar',
        properties  =>
            {
                orientation => 'vertical',
            },
        packing     =>
            {
            },
        signals     =>
            {
            },
    } ),
    'Toolbar correct.'
);

# the tree of groups on the left
ok($test->find_widget(
    {
        name        => 'grouptree',
        type        => 'GtkTreeView',
        properties  =>
            {
            },
        packing     =>
            {
            },
        signals     =>
            {
            },
    } ),
    'Grouptree correct.'
);

# the buttons of the toolbar
ok($test->find_widget(
    {
        name        => 'groupadd',
        type        => 'GtkToolButton',
        properties  =>
            {
                label       => 'Add group',
                stock_id    => 'gtk-add',
            },
        packing     =>
            {
            },
        signals     =>
            {
            },
    } ),
    'Group-adding button correct.'
);

ok($test->find_widget(
    {
        name        => 'playeradd',
        type        => 'GtkToolButton',
        properties  =>
            {
                label       => 'Add player',
                stock_id    => 'gtk-add',
            },
        packing     =>
            {
            },
        signals     =>
            {
            },
    } ),
    'Player-adding button correct.'
);

ok($test->find_widget(
    {
        name        => 'remove',
        type        => 'GtkToolButton',
        properties  =>
            {
                label       => 'Remove',
                stock_id    => 'gtk-remove',
            },
        packing     =>
            {
            },
        signals     =>
            {
            },
    } ),
    'Removing button correct.'
);

# the table with the games
ok($test->find_widget(
    {
        name        => 'gametable',
        type        => 'GtkTable',
        properties  =>
            {
            },
        packing     =>
            {
            },
        signals     =>
            {
            },
    } ),
    'Gametable correct.'
);

ok($test->find_widget(
    {
        name        => 'rankingtable',
        type        => 'GtkTreeView',
        properties  =>
            {
            },
        packing     =>
            {
            },
        signals     =>
            {
            },
    } ),
    'Rankingtable correct.'
);

ok($test->find_widget(
    {
        name        => 'statusbar',
        type        => 'GtkStatusbar',
        properties  =>
            {
            },
        packing     =>
            {
            },
        signals     =>
            {
            },
    } ),
    'Statusbar correct.'
);

__END__

ok($test->find_widget(
    {
        name        => '',
        type        => '',
        properties  =>
            {
            },
        packing     =>
            {
            },
        signals     =>
            {
            },
    } ),
    ' correct.'
);

