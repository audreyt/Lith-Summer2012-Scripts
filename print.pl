#!/usr/bin/env perl
use utf8;
use DateTime;
use Business::TW::Invoice::U420;
use Encode 'encode';
binmode STDIN, ':utf8';
my @tickets = split /\n\.\n/, join '', <>;
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
