# Generic Lava Platformer 5000

*Generic Lava Platformer 5000 is an endless jumper written in Processing. The floor is lava and you must keep Jumpman from falling into it... by jumping!*

### Screenshots

![Title Screen](docs/GLP5_TitleScreen.png =331x)

![Game Play Screen](docs/GLP5_GameScreen.png =331x)

![Game Over Screen](docs/GLP5_GameOver.png =331x)

### How To Run
GLP5 has been tested and confirmed working in Processing 2.2.1.

To load the project open GLP5.pde in Processing 2.2.1.

### Authors
Code: Jonathan Seguin
Art: Konstantino Kapetaneas
Lava Inspirations: Winnie Kwan

### Build

#### From PDE
1. Load GLP5.pde in Processing 2.2.1 to open the project.
2. From the File menu select "Export Application"
3. Choose your platform of choice

#### From Command Line
1. Make sure processing-java is added to your PATH or navigate to the directory that contains your processing binary
2. enter `processing-java --sketch=path/to/sketch/folder --output=path/to/sketch/folder/build --export`

  Here is a concrete example of a this on Windows 7:

  `processing-java.exe --sketch=C:\Users\Jon\Documents\Processing\GLP5 --output=C:\Users\Jon\Documents\Processing\GLP5\build --export`

  **_Note_**: building from the command line probably only builds for the platform this is executed on.
