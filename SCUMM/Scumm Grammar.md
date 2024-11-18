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

## BNF

<statement> ::= <command> | <function>

<command> ::= <actorComm>
            | <cameraComm>
            | <flowControlComm>
            | <heapManagementComm>
            | <interfaceAndScreenComm>
            | <messageHandlingComm>
            | <objectRelatedComm>
            | <roomRelatedComm>
            | <scripRelatedtComm>
            | <soundMusicRelatedComm>
            | <waitRelatedComm>

<function> ::= <actorRelatedFunction>
             | <interfaceAndScreenFunction>
             | <objectRelatedFunction>
             | <scriptRelatedFunction>
             | <soundAndMusicFunction>

<actorComm> ::= <actor>                                     // actorOps ($13)
                <class-of>
                <come-out-door>
                <do-animation>                              // animateActor ($11)
                <put-actor>                                 // putActor ($01)
                <stop-actor>
                <wait-for-actor>                            // wait ($AE)
                <walk to>                                   // walkActorTo ($1E)
                                                            // walkActorToActor ($0D)
                                                            // walkActorToObject ($36)

<cameraComm> ::= <camera-at>                                // setCameraAt ($32)
                 <camera-follow>                            // actorFollowCamera ($52)
                 <camera-pan-to>                            // panCameraTo ($12)
                 <fades>                                    // roomOps ($33)
                 <wait-for-camera>                          // wait ($AE)

<flowControlComm> ::= <case>
                      <do [until]>               
                      <do-sentence>                         // doSentence ($19)
                      <for>
                      <if [else]>
                      <jump>                                // jumpRelative ($18)
                      <override>                            // override ($58)
                      <quit>                                // systemOps ($98)
                      <restart>                             // systemOps ($98)
                      <stop-sentence>
                      <wait-for-sentence>                   // wait ($AE)

<heapManagementComm> ::= <clear-heap>
                         <load->
                         <lock->
                         <load-lock->
                         <nuke-[costume]>
                         <unlock-[costume]>

<interfaceAndScreenComm> ::= <cursor>                       // cursorCommand ($2C)
                             <delete-verb>                  // saveRestoreVerbs ($AB)
                             <draw-box>                     // drawBox ($3F)
                             <palette>
                             <set-screen>                   // roomOps ($33)
                             <shake on/off>                 // roomOps ($33)
                             <userput>
                             <verb>                         // verbOps ($7A)

<messageHandlingComm> ::= <charset>
                          <print-line>                      // print ($14)
                          <print-text>                      // print ($14)
                          <say-line>
                          <wait-for-message>                // wait ($AE)

<objectRelatedComm> ::= <class-of>
                        <dependent-on>
                        <draw-object>                       // drawObject ($05)
                        <name is>
                        <new-name-of>                       // setObjectName ($54)
                        <owner-of>                          // setOwnerOf ($29)
                        <pick-up-object>                    // pickupObject ($25) (v5)
                        <start-object>                      // startObject ($37)
                        <state-of>                          // setState ($07)

<roomRelatedComm> ::= <current-room>
                      <lights [are] [beam-size]>            // lights ($70)
                      <pseudo-room>                         // pseudoRoom ($CC)
                      <room-color>                          // roomOps ($33)
                      <room-scroll>                         // roomOps ($33)
                      <set-box>

<scripRelatedComm> ::= <chain-script>                       // chainScript ($42)
                       <cut-scene>                          // cutScene ($40)
                       <freeze-scripts>                     // freezeScripts ($60)
                       <start-script>                       // startScript ($0A)
                       <stop-script>                        // stopScript ($62)
                       <unfreeze-scripts>
                       
<soundMusicRelatedComm> ::= <start-music>                   // startMusic ($02)
                            <start-sound>                   // startSound ($1C)
                            <stop-music>                    // stopMusic ($20)
                            <stop-sound>                    // stopSound ($3C)

<waitRelatedComm> ::= <break-here>                          // breakHere ($80)
                      <break-until>
                      <sleep-for>
                      
