grammar G {
    rule TOP {
        ^ 
            (.*? ';')*
        $
    }
}

my $result = G.parsefile('refer.pl');
say $result;
