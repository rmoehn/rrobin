package Games::Tournament::Rrobin;

=head1 NAME

Games::Tournament::Rrobin - Callback functions for the program B<Rrobin>


=head1 VERSION

This is version 0.001.


=head1 SYNOPSIS

    #!/usr/bin/perl
    
    use Games::Tournament::Rrobin;
    
    Games::Tournament::Rrobin->new->run;


=head1 DESCRIPTION

This module is used by the program B<Rrobin> and implements the callback
functions that are called on events from the graphical user interface.

=cut

use 5.010;
use warnings;
use strict;

use Gtk2 '-init';
use Gtk2::GladeXML::Simple;
use base 'Gtk2::GladeXML::Simple';

our $VERSION = '0.001';
$VERSION = eval $VERSION;


=head1 METHODS

This module, in fact, provides just the one following method.
It is inherited from the Gtk2::GladeXML::Simple class. So
don't ask me what it does in detail.

=head2 new

Construct the object that contains the application. 

=cut

sub new {
    my $class   = shift;

    # First we have to find the .glade file.
    my $module_path = __FILE__;
    (my $glade_file = $module_path) =~ s/Rrobin\.pm/rrobin.glade/;

    # Now we can load it.
    my $self    = $class->SUPER::new($glade_file);

    return $self;
}


=head1 CALLBACK FUNCTIONS

=head2 mainwindow_quit

When someone clicks on the little cross... then quit.

=cut

sub mainwindow_quit { Gtk2->main_quit }

1;
