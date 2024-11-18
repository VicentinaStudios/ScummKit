# 3. Statements

## 3.1 Actor Related

### 3.1.1 actor

The actor statement is used to initialize and change the facets of an actor. It is used when initially defining an actor and whenever an update is needed. The statement can be multiple lines if the situation warrants.

Syntax:

```
actor actor-name [costume costume-name]
                 [sound sound-effect]
                 [color color-name is color-name]
                 [talk-color color]
                 [elevation number]
                 [walk-animation choreography]
                 [stand-animation choreography]
                 [talk-animation choreography,choreography]
                 [init-animation choreography]
                 [step-dist x-coord,y-coord]
                 [name string]
                 [width number]
                 [default]
                 [scale number]
```

Example:
```
actor bobbin costume bobbin-swim
actor indy sound splat
actor donovan color light-green is black
actor brody talk-color light-grey
actor bobbin elevation 0
actor bobbin walk-animation swimming
actor bobbin stand-animation treading
actor bobbin talk-animation start-talking, stop-talking
actor bobbin init-animation treading
actor indy name "Indy"
actor indy width 16
actor indy scale 50 step-dist 16,12
```

Here are the individual components of the actor statement. When initializing an actor, you should use at least costume, name, and talk-color.

`costume`
Sets the current costume for the actor. The costume change, if any, occurs in the next frame.

`sound`
This is the sound that an actor can make during an animation sequence. Usually this would be the sound an actor makes when it walks, but it could be the sound of a german shepherd chewing or a shovel hitting the dirt. When the artist draws and choreographs the actor there is a special little code that is dropped into the choreography, and at the appropriate time it will trigger the sound effect which is defined with actor sound.

`color`
This component of the command substitutes one color for another within the actor's costume. For example, yellow is green would change everything usually drawn in yellow to green. This is appropriate for different video cards and for reuse of a costume such as the Nazi's hair and uniform in Indy 3.

`talk-color`
Talk-color is the color of the character's words, text, or speech when you see it on the screen. It is recommended that you use one of the 16 EGA palette colors for talk-color. Even with the upgrade of the system to 256 colors, still use the one of the 16 EGA colors. This will prevent extra work when producing a EGA version.

`elevation`
Actors automatically clip behind each other based on their vertical "y", position. This command can be used, to change the elevation of an actor, without changing its "y" co-ordinate. The automatic clipping will still use the base "y" position for its calculations. This can also be used to raise or lower an actor without worrying about walk boxes. The animation of the ladder in the Zepplin Hall of Indy 3 is such a situation.

`walk-animation`
When the actor walks, the animation listed within choreograph 2 is activated. Using this command allows you to use animation from a different choreography. This would be appropriate if the character developed a limp for example. The default location for the walk-animation is choreography 2 (see discussion of byle). Remember to use choreography names rather than numbers for code clarity.

`stand-animation`
The default location for the stand-animation is choreography 3 (see discussion of
byle). When the actor is standing, the animation listed within choreography 3 is
activated. Using this command allows you to use animation from a different
choreography. Remember to use choreography names rather than numbers for
code clarity.

`talk-animation`
Talk-animation has two parameters. The first is for start-talking and the second is for stopping that talking. The default location for the talk-animation is choreography 4 (see discussion of byle). When the actor is talking, the animation within choreography 4 is activated. When the lines go away, choreography 5 is used. This is usually a closed mouth cell. Using the talk-animation command allows you to use animations from different choreography cells. Remember to use choreography names rather than numbers for code clarity.

`init-animation`
The default location for the init-animation is choreography 1 (see discussion of byle). When an actor is put into a room using put-actor, the init-animation is activated. A costume change will also initiate init-animation. This command allows you to use animation from a different choreography instead of choreography 1. Remember to use choreography names rather than numbers for code clarity.

`step-dist`
Step-dist takes two parameters, x and y, which tell how many pixels the actor should be moved, with each step, when walking. The x controls walk steps left and right and y controls walk steps front and back. Step-dist is tied to the actor's scale.

`name`
Name sets the name that is seen on the screen, when the cursor touches the character (see .i.class-of:see also; GIVEABLE and TOUCHABLE.)

