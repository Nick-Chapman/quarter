.." Loading numbers ( " latest

( Make the numbers we need )

1 1 +
constant 2

2 1 + dup * 1 +
constant 10

2 dup * dup *
constant 16

16 dup *
constant 256


( Behaviour of . and number? is modal  )

variable hex-mode

: hex       true  hex-mode ! ;
: decimal   false hex-mode ! ;


( Parse an unsigned hex or decimal number )

: decimal-digit? ( c -- flag ) dup [char] 0 >= swap [char] 9 <= and ;

: extended-digit? ( c -- flag ) dup [char] a >= swap [char] f <= and ;

: hex-digit? ( c -- flag )
dup decimal-digit? swap extended-digit? or ;

: digit? ( c -- flag )
hex-mode @ if hex-digit? else decimal-digit? then ;

: convert-digit
dup extended-digit?
if [char] a - 10 +
else [char] 0 -
then
;

: base ( -- n )
hex-mode @ if 16 else 10 then ;


: number-loop ( acc str -- u 1 | 0 )
dup c@ dup 0 = if 2drop ( acc ) 1 exit
then ( acc str c ) dup digit? ( acc str c flag )
dup 0 = if 2drop 2drop 0 exit
then drop convert-digit rot base * + swap char+ ( acc' str' )
tail number-loop
;

: number? ( str -- u 1 | 0 )
dup 0 swap number-loop ( s u 1 | s 0 )
dup if rot drop
then
;

( Print as unsigned decimal )

: print-digit ( 0-9 -- )
[char] 0 + emit
;

: dot-loop ( u -- )
dup 0= if drop exit ( stop; don't print leading zeros ) then
10 /mod ( u%10 u/10 -- ) dot-loop print-digit
;

: .decimal ( n -- ) ( output a value in decimal )
dup 0= if print-digit exit then ( special case for single "0" )
dot-loop
;

: .hex1 ( nibble -- ) ( output nibble as a length-1 hex string )
dup 10 < if print-digit exit then 10 - [char] a + emit ;

: .hex2 ( byte -- ) ( output byte as a length-2 hex string )
16 /mod .hex1 .hex1 ;

: .hex4 ( n -- ) ( output 16-bit cell-value as a length-4 hex string )
256 /mod .hex2 .hex2 ;

: .hex ( n -- ) ( output a value in hex )
.hex4 ;



: . ( u -- ) ( output value in hex/decimal, with trailing space )
hex-mode @ if .hex else .decimal then space ;

: ? ( addr -- ) @ . ;

hide .hex1
hide 10
hide 16
hide 2
hide 256
hide base
hide convert-digit
hide decimal-digit?
hide digit?
hide dot-loop
hide extended-digit?
hide hex-digit?
hide hex-mode
hide number-loop
hide print-digit
words-since char ) emit cr
