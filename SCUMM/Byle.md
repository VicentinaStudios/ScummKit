#  Byle

## Introduction

Byle is a versatile and powerful graphics tool that creates the actor animation for our Scumm Adventure Games. The Chapter is organized so you can use it as a guide or a reference handbook.

As with all the Scumm system tools, the animation editor is named after a disgusting bodily fluid. In this case Byle.

Byle allows the artist to prepare all the animation sequences used in a Scumm game, from the simplest walk animation, to a complex shot such as a character being fired out of a canon.

The basic component of byle is the cel. Everything that happens in byle revolves around this concept, usually by stringing these cels together to form a choreography.

### Cel Definition

A cel is a single image or object within an entire sequence or animation that is intrinsically related to the image that comes before it and the one that follows to create a flow of movement.

### Choreography Definition

A choreography is an action (walk, talk, reach etc) performed by an actor. This is formed by stringing cels together.

### Choreography, Cel Interaction

Now we could spend a whole week describing the way these interact. In its simplest form there is a choreography, (a more descriptive term is animation sequence), that an actor can perform. The artist will set up this animation sequence by placing cels of the actor in the Choreography Cel list.

For example, in a Scumm game,the act of walking by an actor is a choreography which is just repetitive. So when the system says walk it starts doing the walk choreography.

### Choreography Directions

Actors in Scumm games can walk in any direction and therefore the walk choreography must contain four different representations of the actor's walking animation sequence. Not unreasonably these directions are front, back, left and right.

Other choreographies will have anywhere from 1 to 4 of these directions depending on their use in the game.

The choreographies can be fairly involved and complicated such as a guy exploding and his head blowing off.

### Level Definition (formerly known as limbs!)

Byle has 16 different levels (or limbs) for cels. These levels are identified as A
through P. The different levels allow an artist to superimpose one image over the
top of another. Each subsequent level has a higher priority over the previous
level. Most of the time you will only use the first couple of levels.

For those of you familiar with the technique, levels could also be described as
like the different separations in a 4 color separation.

## The Interface: An Overview

The byle screen is similar in many ways to dpaint. The menu bar, tool box, color indicator and palette have all been retained in a similar fashion. The major changes from dpaint are the cels table, choreography cel list table, the lower screen buttons and the divided painting area.

### Menu Bar

Byle has numerous features and functions that are available through a series of pull-down menus in the Menu Bar at the top of the screen. The menu bar is divided into 6 options.

The File option contains the following choices:
Load costume, save costume, save costume as, make costume, load (not implemented), load lbm palette, load lbm backdrop, write chores.def and quit. Section 10.5.1 looks at these in more depth.

The Edit option contains the following choices:
Copy level (not implemented), copy cel, copy chore, copy list and paste. Section 10.5.2 looks at these in more depth.

The Brush option contains the following choices:
Flip x, flip y, normal scale (not implemented), half scale (not implemented), scale up (not implemented), scale down (not implemented), set scale (not implemented), replace (not implemented), and color (not implemented). Section 10.5.3 looks at these in more depth.

The Chores option contains the following choices:
Make a chore, next set of chores (which include the untitled choreographies 16 through 30), the standard first 6 choreograhies (Null, Init, Walk, Stand, Talk, Stop Talking) and the untitled choreographies 6 through 15. Section 10.5.4 looks at these in more depth.

The Special option contains the following choices:
Insert (which contains the selections Cel, Sound, Empty and Flip), Palette, No flip on left, Verbose Output (part of Brad's debugging, ignore), Debug Cel States (also part of Brad's debugging, ignore), Remove unused cels (not implemented) and Onion Skin (not implemented). Section 10.5.5 looks at these in more depth.

The Backdrop option contains the following choices:
Load lbm backdrop, show backdrop, save lbm backdrop and load wak file. Section 10.5.6 looks at these in more depth.

### Toolbox

The dpaint Toolbox has been modified to add more useful tools and delete tools that are not needed. When you start Byle the Freehand Brush tool is active by default. We will get to examine each of the components in section 10.6.

### Palette and Color Indicator

The Palette contains the colors representing your current color spectrum. Directly above the Palette is the Color Indicator. The two rectangles display the colors that you are currently using to paint. The inner rectangle shows the brush color, while the outer rectangle shows the current background color. Unlike dpaint's defaults of black and white, byle's defaults are black and blue. Section 10.6.22 looks at these in more depth.

### The cel table

The cel table contains 16 levels labelled A to P which are accessible using the scroll bar on the left (see fig XXX). Each level has 64 available cels (numbered 00 to 63). Section 10.3 looks at these in more depth.

### The choreography cel list table

