my $sub = sub ($x) {$x * 2};
my $block = -> $x {$x * 2};
say $sub.^name;
say $block.^name;
