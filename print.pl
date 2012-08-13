#!/usr/bin/env perl
use utf8;
use 5.12.0;
use DateTime;
use Business::TW::Invoice::U420;
use Encode 'encode';
binmode STDIN, ':utf8';
my @all = split /\n\.\n/, join '', <>;
while (@all) {
    my @tickets = splice(@all, 0, 10);

    open my $com3, '>', 'COM3';
    my $u420 = Business::TW::Invoice::U420->new(
        { heading => [],
            lines_total => 35,
            lines_available => 22,
            lines_stamp => 5,
            fh => $com3 });
    $u420->init_printer;
    for my $t (@tickets) {
        $u420->println(encode(big5 => $_)) for split(/\n/, $t);
        $u420->cut;
    }
    close $com3;

    open my $fh, '>:raw', 'rest.txt';
    print $fh join("\n.\n", @all);
    close $fh;
    sleep 105;
}

say "All done!";