`width`
The actor's on-screen width in pixels. Defaults to 16. Very rarely will you use this, for actors of normal proportion The exception is very large actors (Biff in Indy 3) and wide actors (German Shepherd in Indy 3) Width is mainly used by the system for calculating in such scripts as follow-actor, where the size of the actor width is important. It has nothing to do with when the cursor is on the actor.

`scale`
The actor's scale can be set anywhere from 0 to 255. The 255 factor is the normal size of the actor. When scale is set to 0 (invisible), the step-dist is automatically 0. The actor will not move but the system thinks it is trying to move. If invisibility is called for, use an "invisible" costume, not 0 scale. Although the actor's step-dist works in conjunction with scale, it may be appropriate to change the step-dist if you change the scale, because the scaling perspective sometimes looks off.

`default`
Sets the actor command back to the system defaults. These are:

```
talk-color white
elevation 0
walk-animation 2
stand-animation 3
talk-animation 4, 5
init-animation 1
scale 255
step-dist 8,2
width 16
```

Here are examples of actual scumm system code. From these you can see the many different lengths and make-ups that the actor statement can take.

Examples:

```
actor bobbin    costume bobbin-swim elevation 0 step-dist 4,2\
                                    init-animation treading walk-animation swimming\
                                    stand-animation treading

actor indy      costume wet-indy-skin sound splat\
                                    talk-color yellow width 16 name "Indy"

actor brody     costume clip-board-brody sound footstep\
                                    talk-color light-grey width 16 name "Marcus"

actor elsa      costume elsa-skin sound footstep\
                                    talk-color light-cyan step-dist 8,2 width 16\
                                    name "Elsa"

actor bishop    color yellow is white

actor donovan   costume donovan-skin\
                                    step-dist 8,2\
                                    width 16 \
                                    talk-color light-blue\
                                    color light-blue is blue\
                                    color light-green is black\
                                    color yellow is white\
                                    color light-purple is black\
                                    name "Donovan"
                                    
actor sea-monk  elevation -108
```

Things to remember:
* Presently within the system there is no way to check what the current scale or name (string) are.
* It is possible to use define or variable names in place of any of the actor components.
    
    Examples:
    ```
    actor cauldron-actor elevation cauldron-elev
    actor selected-actor costume guy-qtip
    ```

### 3.1.1 class-of

As of Mar 21 1991, the specific statement class-of, has been removed and incorporated into the actor statement.

Both objects and actors have classes associated with them. Actor classes are involved with clipping and box information.

Syntax:
```
class-of actor-name is actor-class [actor-class...]
```

Example:
```
class-of troll is IGNORE-BOXES-ON ALWAYS-CLIP-ON
```

There are 3 classes which have an on and off state.


`always-clip-on|off.i.class-of:actor related:always-clip-on|off;`
Setting an actor's class to `always-clip-on` will make an actor always clip, no matter what box it is in, and no matter where it is. If there is a z plane the actor will clip behind it. Even if the box says don't z clip the actor will do so anyway. `always-clip-off` just turns that off.

`never-clip-on|off.i.class-of:actor related:never-clip-on|off;`
Setting an actor's class to `never-clip-on` will make an actor, no matter what the actor is doing, never clip behind anything. There is an off for this as well. A good example of this would be a bird, that is going to fly across the screen. You would not wish the bird to clip behind objects, because it is going to be floating in the air.

`ignore-boxes-on|off.i.class-of:actor related:ignore-boxes-on|off;`
Setting an actor's class to `ignore-boxes-off` will cause the actor to not pay attention to any boxes in the room. Instructing the actor to walk to an x,y coordwill cause the actor to head directly to that point. This is useful for actor's such as birds and again there is an off for this as well.

Things to remember:

* Setting an actor's class to `always-clip-off` and `never-clip-off` will cause the actor to react, based on the boxes default status. However, if one of the classes is set to on, then it will override the boxes default. If both classes are set to on there is no guarantee what is going to happen. Probably the system will do one of them, with the likelihood that it will be the last one that the system checked.
* Whenever you set `ignore-boxes-on` it is advisable to set one of the clipping classes. The system does not know what to do with the actor, because it is not in a box. Therefore the actor is going to randomly clip based on what it was doing last. Usually, when you say `ignore-boxes-on` you will say `never-clip-on` as well.

