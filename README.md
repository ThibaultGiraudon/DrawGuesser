<div align="center">
  <a href="https://github.com/ThibaultGiraudon/DrawGuesser">
    <img src="DrawTogether/Assets.xcassets/drawGuesser.imageset/drawGuesser.svg" alt="Logo" width="150" height="150">
  </a>
  <h3 align="center">DrawGuesser</h3>
  
  [![HitCount](https://img.shields.io/endpoint?url=https%3A%2F%2Fhits.dwyl.com%2FThibaultGiraudon%2FDrawGuesser.json%3Fcolor%3Dgreen)](https://github.com/ThibaultGiraudon/DrawGuesser/)
  ![](https://sloc.xyz/github/ThibaultGiraudon/DrawGuesser)
  [![Last commit](https://img.shields.io/github/last-commit/ThibaultGiraudon/DrawGuesser.svg)](https://github.com/ThibaultGiraudon/DrawGuesser/)
</div>

> [!NOTE]
> This project is still under development

## Summary

- [Description](#description)
- [Installation](#installation)
- [Draw](#installation)
- [Game Center](#installation)
- [Technical details](#technical-details)
- [Credits](#credits)


## Description

This project is an iOS application that let you play a 2 players drawing game. 


## Installation

### Clone the repository
Use the following command to clone the repository to your local machine:
```shell
git clone https://github.com/ThibaultGiraudon/DrawGuesser.git
```

### Launch the application
Open Xcode and click the run button or hit cmd+r.
You will need 2 physical devices with 2 different Apple IDs to play. You can't run it on the simulator yet because Game Center doesn't work on it.

### Open the application
On your phone you should see a new app called DrawGuesser.

## Draw
This is made with PKCanvasView. It is a class that allow you to create a drawable scroll view where you can use any type of tool like apple pencil or your finger.
You can change the drawing tool (pencil, pen, marker, eraser, ...), the color and the line width.

## Game Center
I used the game center to authenticate users. I then used GKMtach for all the matchmaking and communication between players.

## Bibliography

- **Game Center**: [Apple developer](https://developer.apple.com/documentation/gamekit/gkmatch)
- **Canvas**: Python [Apple developer](https://developer.apple.com/documentation/pencilkit/pkcanvasview)
