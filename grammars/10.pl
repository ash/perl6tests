# update variable-declaration and assign %scalar/%array

# try making separate paths: 
    # token variable {
    #     | <scalar-variable>
    #     | <array-variable>
    # }

    # token scalar-variable {
    #     '$' <identifier>
    # }

    # token scalar-variable {
    #     '$' <identifier>
    # }

# but instead make %var hash two-level

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
        <variable> '=' <value>
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
my $x;
my @array;
$x = 100;
say $x;
END

my $result = G.parse($prog);
say $result;

say %var;
