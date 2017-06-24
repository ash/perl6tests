# Using AST attributes

# use var in assignment (right side)
# my $x = $y;
# $/.make - $/.ast/made
# notice with ~$<value>


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
        | <value>    {$/.make(~$<value>)}
        | <variable> {$/.make(%var{$<variable><sigil>}{$<variable><identifier>})}
    }
    
    token value {
        <number>
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
$x = 100;

my $y;
$y = $x;
say $y;
END

my $result = G.parse($prog);
say $result;

say %var;
