#  SCUMM BNF Grammar

## Program

<program> ::= <declaration>* <EOF>
<statement> ::= <command> | <function>

## Commands

<command> ::= <flowControl>

### Flow Control

<flowControl> := <case> | <do> | <for> | <if>

#### `case`

<case> ::= "case" <case-name> "{" <case-choices> "}"
<case-name> ::= <identifier>
<case-choices> ::= <case-choice>* <default-choice>

<case-choice> ::= "of" <value> "{" <statement>+ "}"
<default-choice> ::= "default" "{" <statement>+ "}" | "otherwise" "{" <statement>+ "}"

<value> ::= <number> | <identifier>

#### `do [until]`

<do> ::= "do" "{" <statement>+ "}" [ "until" "(" <condition> ")" ]
<condition> ::= <comparison-expression>

#### `for`

<for> ::= "for" <identifier> "=" <identifier> "to" <identifier> <step> "{" <statement>+ "}"
<step> ::= "++" | "--"

#### `if [else]`

<if> ::= "if" "(" <condition> ")" "{" <statement>+ "}" [ "else" "{" <statement>+ "}" ]


## Expressions

<expression> ::= <logic_or>

<logic_or>   ::= <logic_and> ( "or" <logic_and> )*
<logic_and>  ::= <equality> ( "and" <equality> )*
<equality>   ::= <comparison> ( ( "!=" | "==" ) <comparison> )*
<comparison> ::= <term> ( ( ">" | ">=" | "<" | "<=" ) <term> )*
<term>       ::= <factor> ( ( "-" | "+" ) <factor> )*
<factor>     ::= <unary> ( ( "/" | "*" ) <unary> )*
<unary>      ::= ( "!" | "-" ) <unary> | <primary>
<primary>    ::= "true" | "false" | <number> | <string> | <identifier> | "(" <expression> ")"

<comparison-expression> ::= <equality>

### Literals

<identifier>      ::= <letter> (<letter> | <digit>)*
<letter>          ::= [a-zA-Z]
<digit>           ::= [0-9]
<number>          ::= <digit>+
<string>          ::= "\"" <character>* "\""
<character>       ::= <letter> | <digit> | <symbol>
