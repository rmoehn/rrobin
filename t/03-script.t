use 5.010;
use warnings;
use strict;

use Errno qw(EAGAIN EPERM ESRCH);
use File::Temp qw(tempfile);

use Test::More 'no_plan';
use Test::Command;

my $prog    = './script/rrobin';

# First, we have to test whether the program does not stop running when
# nothing is done to it. For that, it is necessary to do a manual fork.
{
######################################################################
note 'test whether the program runs stablely';
######################################################################
my $command = $prog;

my $exit_status;

# We also want to control the output of the script and thus have to
# redirect STDOUT and STDERR.
## save the old ones
open SAVEOUT, '>&', \*STDOUT
    or die "Can't duplicate STDOUT: $!";
open SAVEERR, '>&', \*STDERR
    or die "Can't duplicate STDERR: $!";

## redirect into temporary files
my $temp_stdout_file = (tempfile(UNLINK => 1))[1];
my $temp_stderr_file = (tempfile(UNLINK => 1))[1];
open STDOUT, '>', $temp_stdout_file
    or die "Can't duplicate the handle for the temporary STDOUT"
         . "file: $!";
open STDERR, '>', $temp_stderr_file
    or die "Can't duplicate the handle for the temporary STDERR"
         . "file: $!";

select STDERR; $| = 1;
select STDOUT; $| = 1;

FORK: {
    if (my $pid = fork) {
        # Wait a second. Or two.
        sleep 2;
        # ...Then test what has happened with Myrtscht in the mean time.
        if (kill 0 => $pid) {
            ok(1, 'It runs.');
            # Thus kill it softly.
            kill 'SIGTERM' => $pid
                or die "Not able to kill Myrtscht: $!";
            waitpid $pid, 0;

            $exit_status    = $? >> 8;
        } elsif ($! == EPERM) {
            die "Myrtscht is no longer under my control: $!";
        } elsif ($! == ESRCH) {
            waitpid $pid, 0;
            die "Myrtscht has died before time: $!";
        } else {
            die "Unknown status of Myrtscht: $!";
        }
    }
    elsif (defined $pid) {
        exec $command
            or die "Can't execute $command: $!";
        exit 0;
    }
    elsif ($! == EAGAIN) {
        warn "$! on fork. Will try again in five seconds.";
        sleep 5;
        redo FORK;
    }
    else {
        die "Unable to fork: $!";
    }
}

## restore the old handles
open STDOUT, '>&', \*SAVEOUT
    or die "Can't restore STDOUT: $!";
open STDERR, '>&', \*SAVEERR
    or die "Can't restore STDERR: $!";
close SAVEOUT;
close SAVEERR;

## now read what the script has written
open TEMPOUT, '<', $temp_stdout_file;
open TEMPERR, '<', $temp_stderr_file;

undef $/;
my $scripts_stdout = <TEMPOUT>;
my $scripts_stderr = <TEMPERR>;
close TEMPOUT;
close TEMPERR;

is($exit_status, 1, 'exit status 1');
is($scripts_stdout, "", 'no output on STDOUT');
is($scripts_stderr, "", 'no output on STDERR');
}




{
my $command = "$prog -v";

for my $signal (qw(SIGINT SIGTERM)) {
######################################################################
    note "test whether the program responds correctly to $signal";
######################################################################

    my ($stdout, $stderr, $exit) = test_signal($command => $signal);
    is($exit, 1, 'exit status 1');
    is($stdout, '', 'no output on STDOUT');
    like($stderr,
        qr{
            INFO\s+rrobin.+Rrobin\sinitialized\sat.+\n
            (.+\n)+
            FATAL\s+rrobin.+$signal\scaught\.\s
                Exiting\srelatively\sregularly\sat.+\n
        }x,
        'correct verbose output on STDERR'
        );
}
}


# run now automatically in testing mode
my $command = "$prog -t";

{
######################################################################
note 'test whether the -t switch works at all';
######################################################################
# If it does not work, the program runs endlessly. Thus we would have to
# die.
$SIG{ALRM} = sub {
    die "-t switch does not work properly. Dying for that reason.";
};

my $normal_run = Test::Command->new( cmd => $command );

# Activate the timeout. Ten seconds should be enough for an application
# that is expected to run not more than two seconds.
alarm 10;

# Run the program.
$normal_run->exit_is_num(0, 'exit code is 0');
# And deactivate the timeout immediately.
alarm 0;

# Some other tests.
$normal_run->stderr_is_eq('', 'no output on STDERR');
$normal_run->stdout_is_eq('', 'no output on STDOUT');
}


{
######################################################################
note 'run in verbose mode (-v switch)';
######################################################################
my $verbose_run = Test::Command->new( cmd => "$command -v" );
$verbose_run->exit_is_num(0, 'exit code is ');
$verbose_run->stderr_like(
        qr{
            INFO\s+rrobin.+Rrobin\sinitialized\sat.+\n
            (.+\n)+
            INFO\s+rrobin.+Rrobin\sended\sregularly\sat.+\n
        }x,
        'correct verbose output on STDERR'
        );
$verbose_run->stdout_is_eq('', 'no output on STDOUT');
}


