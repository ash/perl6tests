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
        'my' <variable>
    }

    token variable {
        | <array-sigil> <identifier> '[' <number> ']'
        | <sigil> <identifier>
    }

    token sigil {
        | <scalar-sigil>
        | <array-sigil>
    }

    token scalar-sigil {
        '$'
    }

    token array-sigil {
        '@'
    }
    
    token identifier {
        <alpha> <alnum>*
    }

    rule assignment {
        <variable> '=' <expression>
    }

    rule expression {
        | <term> '+' <expression>
        | <value>
        | <variable>
    }

    rule term {
        | <value>
        | <variable>
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

class A {
    has %!var;

    method TOP($/) {
        say %!var;
    }

    method mangled_name($/) {
        my $name;
        say "??"~$/;
        my $identifier = $<identifier> // $<variable><identifier> // $<term><variable><identifier>;
        say "<$identifier>";
        if $<array-sigil> || $<variable><array-sigil> {
            my $number = $<variable><number> ?? $<variable><number> !! 0;
            $name = '@' ~ $identifier ~ '.' ~ $number;
        }
        else {
            $name = '$' ~ $identifier;
        } 

        say "[$name]";
        return $name;
    }

    method variable-declaration($/) {
        %!var{self.mangled_name($/)} = 'undefined';
    }

    method variable($/) {
        $/.make(self.mangled_name($/));
    }

    method assignment($/) {        
        %!var{self.mangled_name($/)} = $<expression>.made;
    }

    method value($/) {
        $/.make(+$<number>);
    }

    method say-function($/) {        
        say %!var{self.mangled_name($/)};
    }

    multi method term($/ where $/<value>) {
        say "-->" ~ self.mangled_name($/);
        $/.make($<value>.ast);
    }

    multi method term($/ where $/<variable>) {
        $/.make($<variable>.ast);
    }

    multi method expression($/ where $/<term>) {
        say "EXPR TERM";
        say $/;
        $/.make($<term>.ast + $<expression>.ast);
    }

    multi method expression($/ where $/<value>) {
        $/.make(~$<value>);
    }

    multi method expression($/ where $/<variable>) {
        $/.make(%!var{self.mangled_name($/)});
    }
}

my $prog = q:to/END/;
my $x;
$x = 32;
my $y;
$y = $x + 1;

END


my $result = G.parse($prog, :actions(A.new));
#say $result;


# my $x;
# $x = 3;
# say $x;

# my @a;
# @a[0] = 4;
# say @a[0];