### 3.1.3 come-out-door

This is used for room changes. An actor walks through a door (an object) in one room and comes out of a door(an object) in another room. The actor will be placed at the object's use-position.i.Use position:see also; facing the opposite direction. Come-out-door is equivalent to put-actor at-object,.i.put-actor [at-object] [at x-coord, y-coord] [in-room]:see also; usually into a new room, followed by a .i.camera-follow:see also; .i.selected-actor:see also;. The statement must be the last statement in an object, or local script as this launches the room exit code. Any other code within the object, or local script will not be implemented. Adding a walk statement to the same line is also possible. This is used to bring the actor further into the scene on a room transition.

Syntax:
```
come-out-door object-name in-room room-name
come-out-door object-name in-room room-name\
                                        [walk x-coord,y-coord]
```

Example:
```
come-out-door col-hall-outside-door in-room col-hall
come-out-door ghost-ship3 in-room hellcliff walk 114,111
```

Things to remember:
* Come-out-door updates the inventory and runs the appropriate exit and enter code.
* Remember not to use this in a local .i.cut-scene:see also;. The main reason is that a come-out-door changes the .i.current-room:see also;. This runs the exit code for the room you're in, and the enter code for the room you're entering. If you use a come-out-door within a local cut-scene, the script is killed when you exit the room, but the cut-scene status is unchanged. The .i.cursor:see also; will still be set to soft-off, the .i.userput:see also ;is still soft-off and the cut-scene state is 1. The cut-scene will never end. This will generate an error message saying an active cut-scene has stopped.
* Look at room-scroll (3.8.5) for an example of a problem with a negative position of a door.

## 3.3 Flow Control

### case

The case construct is provided to make code more readable. It is actually
converted to a series of if statements by Scumm. The case statement must have
at least one "of" <value> statement.

Default and otherwise are the same. Either one can be placed as the last choice
in the case statement and will be used if all the other options are negative.

Syntax:
```
case case-name {
    of number {
        [statements]
    }
    [of number {
        [statements]
    }]
    [default|otherwise {
        [statements]
    }]
}
```

Example:
```
case word-message {
    of 0 {
        say-line "In Olde English"
    }
    of 1 {
        say-line "In Latin"
    }
    of 2 {
        say-line "In Etaskrit"
    }
    of 3 {
        say-line "In Porcinum-Atinlay"
    }
    of 4 {
        say-line "In Tuskin"
    }
    of 5 {
        say-line "In Vaachi"
    }
}
```

Here is an example of the use of "default" within the case statement. This is taken from line 429 of Indy 3 - fighting.scu.

Example:
```
case indy-action {
    of block-high {
        if (punch-angle) {
            punch-angle = punch-low
        } else {
            punch-angle = punch-med
        }
    }
    of block-med {
        if (punch-angle) {
            punch-angle = punch-low
        } else {
            punch-angle = punch-high
        }
    }
    of block-low {
        if (punch-angle) {
            punch-angle = punch-high
        } else {
            punch-angle = punch-med
        }
    }
    default {
        punch-angle = punch-high
    }
}
```

Things to remember:
    