{
######################################################################
note 'run longer than the standard value of 1 second before SIGALRM';
######################################################################
my $large_test_run = Test::Command->new( cmd => "$command 3 -v" );
$large_test_run->exit_is_num(0, 'exit code is ');
$large_test_run->stderr_like(
        qr{
            INFO\s+rrobin.+Rrobin\sinitialized\sat.+\n
            (.+\n)+?
            DEBUG\s+rrobin.+Time\suntil\sSIGALRM\sset\sto\s3\sseconds.+\n
            (.+\n)+
            INFO\s+rrobin.+Rrobin\sended\sregularly\sat.+\n
        }x,
        'correct verbose output on STDERR'
        );
$large_test_run->stdout_is_eq('', 'no output on STDOUT');
}


{
######################################################################
note 'test whether it logs';
######################################################################

# It could be possible that there already is one.
if (-e 'rrobin.log') {
    unlink 'rrobin.log'
        or die "Can't unlink old rrobin.log: $!";

my $log_run = Test::Command->new( cmd => "$command -l" );
$log_run->exit_is_num(0, 'exit code is ');
$log_run->stderr_is_eq('', 'no output on STDERR');
$log_run->stdout_is_eq('', 'no output on STDOUT');

if (ok(-e 'rrobin.log')) {
    open LOGFILE, '<', 'rrobin.log';
    undef $/;
    my $logfile = <LOGFILE>;

    like($logfile,
            qr{
                INFO\s+rrobin.+Rrobin\sinitialized\sat.+\n
                (.+\n)+
                INFO\s+rrobin.+Rrobin\sended\sregularly\sat.+\n
            }x,
            'correct output in the log file'
        );

    unlink 'rrobin.log'
        or die "Can't unlink rrobin.log: $!";
}
}
}


{
######################################################################
note 'ask for help (-h switch)';
######################################################################
my $command = "$prog -h";

my $help_run = Test::Command->new( cmd => $command );
$help_run->exit_is_num(1, 'exit code is 1');
$help_run->stderr_is_eq('', 'no output on STDERR');
$help_run->stdout_isnt_eq('', 'some output on STDOUT');
    # assuming that it is the right output
}


{
######################################################################
note 'handle unknown command line options correctly';
######################################################################
my $unknown_switch_run = Test::Command->new( cmd => "$command -q" );
$unknown_switch_run->exit_is_num(2, 'exit code is 2');
$unknown_switch_run->stderr_isnt_eq('', 'some output on STDERR');
    # assuming that it is the right output
$unknown_switch_run->stdout_is_eq('', 'no output on STDOUT');
}


# This subroutine is resembling the first test block to some degree. But
# this one will return STDOUT, STDERR and exit code of a program that
# received a certain signal.
sub test_signal {
    my $command = shift;
    my $signal  = shift;

    my $exit_status;
    
    # We also want to control the output of the script and thus have to
    # redirect STDOUT and STDERR.
    ## save the old ones
    open SAVEOUT, '>&', \*STDOUT
        or die "Can't duplicate STDOUT: $!";
    open SAVEERR, '>&', \*STDERR
        or die "Can't duplicate STDERR: $!";
    
    ## redirect into temporary files
    my $temp_stdout_file = (tempfile(UNLINK => 1))[1];
    my $temp_stderr_file = (tempfile(UNLINK => 1))[1];
    open STDOUT, '>', $temp_stdout_file
        or die "Can't duplicate the handle for the temporary STDOUT"
             . "file: $!";
    open STDERR, '>', $temp_stderr_file
        or die "Can't duplicate the handle for the temporary STDERR"
             . "file: $!";
    
    select STDERR; $| = 1;
    select STDOUT; $| = 1;
    
    FORK: {
        if (my $pid = fork) {
            # Let it have some time.
            sleep 1;

            # Kill it softly.
            kill $signal => $pid
                or die "Not able to send $signal to Myrtscht: $!";
            waitpid $pid, 0;

            $exit_status    = $? >> 8;
        }
        elsif (defined $pid) {
            exec $command
                or die "Can't execute $command: $!";
            exit 0;
        }
        elsif ($! == EAGAIN) {
            warn "$! on fork. Will try again in five seconds.";
            sleep 5;
            redo FORK;
        }
        else {
            die "Unable to fork: $!";
        }
    }
    
    ## restore the old handles
    open STDOUT, '>&', \*SAVEOUT
        or die "Can't restore STDOUT: $!";
    open STDERR, '>&', \*SAVEERR
        or die "Can't restore STDERR: $!";
    close SAVEOUT;
    close SAVEERR;
    
    ## now read what the script has written
    open TEMPOUT, '<', $temp_stdout_file;
    open TEMPERR, '<', $temp_stderr_file;
    
    undef $/;
    my $scripts_stdout = <TEMPOUT>;
    my $scripts_stderr = <TEMPERR>;
    close TEMPOUT;
    close TEMPERR;

    return $scripts_stdout, $scripts_stderr, $exit_status;
}

__END__

{
######################################################################
note '';
######################################################################
my $ = Test::Command->new( cmd => "$command " );
$->exit_is_num(0, 'exit code is ');
$->stderr_is_eq('', '');
$->stdout_is_eq('', '');
}