The choreography cel list table is similar to the cel table in that it has 16 levels available. These are also numbered A to P. However the choreography cel list table has only space for 32 cel placements. Section 10.3 looks at these in more depth.

### Painting Area/Animation Area

In byle, the screen is divided into two sections. The left screen is the painting area and the right screen is the animation area. It is possible to place backdrops in the right area, for example, to check that an animation flows correctly.

### Lower Screen Buttons.

The lower screen buttons are chore, chore name, animation start/stop, animation cel by cel, xrel, yrel, directional and cel addition. Section 10.5 looks at these in more depth.

Lastly, just as in dpaint, when a menu option has a Ë symbol to the right, it means that the option has a sub menu.

## File requestor window

The file requestor window (see fig XXX) is activated by the load costume, save costume as, load lbm palette, load lbm backdrop, save lbm backdrop and load .wak file choices.

The File and Directories window
The File and Directories window displays (not surprisingly) the directories and files that are in the current directory.

To open a directory or load a file you must click on the file or directory name and then click on the load button. It is possible to open these by double clicking on the file or directory name, but that is a little temperamental.

Once you have clicked on a directory or file in the Files and Directories window, that file or directory name will appear in the edit button box. If a directory is opened then the path is displayed in the current directory window.

Load Button
The load button is case sensitive. The button will either load a file or open a directory depending on what type of item is activated.

Cancel Button
The cancel button closes the file requestor window.

Current Drive Button
The current drive button allows you to switch drives by left clicking on the button and moving down to the drive you want. Activating another drive will generate a new set of files and directories in the File and Directories window

Current Directory Window
The current directory window shows the current directory path (for example c:\scummu\costumes). If a directory is opened then the path is displayed in the current directory window.

Edit Button Box
The edit button box (for want of a better name!) displays the current file or directory highlighted in the Files and Directories Window. It also can be used to edit a file or directory name for the saving of a new file or copy.

While in the file requestor window, hitting a letter on the keyboard will scroll you through the files with that letter as the first letter in the file name. If no file exists then the system assumes you wish to be in the edit button box.

## The Cel Table and Choreography Cel list Table

Section 10.7, will go through a costume in depth, but here is a brief look at the cel/choreography/cel list relation.

Cels
In figure 1 you will see where the cel section of byle is contained. As noted earlier, there are 16 levels or limbs for the cels. These run from A to P. As a convienence we cross reference the levels and cel numbers. Therefore the first cel in the 4th level would be D/00. Rarely will more than a couple of levels of cels be used.

Generally all the actors standard movement is drawn in the A level of cels. This would be the different cels that go to form walking for example. The other levels are used for cel drawings of reaching, talking and further special case animation.

Probably the easiest way to understand the relationship of the cel list table and cel choreography cel list table is to regard the cel list table as your cel palette.

Just as you can choose colors in a palette to use for painting, you use the cels in the cel list table to produce your animations in the cel choreography cel list table. Similarly with a palette, a cel may be used in more than one choreography.

Choreography
Again as noted earlier a choreography is a group of cels. That choreography must contain the cels for all four directions (front, back, left and right).

So with a Choreography of Walk you must set up a string (or list) of cels for Walk/back Walk/front Walk/left and Walk/right

For arguments sake let us assume that level A cel 00 through 03 were the walking front animation cels, 04 through 07 was the walking cels, etc. Then the artist would set up the choreography by activating the front button and then inserting the cels 00 through 03 on the level A of the choreography cel list table.

Setting up some simple cels
Let's now do that. Go to the choreography name button and click using the left mouse button on the button. Hold down the mouse button and move up to the 02 Walk choreography. Once that is highlighted then release the mouse button. The choreography button will change to say 02 Walk.

Activate the filled rectangle brush by clicking on it with the left mouse button. Next click on first cel in the A level, where the light grey 00 is located. Select a color from the palette by left clicking on any color that appeals and then go to the left hand display window and draw a rectangle of that color.

Next left click on the next blank cel to the right of the 00 cel and a 01 should appear and the rectangle that you just drew should disappear from the left hand display window. Select another color in the palette and draw a rectangle of that color, again in the left hand window display.

Repeat this process for cells 02 through 11. (Use the scroll bar to move over as needed) Each time pick a new color. Only use the left button to click on the cels.

Setting up a simple choreography
Now lets set up an animation sequence. Make sure that the directional button "front" is the active button. If not, then left click on that button first. Left Click on the A/00 cel (Level A, cel 00) in the cel table. Now left click on the first space in the choreography/cel listing area. You should see the 00 cel appear in that space.

You now need to add cels 01 and 02 to this list in the blank spaces to the right side of the 00 cel over in the choreography cel list table. Follow the instruction for the 00 cel above.

