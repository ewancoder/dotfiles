##
## Put me in ~/.irssi/scripts, and then execute the following in irssi:
##
##       /load perl ##       /script load notify
##

use strict; use Irssi; use vars qw($VERSION %IRSSI); use HTML::Entities;

$VERSION = "0.5";
%IRSSI = (
    authors     => 'Luke Macken, Paul W. Frields',
    contact     => 'lewk@csh.rit.edu, stickster@gmail.com',
    name        => 'notify.pl',
    description => 'Use D-Bus to alert user to hilighted messages',
    license     => 'GNU General Public License',
    url         => 'http://code.google.com/p/irssi-libnotify',
);

Irssi::settings_add_str('notify', 'notify_remote', '');

sub sanitize {
    my ($text) = @_;
    encode_entities($text,'\'<>&');
    my $apos = "&#39;";
    my $aposenc = "\&apos;";
    $text =~ s/$apos/$aposenc/g;
    $text =~ s/"/\\"/g;
    return $text;
}

sub notify {
    my ($server, $summary, $message, $level, $time) = @_;

    # Make the message entity-safe
    $summary = sanitize($summary);
    $message = sanitize($message);

    open(FILE, ">>/root/.irssi/notifications");
    print FILE $summary . "Þ". $message . "Þ" . $level . "Þ" . $time . "\n";
    close(FILE)
}

sub print_text_notify {
    my ($dest, $text, $stripped) = @_;
    my $server = $dest->{server};
    #my $channel = $dest->{channel};
    return if (!$server || !($dest->{level} & MSGLEVEL_HILIGHT));
    my $sender = $stripped;
    $sender =~ s/^\<?(.+?)\>? .*/\1/ ;
    $stripped =~ s/^.+? +(.*)/\1/ ;
    notify($server, 'From '.$sender, $stripped);
}

sub message_private_notify {
    my ($server, $msg, $nick, $address) = @_;

    return if (!$server);
    notify($server, "PM from ".$nick, $msg, "critical", 0);
}

sub dcc_request_notify {
    my ($dcc, $sendaddr) = @_;
    my $server = $dcc->{server};

    return if (!$dcc);
    notify($server, "DCC ".$dcc->{type}." request", $dcc->{nick}, "critical", 0);
}

sub message_public_notify {
    my ($server, $msg, $nick, $address, $target) = @_;

    return if (!$server);
    
    my $mynick = $server->{nick};
    chomp $mynick;

    our $date;

    if ($target =~ "#ewancoder") {
        if ($msg =~ m/.*$mynick.*/) {
            notify($server, "Highlight ".$nick." > ".$target, $msg, "critical", "0");
        } else {
            notify($server, "Public ".$nick." > ".$target, $msg, "normal", "20");
        }
    } elsif ($target =~ "#twitter") {
        my $nowdate = localtime();
        if (not($date eq $nowdate)) {
            notify($server, "Twitter ".$nick." > ".$target, $msg, "normal", "0");
        }
        $date = localtime();
    } else {
        if ($msg =~ m/.*$mynick.*/) {
            notify($server, "Highlight ".$nick." > ".$target, $msg, "low", "0");
        }
    }
}

Irssi::signal_add('message public', 'message_public_notify');
Irssi::signal_add('message private', 'message_private_notify');
Irssi::signal_add('dcc request', 'dcc_request_notify');
