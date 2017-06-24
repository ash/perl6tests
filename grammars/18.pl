# $z = $x + $y



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
        <sigil> <identifier> {
            $/.make(%var{$<sigil>}{$<identifier>})
        }
    }

    token sigil {
        '$' | '@'
    }
    
    token identifier {
        <alpha> <alnum>*
    }

    rule assignment {
        <variable> '=' <expression> {            
            %var{$<variable><sigil>}{$<variable><identifier>} = $<expression>.made;
        }
    }

    rule expression {
        | <term> '+' <expression> {$/.make($<term>.ast + $<expression>.ast)}
        | <value>    {$/.make(~$<value>)}
        | <variable> {$/.make(%var{$<variable><sigil>}{$<variable><identifier>})}
    }

    rule term {
        | <value> {$/.make($<value>.ast)}
        | <variable> {$/.make($<variable>.ast)}
    }
    
    token value {
        <number> {$/.make(+$<number>)}
    }

    token number {
        <digit>+
    }

    rule say-function {
        'say' <variable> {
            say %var{$<variable><sigil>}{$<variable><identifier>};
        }
    }
}

my $prog = q:to/END/;
my $x;
my $y;
my $z;

$x = 1;
$y = 2;

$z = $x + $y;
say $z;

END


my $result = G.parse($prog);
#say $result;

say %var;