Once you have the cels 00, 01 and 02 in the list, press the animate start/stop button and the animation should appear on the right hand window. In a very simple way this is all there is to byle.

Adding an additional choreography direction
Now lets add the back animation. Left click on the front button and while holding down the button move down to the back listing and once the back is highlighted then release the button. The back button should appear instead of the front button and the list of cels in the choreography cel list table should disappear.

Now insert cels 03-05 in order just as you did for the cels 00-02 when you were doing the front listing. Remember that the first cel in the list must be done by by clicking over in the choreography cel list area, but after that you can use the shift key and click to pass cels over. Click on the animation button to see these cels animate.

In a real costume, obviously, the 00-02 cels and 03-05 would have the appropriate walk front and walk back cels. The colored boxes are just for a quick example. Add cels 06-08 to the right direction and 09-11 to the left. Move back and forth between the different directional buttons and you will see the different cels that you have assigned to each.

Adding a new Choreography
Now let's add another choreography. Go to the choreography button and left click as you did before. Move up to the stand choreography and release the button. The choreography button should change to 03 stand and again you should see the list in the choreography cel list table, on the right hand side, will disappear. (The directional button, however will not change). Experiment with the 4 directions and setting up different sequences of animation cels. (you do not have to go in numerical order). If you feel confident, create some new cels with the ellipse fill brush.

Levels of animation
There is only one further basic component to understand. That is the concept of levels and levels of animation. The different levels are numbered A through P with each successive level having a priority over the previous one.

Let's show an example of this. Go back to the walk choreography and add an ellipse filled in a new color in the B/00 cel. Activate the front directional facing and start a new choreography list for level B. This should be below the 00-02 listing that you already have for level A. The 00 from the B level in the cel table should be placed on the B level in the choreography cel list table (you are unable to place it in another level anyway!), directly under the 00 on the A level in the choreography cel list table. Place this same 00 cel in the next two blank areas too.

The choreography cel list table should look like this.

```
00 01 02
00 00 00
```

Run the animation by activating the animation start/stop button and assuming that the ellipse is over the filled rectangle, then, you will get the ellipse shown fully with the changing filled rectangles behind it.

## The Lower Screen Buttons.

### chore

The "chore" button is a time saving button placed there for convenience. Left clicking the mouse button on this button will move the "chore name" button to the next numbered chore . Right clicking the mouse button on this button will decrement the "chore name" by one.

### chore name

The chore name contains the number and name of the choreography that is currently active. Clicking either mouse button, pulls up a window from which a new choreography can be selected. The "chore" button will also move to the next chore for convenience.

### animation start/stop button

The animation start/stop button activates the current choreography. Depending on the choreography cel list table, this will either be a one time animation or a cyclic animation.

### animation cel by cel button

The animation cel by cel button moves through the current choreography cel list one cel at a time. This is useful, for example, for finding the one cel in an

### xrel button

Probably the most difficult aspect of Byle to understand is the use of the relative offset on the x and y axis. Reading the explanation below, the first time, will probably stump you. If it doesn't, could you please explain xrel to the rest of us? You will, however, understand it more once you have played with xrel when we look at the Indy costume in section 10.7.

Xrel effects all levels below it in the choreography cel list table not the cel list table. The fact that B/01 is xrel -1 means absolutely nothing to cel C/01 which is below it in the cel list table. For example you could designate cel 06 as xrel -1 and then all the levels below would also be affected at the time that 06 is run. If you have uneven chains i.e.

```
04 05 06
01 02
```

with 06 at -1 then alternate cels below would be effected by the xrel.

It is possible to have multiple x and y. For example one level could be set to -1, while two levels down a cel is set to -2. All the cels below that at the time of animation would be a cumulative -3.

### yrel button

Probably the most difficult aspect of Byle to understand is the use of the relative offset on the x and y axis. Reading the explanation below, the first time, will probably stump you. You will, however, understand it more once you have played with yrel when we look at the Indy costume in section 10.7.

Yrel, just like xrel above, effects all levels below it in the choreography cel list table not the cel list table. The fact that B/01 is yrel 1 means absolutely nothing to cel C/01 which is below it in the cel list table. For example you could designate cel 06 as yrel 1 and then all the levels below would also be affected at the time that 06 is run. If you have uneven chains i.e.

```
04 05 06
01 02
```

with 06 at 1 then alternate cels below would be effected by the xrel.

It is possible to have multiple x and y. For example one level could be set to 1, while two levels down a cel is set to 2. All the cels below that at the time of animation would be a cumulative 3.

### directional buttons

A choreography can have up to four directions. A Choreography such as walking would usually have all four directions (front, back, right and left), while a special case animation might have only one direction.

