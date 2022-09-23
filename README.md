
# SNK M68000 (Ikari III) FPGA Implementation

FPGA compatible core of SNK M68000 (Ikari III based)arcade hardware for [**MiSTerFPGA**](https://github.com/MiSTer-devel/Main_MiSTer/wiki) written by [**Darren Olafson**](https://twitter.com/Darren__O). FPGA implementation has been verified against schematics for Ikari III (A7007). PCB measurements taken from Datsugoku: Prisoners of War (A7008), Street Smart (A8007), and Ikari III: The Rescue (A7007).

Ikari III PCB donated by [**atrac17**](https://github.com/atrac17) / [**djhardrich**](https://twitter.com/djhardrich) and verified by [**Darren Olafson**](https://twitter.com/Darren__O). Other SNK68K PCB verification done by [**atrac17**](https://github.com/atrac17). The intent is for this core to be a 1:1 playable implementation of SNK M68000 (Ikari III) arcade hardware. Currently in **beta state**, this core is in active development with assistance from [**atrac17**](https://github.com/atrac17).

<br>
<p align="center">
<img width="" height="" src="https://user-images.githubusercontent.com/32810066/189572945-776834c5-e904-40c3-b02c-fbb2f44bed84.png">
</p>

## Supported Games

| Title | PCB<br>Number | Status  | Released | ROM Set  |
|-------|---------------|---------|----------|----------|
| [**脱獄: Prisoners of War**](https://en.wikipedia.org/wiki/P.O.W.:_Prisoners_of_War)<br>P.O.W.: Prisoners of War | A7008         | Implemented | Yes | powj, powa  |
| [**怒III**](https://en.wikipedia.org/wiki/Ikari_III:_The_Rescue)<br>Ikari III: The Rescue                        | A7007         | Implemented | Yes | .245 merged |
| [**Street Smart**](https://en.wikipedia.org/wiki/Street_Smart_(video_game))                                      | A7008 / A8007 | Implemented | Yes | .245 merged |
| [**SAR: Search and Rescue**](http://snk.fandom.com/wiki/SAR:_Search_and_Rescue)                                  | A8007         | Implemented | Yes | .245 merged |

## External Modules

|Name| Purpose | Author |
|----|---------|--------|
| [**fx68k**](https://github.com/ijor/fx68k)      | [**Motorola 68000 CPU**](https://en.wikipedia.org/wiki/Motorola_68000) | Jorge Cwik     |
| [**t80**](https://opencores.org/projects/t80)   | [**Zilog Z80 CPU**](https://en.wikipedia.org/wiki/Zilog_Z80)           | Daniel Wallner |
| [**jtopl2**](https://github.com/jotego/jtopl)   | [**Yamaha OPL 2**](https://en.wikipedia.org/wiki/Yamaha_OPL#OPL2)      | Jose Tejada    |
| [**jt7759**](https://github.com/jotego/jt7759)  | [**NEC uPD7759**](https://github.com/jotego/jt7759)                    | Jose Tejada    |

# Known Issues / Tasks

- Measure full timings from PCB(s) for analog output [Task - Low Priority]  
- GFX toggles for sprite layers [Task - Low Priority]  <br><br>
- Correct colour palette in P.O.W. - Prisoners of War (US Version 1); dependent on sprite location / action [Issue]  
- Correct text layer in 脱獄 / P.O.W. - Prisoners of War (US Version 1, Mask ROM Sprites) [Issue]  
- Correct missing pixels during scrolling transitions for 脱獄 / P.O.W. - Prisoners of War (US Version 1, Mask ROM Sprites) [Issue]  <br><br>
- Audio issues known, may be an issue with the jtopl2 core or the current usage<br>(No need to report further audio issues; appears there are no audio issues in this core) [Issue]  

# PCB Check List

<br>

FPGA implementation has been verified against schematics [**schematics**](https://raw.githubusercontent.com/va7deo/SNK68/main/doc/A7007%20(Ikari%20III)/Schematic/A7007%20Schematics.pdf) for Ikari III. PCB measurements taken from Datsugoku: Prisoners of War (A7008), Street Smart (A8007), and Ikari III: The Resucue (A7007).

### Clock Information

H-Sync      | V-Sync      | Source   | PCB<br>Number  |
------------|-------------|----------|----------------|
15.625kHz   | 59.185606Hz | [**DSLogic+**](https://raw.githubusercontent.com/va7deo/SNK68/main/doc/A7008%20(P.O.W.)/PCB%20Measurements/POW_CSYNC_50MHz.png?token=GHSAT0AAAAAABKJR6W66IGCUFIRIFHKH4OOYY7PVZQ) | A7008 (P.O.W.) |
15.625kHz   | 59.185606Hz | TBD                                                                                                                                                                              | A7007 (IK3)    |
15.625kHz   | 59.185606Hz | DSLogic+                                                                                                                                                                         | A8007 (SS)     |

### Crystal Oscillators

Location               | PCB<br>Number               | Freq (MHz) | Use                       |
-----------------------|-----------------------------|------------|---------------------------|
X-4  (4MHZ)            | A7008 (P.O.W.) / A8007 (SS) | 4.000      | Z80 / YM3812 / uPD7759    |
X-2  (18MHZ)           | A7008 (P.O.W.) / A8007 (SS) | 18.000     | M68000                    |
X-1  (24MHz)           | A7008 (P.O.W.) / A8007 (SS) | 24.000     | Video / Pixel Clock       |

<br>

Location               | PCB<br>Number             | Freq (MHz) | Use                       |
-----------------------|---------------------------|------------|---------------------------|
F-18 (4MHZ)            | A7007 (IK3) / A8007 (SAR) | 4.000      | Z80 / YM3812 / uPD7759    |
H-17 (18MHZ)           | A7007 (IK3) / A8007 (SAR) | 18.000     | M68000                    |
E-9  (24MHz)           | A7007 (IK3) / A8007 (SAR) | 24.000     | Video / Pixel Clock       |

**Pixel clock:** 6.00 MHz

**Estimated geometry:**

    383 pixels/line
  
    263 pixels/line

### Main Components

Location | PCB<br>Number | Chip | Use |
---------|---------------|------|-----|
68000    | A7008 (P.O.W.) / A8007 (SS) | [**Motorola 68000 CPU**](https://en.wikipedia.org/wiki/Motorola_68000)   | Main CPU      |
Z-80A    | A7008 (P.O.W.) / A8007 (SS) | [**Zilog Z80 CPU**](https://en.wikipedia.org/wiki/Zilog_Z80)             | Sound CPU     |
YM3812   | A7008 (P.O.W.) / A8007 (SS) | [**Yamaha YM3812**](https://en.wikipedia.org/wiki/Yamaha_OPL#OPL2)       | OPL2          |
7759     | A7008 (P.O.W.) / A8007 (SS) | [**NEC uPD7759**](https://github.com/jotego/jt7759)                      | ADPCM Decoder |

Location | PCB<br>Number | Chip | Use |
---------|---------------|------|-----|
H-11/12  | A7007 (IK3) / A8007 (SAR) | [**Motorola 68000 CPU**](https://en.wikipedia.org/wiki/Motorola_68000)   | Main CPU      |
Z80      | A7007 (IK3) / A8007 (SAR) | [**Zilog Z80 CPU**](https://en.wikipedia.org/wiki/Zilog_Z80)             | Sound CPU     |
YM3812   | A7007 (IK3) / A8007 (SAR) | [**Yamaha YM3812**](https://en.wikipedia.org/wiki/Yamaha_OPL#OPL2)       | OPL2          |
C-18     | A7007 (IK3) / A8007 (SAR) | [**NEC uPD7759**](https://github.com/jotego/jt7759)                      | ADPCM Decoder |

### Custom Components

Location | PCB<br>Number | Chip | Use |
---------|---------------|------|-----|
SNKCLK   | A7007 (IK3) / A8007 (SAR) | [**SNK CLK**](https://raw.githubusercontent.com/va7deo/SNK68/main/doc/Custom%20Components/SNK_CLK.jpg?token=GHSAT0AAAAAABKJR6W75C2STVYR2QG4ATEEYY7PUUA) | Counter |
SNKI/O   | A7007 (IK3) / A8007 (SAR) | [**SNK I/O**](https://raw.githubusercontent.com/va7deo/SNK68/main/doc/Custom%20Components/SNK_IO.jpg?token=GHSAT0AAAAAABKJR6W77E5OSYH66GBOXS76YY7PVIQ)  | Rotary  |

# Core Features

### Native Y/C Output

- Native Y/C ouput is possible with the [**analog I/O rev 6.1 pcb**](https://github.com/MiSTer-devel/Main_MiSTer/wiki/IO-Board). Using the following cables, [**HD-15 to BNC cable**](https://www.amazon.com/StarTech-com-Coax-RGBHV-Monitor-Cable/dp/B0033AF5Y0/) will transmit Y/C over the green and red lines. Choose an appropriate adapter to feed [**Y/C (S-Video)**](https://www.amazon.com/MEIRIYFA-Splitter-Extension-Monitors-Transmission/dp/B09N19XZJQ) to your display.

### H/V Adjustments

- There are two H/V toggles, H/V-sync positioning adjust and H/V-sync width adjust. Positioning will move the display for centering on CRT display. The sync width adjust can be used to for sync issues (rolling) without modifying the video timings.

### Scandoubler Options

- Additional toggle to enable the scandoubler without changing ini settings and new scanline option for 100% is available, this draws a black line every other frame. Below is an example.

<table><tr><th>Scandoubler Fx</th><th>Scanlines 25%</th><th>Scanlines 50%</th><th>Scanlines 75%</th><th>Scanlines 100%</th><tr><td><br> <p align="center"><img width="128" height="112" src="https://user-images.githubusercontent.com/32810066/191898796-4daf3b2a-28d6-4cce-8ad0-cd3eae39ecb8.png"></td><td><br> <p align="center"><img width="128" height="112" src="https://user-images.githubusercontent.com/32810066/191898801-ba4eb5e6-6965-4db1-9af4-5cd855bfb305.png"></td><td><br> <p align="center"><img width="128" height="112" src="https://user-images.githubusercontent.com/32810066/191898805-efc048ba-0821-4d33-b509-c3284e37bb3b.png"></td><td><br> <p align="center"><img width="128" height="112" src="https://user-images.githubusercontent.com/32810066/191898808-95aaf56b-bcc2-4570-8df2-2188df552f02.png"></td><td><br> <p align="center"><img width="128" height="112" src="https://user-images.githubusercontent.com/32810066/191898826-9d13fb8e-5ad7-4029-8cb1-9e736ec82212.png"></td></tr></table>

# Controls

<br>

<table><tr><th>Game</th><th>Joystick</th><th>Service Menu</th><th>Control Type</th></tr><tr><td><p align="center">P.O.W.</p></td><td><p align="center">8-Way</p></td><td><p align="center"><br><img width="128" height="112" src="https://user-images.githubusercontent.com/32810066/189564520-0420b015-bf00-46d4-83ff-f9f6c6b2e1d6.png"></td><td><p align="center">Co-Op</td><tr><td><p align="center">Street Smart</p></td><td><p align="center">8-Way</p></td><td><p align="center"><br><img width="128" height="112" src="https://user-images.githubusercontent.com/32810066/189554369-4b2bfac6-ed0e-401c-b5af-a09713578243.png"></td><td><p align="center">Co-Op</td><tr><td><p align="center">Ikari III</p></td><td><p align="center">8-Way or Rotary</p></td><td><p align="center"><br><img width="128" height="112" src="https://user-images.githubusercontent.com/32810066/189554378-670bee3e-04e7-43e1-aac5-c8c21b976bdf.png"></td><td><p align="center">Co-Op</td><tr><td><p align="center">SAR</p></td><td><p align="center">8-Way or Rotary</p></td><td><p align="center"><br><img width="112" height="128" src="https://user-images.githubusercontent.com/32810066/189554390-1acb6dfe-fd93-4ebf-8aa8-043043ebf9b4.png"></td><td><p align="center">Co-Op</td> </table>

<br>

### Rotary Support

- Rotary control is supported on gamepad or firmware written by [**atrac17**](https://github.com/atrac17) / [**djhardrich**](https://twitter.com/djhardrich) for LS-30 functionality with an RP2040. There are toggles in the OSD under Debug Settings to select the rotary controller type per player. <br><br> Enabling autofire and setting to 160ms for Rotate CW/CCW in the MiSTer framework allows for smooth rotation; adjust the rate to fit your preference. LS-30 firmware requires no mapping and is plug and play; it is player dependent and connected over USB to the DE10-Nano.

<br>

### Keyboard Handler

- Keyboard inputs mapped to mame defaults for the following functions.

<br>

|Services|Coin/Start|
|--|--|
|<table> <tr><th>Functions</th><th>Keymap</th></tr><tr><td>Test</td><td>F2</td></tr><tr><td>Reset</td><td>F3</td></tr><tr><td>Service</td><td>9</td></tr><tr><td>Pause</td><td>P</td></tr> </table> | <table><tr><th>Functions</th><th>Keymap</th><tr><tr><td>P1 Start</td><td>1</td></tr><tr><td>P2 Start</td><td>2</td></tr><tr><td>P1 Coin</td><td>5</td></tr><tr><td>P2 Coin</td><td>6</td></tr> </table>|

|Player 1|Player 2|
|--|--|
|<table> <tr><th>Functions</th><th>Keymap</th></tr><tr><td>P1 Up</td><td>Up</td></tr><tr><td>P1 Down</td><td>Down</td></tr><tr><td>P1 Left</td><td>Left</td></tr><tr><td>P1 Right</td><td>Right</td></tr><tr><td>P1 Bttn 1</td><td>L-Ctrl</td></tr><tr><td>P1 Bttn 2</td><td>L-Alt</td></tr><tr><td>P1 Bttn 3</td><td>Space</td></tr> </table> | <table> <tr><th>Functions</th><th>Keymap</th></tr><tr><td>P2 Up</td><td>R</td></tr><tr><td>P2 Down</td><td>F</td></tr><tr><td>P2 Left</td><td>D</td></tr><tr><td>P2 Right</td><td>G</td></tr><tr><td>P2 Bttn 1</td><td>A</td></tr><tr><td>P2 Bttn 2</td><td>S</td></tr><tr><td>P2 Bttn 3</td><td>Q</td></tr> </table>|

|Debug|
|--|
|<table> <tr><th>Functions</th><th>Keymap</th></tr><tr><td>Text Layer (TXT)</td><td>F7</td><tr><td>Sprite Layer (FG)</td><td>F8</td></tr><tr><td>Sprite Layer (BG)</td><td>F9</td><tr><td>Sprite Layer (OBJ)</td><td>F10</td></tr> </table>|

<br>

- Custom keyboard inputs mapped for LS-30 RP2040 firmware functionality. The mapping is player dependent for the RP2040 firmware.

<br>

|LS-30 Player 1|LS-30 Player 2|
|--|--|
|<table> <tr><th>Functions</th><th>Keymap</th></tr><tr><td>P1 Rotary 1</td><td>Y</td></tr><tr><td>P1 Rotary 2</td><td>U</td></tr><tr><td>P1 Rotary 3</td><td>I</td></tr><tr><td>P1 Rotary 4</td><td>O</td></tr><tr><td>P1 Rotary 5</td><td>H</td></tr><tr><td>P1 Rotary 6</td><td>J</td></tr><tr><td>P1 Rotary 7</td><td>K</td></tr><tr><td>P1 Rotary 8</td><td>L</td></tr><tr><td>P1 Rotary 9</td><td>N</td></tr><tr><td>P1 Rotary 10</td><td>M</td></tr><tr><td>P1 Rotary 11</td><td>,</td></tr><tr><td>P1 Rotary 12</td><td>.</td></tr> </table> | <table> <tr><th>Functions</th><th>Keymap</th></tr><tr><td>P2 Rotary 1</td><td>Z</td></tr><tr><td>P2 Rotary 2</td><td>X</td></tr><tr><td>P2 Rotary 3</td><td>C</td></tr><tr><td>P2 Rotary 4</td><td>V</td></tr><tr><td>P2 Rotary 5</td><td>B</td></tr><tr><td>P2 Rotary 6</td><td>W</td></tr><tr><td>P2 Rotary 7</td><td>E</td></tr><tr><td>P2 Rotary 8</td><td>T</td></tr><tr><td>P2 Rotary 9</td><td>3</td></tr><tr><td>P2 Rotary 10</td><td>4</td></tr><tr><td>P2 Rotary 11</td><td>7</td></tr><tr><td>P2 Rotary 12</td><td>8</td></tr> </table>|

# Support

Please consider showing support for this and future projects via [**Darren's Ko-fi**](https://ko-fi.com/darreno) and [**atrac17's Patreon**](https://www.patreon.com/atrac17). While it isn't necessary, it's greatly appreciated.

# Licensing

Contact the author for special licensing needs. Otherwise follow the GPLv2 license attached.
