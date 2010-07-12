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

use Log::Log4perl ':easy';
use Carp;
use Gtk2 '-init';
use Gtk2::GladeXML::Simple;
use base 'Gtk2::GladeXML::Simple';


our $VERSION = '0.001';
$VERSION = eval $VERSION;


# For documentation see the OTHER SUBROUTINES section some way down this
# document.
sub _log_call () { 
    local $Log::Log4perl::caller_depth += 1;

    DEBUG 'Called.';
}


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
    (my $glade_file = $module_path) =~ s/Rrobin\.pm/rrobin.glade/
        or LOGDIE "Could not find the Glade file.\n";

    # Now we can load it.
    my $self    = $class->SUPER::new($glade_file);
    DEBUG 'Created a new instance of Gtk2::GladeXML::Simple.';

    return $self;
}


=head1 CALLBACK FUNCTIONS

=head2 mainwindow_quit

When someone clicks on the little cross... then quit.

=cut

sub mainwindow_quit { 
    _log_call;
    
    Gtk2->main_quit;
}

sub new_clicked {
    _log_call;
}


=head1 OTHER SUBROUTINES

=head2 _logcall

This subroutine is just for intern use. It logs the called function name
when a signal is emitted by the GUI.

=cut
# It was not possible to place it here because of the documentation
# structure and because it has to be known earlier.

1;