In Byle, this direction can be changed one of two ways. The directional button can be activated by left clicking on the button and dragging down to the direction you want. Alternatively you can left click on one of the four directional buttons to the right of the choreography cel list table.

### Cel addition button

The default setting for the cel addition button is cel. The cel addition button allows the adding of four different special case cels into the choreography cel list table. These special case cels are, sound, counter, empty and flip.

sound
The sound cel allows a sound to be inserted by the scumm programmer. The most common use of the sound cel is in the walk choreography where it is placed to allow for the sound of the actor's footsteps to be added. This is done by the actor sound component of the actor command (see page xxx).

counter
Not implemented at this time.

empty
Added by Brad after he tried to explain xrel to me. This provides you with your own padded cel.

flip
Not implemented at this time.

## The Menu bar options

### Pull down Menu: File

Figure X shows the different options available under this menu.

#### load costume

The load costume menu choice activates the file requestor window (see interface 10.2). By clicking on the filename and then clicking on the load costume button, costumes can be loaded. Costumes may also be loaded by double clicking on the costume file name.

#### save costume

This will save the costume that you have currently loaded. If you attempt to save a costume and have no costume loaded then the system will inform you with an error message.

#### save costumes as

Click on the save costume as choice and then click on the edit button box and type in the new name. If you do not add the .byl extension, the system will do it for you.

#### make costume

Makes a cos file so that the scumm programmer can use it. See scumm manual.

#### load
Not implemented at this time.

#### load lbm palette

The load lbm palette choice loads an lbm palette (palette only) and replaces the current palette.

#### load lbm back drop

The load lbm backdrop choice loads a picture into the backdrop (backdrop is the right hand window) to see if the animation works in relation to the background.

Note: The right hand window is also used for importing .lbm files from dpaint animator.

#### write chores def.

Not implemented at this time.

#### quit

The quit option returns the artist to the DOS prompt. You are given the option of whether "you really want to quit."

### Pull down Menu: Copy

Figure X shows the different options available under this menu.

#### copy level

This allows you to copy the entire level (with chore list and directions ) down to another level. This choice is not implemented at this time.

#### copy cel

The copy cel choice allows you to copy a single cel. First click on a cel that you wish to copy and then activate the copy cel choice. Nothing will seem to happen. However click in the cel space where you wish to place the cel copy and then go up to the edit menu option again and select paste cel. The cel will then be placed in the space you designated.

#### copy chore

The copy chore choice allows the artist to copy the list (in 4 directions) of cels in the choreography cel list table but not the cels in the cel table. The copy chore choice does not copy the chore name either.

#### copy list

The copy list choice allows the artist to copy the one current level and direction that is active.

#### paste

The paste choice is context sensitive and changes as each copy is activated. For example, if the copy cel choice has been activated, then the paste choice will be paste cel.

### Pull down Menu: Brush

Figure X shows the different options available under this menu.

#### flip x

This works just like dpaint. Using the grab brush, you take part of the costume (or all if you wish ) and flip x will rotate it on the x axis.

#### flip y

This works just like dpaint. Using the grab brush, you take part of the costume (or all if you wish ) and flip y will rotate it on the y axis.

#### normal scale

Not implemented at this time.

#### half scale

Not implemented at this time.

#### scale up

Not implemented at this time.

#### scale down

Not implemented at this time.

#### set scale

Not implemented at this time.

#### replace

Not implemented at this time.

#### color

Not implemented at this time.

### Pull down Menu: Chores

Figure X shows the different options available under this menu.

#### name a chore

The name a chore menu choice allows you to name the choreography that you are currently within. An edit box will pop up in which you can type the new name.

#### Choreographies 00-15

Clicking on one of these will place you in that choreography and update the chore name button.

#### next set of chores

Clicking either mouse button, pulls down a window from which a new choreography can be selected.

### Pull down Menu: Special

Figure X shows the different options available under this menu.

#### insert

Insert is just a pull down way of setting the cel addition button.The cel addition button allows the adding of four different special case cels into the choreography cel list table. These special case cels are, sound, counter, empty and flip.

#### palette

The palette editor and dk are currently undergoing revision to make them compatible.

#### Remap palette

The palette remap menu option determines how many colors have been used in the animation including the background color. One of the limits of the system is that actors and animation can only use 16 colors out of the 256 available. (recommended that this is out of the upper 48) to build a costume.

On activating the remap palette choice the screen will post a message saying "please wait, finding used colors in all cels."

The palette remap window contains two palettes. The upper palette (source) shows the number of colors in the current costume. The lower palette (destination) is where you designate the colors you wish to keep.