<actorRelatedFunction> ::= <actor-box>                      // getActorWalkBox ($7B)
                           <actor-costume>                  // getActorCostume ($71)
                           <actor-elevation>                // getActorElevation ($06)
                           <actor-facing>                   // getActorFacing ($63)
                           <actor-moving>                   // getActorMoving ($56)
                           <actor-room>                     // getActorRoom ($03)
                           <actor-width>                    // getActorWidth ($6C)
                           <actor-x>                        // getActorX ($43)
                           <actor-y>                        // getActorY ($23)
                           <closest-actor>
                           <find-actor>
                           <proximity>                      // getDist ($34)

<interfaceAndScreenFunction> ::= <find-inventory>           // findInventory ($3D)
                                 <inventory-size>           // getInventoryCount ($31)
                                 <valid-verb>

<objectRelatedFunction> ::= <if (class-of>                  // ifClassOfIs ($1D)
                            <if (state-of>                  // ifState ($0F) (V3-4)
                            <find-object>                   // findObject ($35)
                            <object-x>
                            <object-y>
                            <random>                        // getRandomNumber ($16)

<scriptRelatedFunction> ::= <script-running>                // getScriptRunning ($68)

<soundAndMusicFunction> ::= <sound-running>                 // isSoundRunning ($7C)

<actor> := "actor" <actor-name>

<actor-name> ::= <identifier>

<identifier> ::= <letter> (<letter> | <digit>)*

<letter> ::= [a-zA-Z]

<digit> ::= [0-9]

## Expressions

* expression ($AC)
* move ($1A)
* stringOps ($27)

### Arithmetic

* add ($5A)
* multiply ($1B)
* divide ($5B)
* decrement ($C6)
* increment ($46)
* subtract ($3A)

### Comparison

* isGreater ($78)
* isGreaterEqual ($04)
* isLess ($44)
* isNotEqual ($08)
* notEqualZero ($A8)

### Logic

* and ($17)
* or ($57)

### Jumps

* equalZero ($28)
* lessOrEqual ($38)

### Unknown

* actorSetClass ($5D)
* debug ($6B)
* delay ($2E)
* delayVariable ($2B)
* dummy ($A7)
* endCutScene ($C0)
* faceActor ($09)
* getActorScale ($3B)
* getAnimCounter ($22)
* getClosestObjActor ($66)
* getObjectOwner ($10)
* getObjectState ($0F)
* getStringWidth ($67)
* getVerbEntryPoint ($0B)
* isActorInBox ($1F)
* matrixOp ($30)
* printEgo ($D8)
* putActorAtObject ($0E)
* putActorInRoom ($2D)
* resourceRoutines ($0C)
* loadRoom ($72)
* loadRoomWithEgo ($24)
* roomOps ($33)
* setVarRange ($26)
* soundKludge ($4C)
* stopObjectCode ($A0 or $00)
* stopObjectScript ($6E)

## Core Features

### The if command

There are two forms of the if statement. One with else and one without. These are pretty self-explanatory to anyone who knows any other structured language. There are restrictions in that complex conditions using OR or AND can not yet be constructed.

Syntax:

```
if (exp16 = val16) {
    [statements]
}
```

or

```
if (exp16 = val16) {
    [statements]
} else {
    [statements]
}
```

Example:

```
if (class-of window is LOCKED) {
    say-line "It's latched from the other side."
}

if (class-of me is UNLOCKED) {
    say-line "It looks like a first edition."
} else {
    say-line "It's inscribed, `To a special fan\
    Yours, Adolph`."
}
```
Use the if-else argument within the open verb so that if the door is already open the actor will say a line to that effect. Otherwise the door will be opened.

### do

local variable s,j,x
var-55 = 2010
var-625 = (var-625 + 1)
number-actors = 25
min-jiffies = 4
override-key = 4
local variable ok-to-bail-out
variable time-to-nuke-largo
   variable looked-at-money
   variable out-of-money-lines

define woodtick-theme       = 0
define bar-theme            = 1
define cartographers-theme  = 2
define inn-theme            = 3
define laundry-theme        = 4
define woodshop-theme       = 5

; For men of low moral fibre (laundry-theme)
define accordion-part       = 3
define kick-snare-part      = 9
define horn-part            = 1

; For wally kidnapping
variable wally-snatched     = false
variable know-wally-is-gone = false
counter = 0

variable selected-actor       @ 1




Room local variables
SCUMM (obviously) had support for global variables from the start. The first 50-100 (circa) of these were system variables declared and understood by the compiler and engine - for things like the selected actor, the soundcard, the machine speed, the cursor position, etc. The rest were game specific and declared in SCUMM scripts.
 
Mostly each of these variables had a specific relatively local purpose and were named as such - e.g. something like visited-iceland. A few, however, were reused for all kinds of purposes across scripts - this helped reduce the amount of memory allocated for global variables. The first couple of these - which were already there in Maniac Mansion - were named foo and bar (the latter was renamed around MI1 for possibly obvious reasons - hint: MI1 and MI2 both have a room named bar 😉).
 
Global variables could be integer numbers or arrays (or bits or strings - which had their own dedicated space. In SCUMM 6 - from DOTT - nibble, byte, and word variables were also added).
 
When scripts local to a room were added for Last Crusade, local variables - local to the scripts - were also introduced.
 
However, sometimes (quite often) you need variables that can be shared between all the scripts in a single room, but are still local to that room. Unlike script-local variables, this wasn't implemented as a compiler and engine feature, but rather, was implemented by a bit of (ab)use of functionality provided by the two:
 
Global variables were declared in a dedicated SCUMM script, defining the name of each variable, and the "slot" (just a relative pointer to its location in memory). Using one of two syntaxes:

variable selected-actor       @ 1

Which would declare that the variable selected-actor would be in slot 1. (This was the typical way the system variables were declared in the script).

start-variables 100
variable foo
variable bar
variable some-array[10]
variable visited-iceland

Which would place foo in slot 100, bar in slot 101 etc. some-array would simply take up the next 10 slots, 102-111, with visited-iceland being in slot 112.
 
So, in order to add "room local variables", you'd do this:
Add an array to your global variables, named, say, room-local, with, say, 14 items (this was the typical number)
At the top of each room needing room local variables, simply use the above syntax:

start-variables room-local

variable time-to-nuke-largo
variable looked-at-money
variable out-of-money-lines

... which would place time-to-nuke-largo at the same slot as room-local - in other words, it would be at the same location in memory as room-local[0]. In a different room, you could then have another set of variables, pointing to the same array.

This is exactly what can be seen in the woodtick script (and similarly in the new-york-street script). So, you could have up to 14 variables that were specific to a room, but only took up 14 variable slots of memory across the game.
 
To make it a bit cleaner, another feature was used: Every room in SCUMM can have an enter and exit script, which defines a script to be executed when you enter/exit that room. However, there was also two global enter scripts - and two global exit scripts - assigned during the boot script. Which would be run respectively before and after the individual room's enter/exit scripts - for every room. In one of these, you could place a for loop, which would iterate over the room-local array and set each item to 0. That way, whenever the player entered a new room, the room local variables would start out with a clean, default, 0 value.


   local variable i

   min-jiffies = 6
   override-key is key-escape
   restart-key is key-f8
   pause-key is key-space
   number-actors = 12
   charset 0
   selected-actor is indy
   *version = "IBM 256 color 2.0 5/3/90"
   *pause-string = "Game Paused.  Press SPACEBAR to Continue."
   *insert-string = "Insert Disk %%c and Press ENTER to Continue."
   *unable-string = "Unable to Find %%02d.LFL (%%c%%d), Press ENTER to Continue."
   *diskerror-string = "ERROR: Insert Disk %%c, Press ENTER to Continue."
   *restart-string = "Are you sure you want to restart?  (Y/N)Y"
   *demo-mode-string = "Demo mode, Save/Load disabled."
   *iq-points = "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
   var-243 = 1


