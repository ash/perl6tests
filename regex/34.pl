my $str = q{<a href="index.html" class="menu">};
$str ~~ / \" (.*?) \" .* \" (.*?) \" /;
say $/;
