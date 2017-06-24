# work on assignment
# no need to read smth from <number>. everything will be in <value> but stringify ~$<value>

my %var;

grammar G {
    rule TOP {
        ^ 
            [ <statement> \s* <comment>? ]*
        $       
    }

    rule statement {
        [
            | <variable-declaration>
            | <assignment>
            | <say-function>
        ]
        ';'
    }

    rule comment {
        '#' <-[\n]>*
    }

    rule variable-declaration {
        'my' <variable> {
            %var{$<variable><sigil>}{$<variable><identifier>} = 'undefined';
        }
    }

    token variable {
        <sigil> <identifier>
    }

    token sigil {
        '$' | '@'
    }
    
    token identifier {
        <alpha> <alnum>*
    }

    rule assignment {
        <variable> '=' <value> {
            say $<value>.WHAT;
            %var{$<variable><sigil>}{$<variable><identifier>} = ~$<value>;
        }
    }
    
    token value {
        <number>
    }

    token number {
        <digit>+
    }

    rule say-function {
        'say' <variable>
    }
}

my $prog = q:to/END/;
my $alpha;
$alpha = 50;
say $alpha;

my $beta;
$beta = 60;
say $beta;
END

my $result = G.parse($prog);
say $result;

say %var;