To identify the colors used, there is a black mark against the colors. To get rid off the colors that you don't want click on them in the lower palette.

The counter keeps track of the number of colors in the source palette and destination palette.

The revert button will take undo your changes and return you to the colors originally identified.

Once you are happy with the colors chosen, click on "ok" and then the source palette will be remapped to the destination palette by changing the offending colors to the nearest match in the destination palette.

#### no flip left

One of the nice (yes there are a couple) items in byle is a time saving feature called flip left. By default the system automatically flips the image of whatever cels are in the choreography cel table listing in the left facing. This allows you to draw the right facing cels and then the system will take care of the left facing automatically. However please note you must still place those right facing cels in the left facing chore listing.

The menu choice No flip left just turns this off.

#### verbose output!

This menu option is used by Brad for debugging.

#### debug cel states

This menu option is used by Brad for debugging.

#### remove unused cels

Not implemented at this time.

#### onion skin

Not implemented at this time.

### Pull down Menu: Backdrop

Figure X shows the different options available under this menu.

#### load lbm backdrop

This menu choice is available both here and under the file menu option. The load lbm backdrop choice loads a picture into the backdrop (backdrop is the right hand window) to see if the animation works in relation to the background.

Note: The right hand window is also used for importing .pict files from dpaint animator.

#### show backdrop

The show backdrop menu choice toggles the backdrop on and off. It does not however immediately disappear from the screen. You must play animation, by clicking on the animation start/stop button to remove the backdrop.

#### save lbm backdrop

The save lbm backdrop menu choice saves the frames in a lbm format, so you can use them in dpaint or dk. This is being reworked.

#### Load .wak file

This is being reworked.

## Toolbox explanation

The Toolbox, located on the right of the screen, is similar to the standard Toolbox used by paint programs. While Byle adds a couple of new tools, most remain constant to their dpaint equivalents.

### Tool 1: Freehand Brush

The standard Byle brush is the dpaint Freehand brush tool default. This paints a single pixel at a time.

### Tool 2: Straight Line Tool

Use the straight line tool to paint straight lines at any angle. Holding down the shift key will draw a straight vertical or horizontal line. (Dpaint page 39).

### Tool 3: Rectangle Tool (Filled)

The Rectangle tool (filled) lets you paint rectangles and squares in a filled mode. Left click on the rectangle tool, move the cursor to the painting area and the pointer turns into cross hairs. Hold down the left mouse button. This is the first corner of the rectangle. With the mouse button still pressed down, drag the rectangle in any direction to the size you want. Release the mouse button. (DPaint page 41).

### Tool 4: Rectangle Tool (Unfilled)

Painting an unfilled Rectangle is no different from painting a filled Rectangle. (Dpaint page 42)

The Rectangle tool (unfilled) lets you paint rectangles and squares in a unfilled mode. Left click on the rectangle tool, move the cursor to the painting area and the pointer turns into cross hairs. Hold down the left mouse button. This is the first corner of the rectangle. With the mouse button still pressed down, drag the rectangle in any direction to the size you want. Release the mouse button. (DPaint page 41).

### Tool 5: The Fill Tool

The fill tool is not implemented yet.

### Tool 6: The Brush Pickup Tool

Click the brush pickup tool and move the cursor to the painting area. The pointer turns into a large crosshair. Position the crosshair at the upperleft corner of the area you wish to capture. Hold down the left mouse button and drag the cursor to the lower right hand corner of the image. Release the mouse button. Your new custom brush now has a copy of the image attached to it. Try stamping the brush on the screen by left clicking anywhere on the screen.

Unlike dpaint you may not pick up the image by pressing the right mouse button instead of the left mouse button in the first part of the above explanation.

### Tools 7 (and 17): Grid Tools

Tools 7 and 17 work together to place the actor position. This is generally the foot position of the actor and is used for the calculation of elevation etc in Scumm.

Clicking on tool 17 will display the currently defined position for the grid in relation to the actor. This is shown in the animation (right) window. Once, and only once, tool 17 is active you can activate tool 7 to set the grid point to another position. This is done in the left window. Once in the left window the cursor will change to a large white cross hair. Left clicking within the left hand window will redefine the position of the grid and the change will be shown in the right window immediately.

Note that the tool 7 cross hair can only be seen when tool 17 has been toggled.

### Tool 8: Magnify Tool

Hold down the left mouse button on the Magnify Tool. When the pop-up menu appears, the highlight the magnification power that you want. Hot key is M (Dpaint page 53).

### Tool 9: Color Pickup Tool

Clicking colors in the palette isn't the only way to select foreground and background colors. You can also select colors directly from your artwork. This is especially useful if you are working with many shades of the same color.

