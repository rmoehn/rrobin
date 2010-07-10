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
        name        => 'maintoolbar',
        type        => 'GtkToolbar',
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
    'Main toolbar correct.'
);

# the toolbar for the tree
ok($test->find_widget(
    {
        name        => 'treetoolbar',
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
    'Toolbar for the tree correct.'
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

# the buttons of the toolbar for the tree
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
                clicked     => 'groupadd_clicked',
            },
    } ),
    'Group-add button correct.'
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
                clicked     => 'playeradd_clicked',
            },
    } ),
    'Player-add button correct.'
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
                clicked     => 'remove_clicked',
            },
    } ),
    'Remove button correct.'
);

ok($test->find_widget(
    {
        name        => 'print',
        type        => 'GtkToolButton',
        properties  =>
            {
                label       => 'Print',
                stock_id    => 'gtk-print',
            },
        packing     =>
            {
            },
        signals     =>
            {
                clicked     => 'print_clicked',
            },
    } ),
    'Print button correct.'
);

# the buttons of the main toolbar
ok($test->find_widget(
    {
        name        => 'new',
        type        => 'GtkToolButton',
        properties  =>
            {
                label       => 'New',
                stock_id    => 'gtk-new',
            },
        packing     =>
            {
            },
        signals     =>
            {
                clicked     => 'new_clicked',
            },
    } ),
    'Remove button correct.'
);

ok($test->find_widget(
    {
        name        => 'open',
        type        => 'GtkToolButton',
        properties  =>
            {
                label       => 'Open',
                stock_id    => 'gtk-open',
            },
        packing     =>
            {
            },
        signals     =>
            {
                clicked     => 'open_clicked',
            },
    } ),
    'Open button correct.'
);

ok($test->find_widget(
    {
        name        => 'save',
        type        => 'GtkToolButton',
        properties  =>
            {
                label       => 'Save',
                stock_id    => 'gtk-save',
            },
        packing     =>
            {
            },
        signals     =>
            {
                clicked     => 'save_clicked',
            },
    } ),
    'Save button correct.'
);

ok($test->find_widget(
    {
        name        => 'saveas',
        type        => 'GtkToolButton',
        properties  =>
            {
                label       => 'Save As',
                stock_id    => 'gtk-save-as',
            },
        packing     =>
            {
            },
        signals     =>
            {
                clicked     => 'saveas_clicked',
            },
    } ),
    'Saveas button correct.'
);

ok($test->find_widget(
    {
        name        => 'preferences',
        type        => 'GtkToolButton',
        properties  =>
            {
                label       => 'Preferences',
                stock_id    => 'gtk-preferences',
            },
        packing     =>
            {
            },
        signals     =>
            {
                clicked     => 'preferences_clicked',
            },
    } ),
    'Preferences button correct.'
);

ok($test->find_widget(
    {
        name        => 'about',
        type        => 'GtkToolButton',
        properties  =>
            {
                label       => 'About',
                stock_id    => 'gtk-about',
            },
        packing     =>
            {
            },
        signals     =>
            {
                clicked     => 'about_clicked',
            },
    } ),
    'About button correct.'
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

# the table with the ranking
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

# the statusbar
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

