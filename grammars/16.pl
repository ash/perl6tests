# value + expression now
# $x = $y + 3


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
        <variable> '=' <expression> {
            %var{$<variable><sigil>}{$<variable><identifier>} = $<expression>.made;
        }
    }

    rule expression {
        | <value> '+' <expression> {$/.make($<value>.ast + $<expression>.ast)}
        | <value>    {$/.make(~$<value>)}
        | <variable> {$/.make(%var{$<variable><sigil>}{$<variable><identifier>})}
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

$x = 3;
$y = 4 + $x;
say $y; # 7

END


my $result = G.parse($prog);
say $result;

say %var;