* If you are using a "compile if|endif" (example: #if MAC) statement within a case statement then it cannot be placed between the case and of portion of the code. Similarly the #endif to terminate is also placed within the "of" structure.

```
case (case-name) {
    of (# choice) {
        ; compile if (#if) goes here.
        ; compile endif (#endif) goes here
    }
}
```

* It is also possible to do nested compile if's.

### `do [until]`

The do construct is used to repeat a section of code. It will repeat indefinitely until the script it is in is stopped, either by a .i.stop-script:see also; or, if it is in a local script, by a room transition.

The do until command is used to repeat a section of code until a condition is satisfied.

Syntax:
```
do {
    [statements]
}

do {
    [statements]
} until condition met
```

Example:
```
do {
    for i = start-frame to end-frame ++ {
        draw-object i
        break-here
    }
}

do {
    [statements]
} until (proximity indy henry <= 26)
```

Here is a good example of a constantly running do loop.

Example:
```
do {
    sleep-for 1 second
    if (nazi-energy < nazi-health) {
        nazi-energy += nazi-recovery-rate
    }
    if (nazi-energy > nazi-health) {
        nazi-energy = nazi-health
    }
    if (indy-energy < indy-health) {
        indy-energy += indy-recovery-rate
    }
    if (indy-energy > indy-health) {
        indy-energy = indy-health
    }
    start-script print-energy
}
```

Things to remember:

* The following symbols and expressions are available =, !=, <, >, <=, >=, ==, is, are, and is-not.
* There should be an interrupt, .i(.break-here:see also;, .i.sleep-for:see also;, or .i.wait-for:see also;, somewhere inside the bracketed code or the computer will lock up

This is correct:
```
do {
    draw-object which-lights
    sleep-for delay jiffies
    state-of which-lights is R-GONE
    sleep-for delay jiffies
}
```

This would cause a lock-up:
```
do {
    draw-object which-lights
    state-of which-lights is R-GONE
}
```

Things to remember continued:

* An exception to the above is if you intentionally want to wait until a
condition is met and you are sure this will happen soon. Here is an example of an
exception from line 28 of Indy 3 - bookburn.scu.

```
script fire-glow {
    do {
        local variable glow, rnd, last-rnd
        do {
            rnd = random 2
        } until (rnd is-not last-rnd)
        last-rnd = rnd
        case rnd {
            of 0 {
                glow = red
            }
            of 1 {
                glow = light-red
            }
            of 2 {
                glow = yellow
            }
        }
        palette glow in-slot light-purple
        break-here
    }
}
```

Note that while the do loop has a .i).break-here:see also; within it, the do until loop within the do loop does not. This can be done as long as the time spent within the do until loop is limited.

* Do until loops can be embedded within other do until loops or within a do loop.

```
do {
    do {
    } until
    [statements]
} until

do {
    do {
    } until
    [statements]
}
```

### `for`

This command is similar to for loops in other languages. The first variable (var-1) is initialized with the second variable (var-2). The system continues through the loop and on each pass, variable one is incremented (++) or decremented (--) until it equals the third variable (var-3), at which point it cancels the loop.

Syntax:
```
for var-1 = var-2 to var-3 ++ | -- {
    [statements]
}
```

Example:
```
for foo = dialog-1 to dialog-9 ++ {
    verb foo off
}
```

Nested for loops are permitted in Scumm. The following example is taken from Bar.scu in Monkey 1.

```
for k = 0 to 1 ++ {
    for j = 0 to 2 ++ {
        obj = ((spin-guy-1 + j) + (k * 3))
        draw-object obj
        obj = (chain-1 + j)
        draw-object obj
        break-here
    }
}
```

Things to remember:

* There must be a space between the step increment (++, --) and the following brace.

This is correct:
```
for k = 0 to 1 ++ {
```

This is incorrect:
```
for k = 0 to 1 ++{
```

### `if [else]`

This is pretty self-explanatory to anyone who knows any other structured
language. Complex conditions using OR or AND can not yet be constructed. The
condition within the parenthesis can be a single parameter such as "if (met-
sheriff) etc or a more involved condition such as the examples below.

Syntax:
```
if condition met {
    [statements]
}
if condition met {
    [statements]
} else {
    [statements]
}
```

Example:
```
if (to-whom is bill) {
    jump give-to-bro
}
if (sank-my-own-ship) {
    walk selected-actor to 87,98
    wait-for-actor selected-actor
    start-script cliff-hermit-dialog
} else {
    walk selected-actor to 124,98
    wait-for-actor selected-actor
    start-script cliff-crew-dialog
}
```

The if condition can take many different forms.

```
if (not second-time-on-melee) {
if (noun2 is root-beer) {
if (where-am-i < 320) {
if (actor-x cook > 310) {
if (button == 2) {
```

Things to remember:

* Nested if statements are allowable.

```
if (item >= '0') {
    if (item <= '9') {
        return-value is (item - '0')
    }
}
```