Click the color pickup tool and move the cursor to the painting area. The pointer turns into a small target cursor. Place the cursor on the shade you want to pick up. Click the left mouse button to select this color as your new foreground color. Click the right mouse button to select the color as your new background color. Clicking automatically deactivates the color pickup tool.(Dpaint page 38)

### Tool 10: Undo

This tool lets you undo your last painting action as long as you haven't clicked the mouse button in the meantime. Unlike dpaint, toggling the magnify tool is not the same as clicking (Dpaint page 36).

### Tool 11: Stamp Tool

The Stamp tool works with the brush pickup tool. Use the brush pickup tool to capture the image that you require. Next click in the cel (usually blank) that you wish to stamp the image. Finally click on the stamp tool and the image will be imported into the cel you designated.

### Tool 12: Blank

No tool has yet been assigned to this button.

### Tool 13: Ellipse Tool (filled)

Move the mouse cursor to the painting area. The pointer turns into a large crosshair. Hold down the mouse button and drag the ellipse until it's the size you want. Release the mouse button.

### Tool 14: Ellipse Tool (Unfilled)

To paint an unfilled ellipse is exactly the same as a filled ellipse. Move the mouse cursor to the painting area. The pointer turns into a large crosshair. Hold down the mouse button and drag the ellipse until it's the size you want. Release the mouse button.

### Tool 15: The Grid Tool I

This tool is usually used with a dpaint file setup with the standard costume box grid. Load the file in as a backdrop and click on tool 15.

By holding down the left mouse button, while in the right hand window, the artist defines a grab brush size. When the left mouse button is released, it will appear that nothing has happened. However the grab brush has been set.

To see this, left click again and the grab brush will reappear. Notice the effect that this has in the left hand window. Whatever is within the grab brush is portrayed at the center of the left hand window.

Move the grab brush around, while holding down the mouse button, to position the grab brush as you require. Releasing the mouse button will place the image that you captured with the grab brush into the first available cel within the current level (limb).

Doing this again will generate the image over the first image etc. An easy way to do animation from a dpaint input.

### Tool 16: The Grid Tool II (costume box grid)

Tool 16 provides an easy way to input animation cels from a dpaint file, as long as the animation has been drawn using a costume box grid.

Load the .lbm file that contains the backdrop. Make sure that the boxes are the same color and that they are connected properly.

Click on any box line and the system will automatically place the contents of each box in the cel table. The system will take the top left drawing in the costume box grid and place it in the current "hot" cel within the cel table.

The system sets up the cel list from top left to top right if the images in the right hand window are each surrounded by a box and the left hand side of the box is touching the previous.. (These boxes do not have to be the same size).

The next drawing is then placed in the next cel after the "hot" cel. For example if the first cel is B/00 then the system will add the drawings to BB/01 then B/02 etc.

### Tools 17 (and 7): Grid Tools

As noted above, tools 7 and 17 work together to place the actor position. This is generally the foot position of the actor and is used for the calculation of elevation etc in Scumm.

Clicking on tool 17 will display the currently defined position for the grid in relation to the actor. This is shown in the animation (right) window. Once, and only once, tool 17 is active you can activate tool 7 to set the grid point to another position. This is done in the left window. Once in the left window the cursor will change to a large white cross hair. Left clicking within the left hand window will redefine the position of the grid and the change will be shown in the right window immediately.

Note that the tool 7 cross hair can only be seen when tool 17 has been toggled.

### Tool 18: Hand Tool

The hand tool has not been implemented yet.

### Tool 19: Blank

No tool has yet been assigned to this button.

### Tool 20: Clear Tool

