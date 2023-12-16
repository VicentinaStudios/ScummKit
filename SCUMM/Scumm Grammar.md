#  SCUMM Grammar

## Syntax Grammer

<script> ::= <declaration>* EOF

### Declarations

declaration ::=


## Tokens

This is just an insight about some of the available Tokens:

```
enum TokenType: CaseIterable {
    
    case lparen, rparen, lbrace, rbrace,lbracket, rbracket
    case comma, colon, semicolon, exclamation
    case plus, minus, slash, star
    case hash, backslash, caret, apostrophe,backtick, at
    
    case equal, equalEqual, bangEqual
    case less, lessEqual, greater, greaterEqual
    case plusEqual, minusEqual
    case plusPlus, minusMinus
    
    case identifier, string, number
    case label
    
    case include
    case `if`, `else`, `is`
    
    case eof
}
```