When you want to erase the entire screen, use the clear tool. Selecting CLR erases everything on the current screen (or document if it's larger than the screen) and replaces it with the new background color. This is also useful for deleting a cel you no longer require.

### Color Indicator

The two rectangles display the colors that you are currently using to paint. The inner rectangle shows the brush color, while the outer rectangle shows the current background color. Unlike dpaint's defaults of black and white, byle's defaults are black and blue.

### Palette

Right clicking in the palette changes the background color. A window will pop up and ask the question "what to do? Rebuild cels to reflect backgroung color change? Yes or No"

Yes changes the color throughout the entire animation including within the costume.

No does change the background color but not within the frames. This is a good way to tell how much space the animation cels take up.

## Question section.

Question 1:
In pixels, what is the maximum size for an animation box?
Answer 1:
The MAX size is 144 pixels wide by 132 high

Question 2:
When moving xrel and yrel what is the movement
Answer 2:
One (1) pixel. Holding down the shift key activates this by five.

Question 3:
How do you move around an image?
Answer 3:
The arrow keys will help the positioning except when in magnify mode. In that instance the arrow keys move the zoom position.

Question 4:
How many types of animation are there?
Answer 4:
There are two types of animation, ones that loop and one shots. Walking is a looping animation.

Question 5:
I'm running an animation but I don't see the cels highlighting in the cel table?
Answer 5:
Make sure that you are on the correct level. The cels will only show up if the level is highlighted.

Question 6:
When I load one costume it opens on the 02 (walk) choreography. When I open another costume, it opens on the 00 (null) choreography. Why?
Answer 6:
The system remembers where you were in a costume when you last saved the costume.

Question 7:
I lost part of my image, why?
Answer 7:
Whenever an image in a cel is moved out of the boundaries of the (left) window, that part of the image gets erased when it is moved back into the window.

## A look at a specific costume

As Byle is rather complicated and I've probably confuse the heck out of you, let's look at the Indy costume (Indy.byl) in a little detail.

Load the Indy costume (Indy.byl) into newbyle. You will be in the init choreography facing right.

### Walk choreography

Click on the B/06 cel and you will see a cel, in the left hand window, with Indy walking forward. By clicking on cels B/06 through B/11 (use the scroll bar as appropriate) you will see the 6 cels that are used for Indy's walking forward animation.

To get to the actual walk choreography from the init choreography, left click on the chore button once. Click on the forward button and you will see the cels 06- 11 listed in the choreography cel list table.

Click the animation start/stop button and Indy's walking forward animation will run. You will also see the cels in the cel list table cycling through the cels numbers 06-11 by highlighting in yellow. Click the animation start/stop button to stop.

Now as you did with cels B/06-11, look at B/12 through B/19. Here you will see the 8 cels that make up the right direction walking.

Click on the right facing button and click the animation start/stop button. The right facing walk animation will start cycling just as the forward walking animation did above. Click the animation start/stop button to stop the animation.

A nice thing about byle is that it will save you time if the left directional animation is the mirror image of the right directional animation. The system will automatically "flip" the cels placed in the left direction choreography cel list.

Click on the left directional button and you will see that the same cels 12-19 are in the choreography cel list table. However when you click on the animation start/stop button, the animation window will show Indy walking toward the left.

Note you still need to place the 12-19 cels in the left facing choreography cel list table. As noted, the system will flip whatever you put in there. It is possible to turn off the feature if you do not need it or if it is a special animation that requires a separate and special left facing (see no flip left). Click the animation start/stop button to stop the animation.

Now check out cels B/00 through B/05 for the 6 cels that are used for the walk back direction. Click on the back button to see the list of cels in the choreography cel list table. Again click the animation start/stop button to see the walk back animation cycle.

Nearly all costumes should be set up this way for their walk animation.

Explanation
One of the more difficult aspects of byle to comprehend is the effect that a previous choreography can have on the current choreography. Very simply, if a previous choreography had five levels and the current one has 4 then that 5th level will run with the current animation unless you prevent it. This can be useful for example with walking and talking at the same time (no they can't chew gum too!). By placing the talk animation in a seperate level, that animation is added to the walk animation until deactivated.

We activate and deactivate these levels with the special cels invisible, visible and kill.

Invisible/Visible
The invisible cel makes the level invisible. It is important to note that this is not only in the current choreography, but on that level in every choreography within the costume.

The invisible cel does not stop the cel list on the level it is placed. Instead it "hides" it from your view.

The visible cel returns the level to a visible state in every choreography. When you use the visible cel to turn the level back on the list will become visible to the user again and it is possible for a choreography cel list to become active immediately.

Kill
The kill cel stops the animation in that level of the costume/choreography. Running a chore with cels in that level is the only way to deactivate the kill cel.

### Init choreography

You may have noticed the in (which stands for invisible), within the C level of the choreography cel list table. This is because of the init choreography that was set for the costume.

Click on the chore name button and choose the (01) init choreography. Then click the front direction button. You will see that levels 1 and 3 in the choreography cel list table contain 00 cels. (i.e. A/00 and C/00). Click on cel C/00 in the cel list table and you will see that it is just a head, while A/00, as you saw earlier, is the torso and legs of Herman.

If you look at the different directions of the init choreography you will see that the left/right direction has cels A/07, B/00 and C/04 depicting the legs, torso and head. While the back direction has cels on only the A and C levels similar to the front direction. This may also explain a question you had having to do with the cels on level A that were not used in the walking animation (i.e. cels A/07 and A/14.)

The init animation is run every time the costume (actor) enters a room and each time you change the choreographies. This can occasionally be inconvenient, hence the use of "invisible" and "visible" cels. ( system uses visible as the default and therefore the "visible" is only needed to clear a previous, or potentially previous "invisible" cel.) The system still thinks an "invisible" cel is running, however the cel is unseen.

If the init has a level that is not subsequently over written by the next choreography (i.e. walk etc) then a level of animation will remain active with the next choreography unless a cel such as "invisible" is inserted. Similarly a visible cel will allow the init level to show through, this is the case with the stand choreography.

### Stand choreography

To get to the stand choreography from the init choreography, left click on the chore button twice. If you are not in the front facing direction, click that button.

As you can see from the choreography cel list table, this choreography is a little different. Cel A/00 is in the A level of the choreography cel list table. As you saw earlier this is only the torso and legs of Herman. Level B has the "kill" cel inserted (which we will get to later) and level C has the "visible" cel allowing us to see the init choreography for the C level facing front.

Just to check that, go back to the init choreography (right click twice on the chore button) and you will see the init choreography facing front has level C cel 00 in the choreography cel list table. Click on level C/00 in the cel list table and you will see the head that was on top of cel A/00 back in the stand choreography.

Return to the stand choreography. Click on the right directional button and you will see level A in the choreography cel list table contains A/07 (a leg cel) and level B contains B/00 (a torso cel). Level C has a "visible" cel because similar to above the init chore (in this case facing right) is used.

As before the left directional button is just the mirror reflection of the right. The standing back choreography is similar in concept to the standing front choreography.

### Talk choreography

Move to the talk choreography by left clicking once on the chore button. Click on the front direction button.

There is no cel in the A level of the choreography cel list table. The system uses the default and makes the init choreography, for this level and facing, visible. The B level of the choreography cel list table contains a "kill" cel.

Kill cels stop all animation including inits on that level. This is a good way of making sure that an init is not in the way.

Level C of the choreography cel list table contains the front talk animation. Cels C/00-C/03 are arranged in a 16 cel looping string to generate a realistic talk pattern. The talking back chore is similarly set up. Click on the right facing direction button and then click on the animation start/stop button. You should see Herman's arms move at the start of the animation but then stay still as Herman keeps on talking.

This effect is created on the B level of the choreography cel list table in this costume. A non looping cel { ( ) } is placed at the end of the 3 cels (B/00, B/03 and B/04) in the B level of the choreography cel list table.

Meanwhile the mouth talking animation on level C continues in a loop.

### Stop Talking choreography

Move to the stop talking choreography. You would think that the init would accomplish this but most stop talking choreographies require a little more work.

The front and back facings are easy enough. Level A in the choreography cel list table is left open allowing the init to take place and level B contains a "kill" cel. Meanwhile level C contains the appropriate stop talking cel.

However it is the right facing that is of interest here. The B level of the choreography cel list table in this direction (and also left) returns the arms of Herman to their original position before he started talking.

Again as with the action in talking, this is a one time animation.

Basic Choreography conclusion.

These five choreographies, init, walk, stand, talk and stop talking are standard for all costumes. Most costumes have special case choreographies. Herman is no exception.

### One hand point choreography.

One hand point is a good example of only using two directions in a costume. If you click on the front facing (or back) you will see that there are no cels in the choreography cel list table.

The right direction is the area of interest. The A level of the choreography cel list table contains cels A/07 and A/21. This simulates Herman's legs swaying while the B level contains cels B/01-04 which do the specific one hand point maneuver of Herman's body and arms.

Click on the animation start/stop button and watch the head of Herman. Even though the C level of the choreography cel list table contains just a "visible" cel signalling that the init chore facing should be used, you will see the head move as the body sways. This is because of relative offset. Click on the animation start/stop button to stop the animation.

Take a look at cels B/01 and B/02 on the cel list table. Notice that the xrel button is set to -1 and -2 respectively on these. Xrel effects all levels below it in the choreography cel list table not the cel list table. The fact that B/01 is xrel -1 means absolutely nothing to cel C/01 which is below it in the cel list table.

Look at the choreography cel list table on the B level. The 4th cel in the cel list is 01. Xrel effects whatever is below that cel when that cel is run in the animation. In this case the "visible" cel in level C means that the init choreography is being used on level C. Therefore the xrel -1 effects that cel by -1.

In the animation you see this causes the head of Herman to move 1 pixel to the left (-1). When the B/02 cel is active, it causes the cel below it (still the init chore cel) to move 2 pixels to the left (xrel = -2).

Hence the illusion of the head moving without the need for further cel drawing.

Special case conclusion.
The choreographies Point (07), Shrug (08) and Talk to Camera (09), continue the concept of relative offset. The shrug choreography is particularly worth looking at as it combines both positive and negative x offset for a nice effect.
