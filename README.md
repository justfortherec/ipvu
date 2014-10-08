# ipvu


This tool helps teaching assistants of Introduction to Programming at VU Amsterdam to evaluate and grade programming submissions.

## Usage

`ipvu COMMAND [OPTIONS]`

### COMMAND
 * `collect` Moves all Java files from subdirectories to each student's directory of this submission.
 * `compile` Compiles all Java files in directories.
 * `config`  Save path of libUI.jar for compiling and executing submissions.
 * `grades`  Lists grades of students as given in the Tex files.
 * `help`    Prints this message and more detailed information.
 * `run`     Executes all main methods in given directory.
 * `tex`     Prepares a Tex file from all Java files for each student.

Try `ipvu help COMMAND` for more detailed information.

### A typical workflow

Download submissions from Practool and extract them to your desired destination. I assume that is `~/ip/`.
The structure of this directory looks similar to:
```
$ pwd
/home/justfortherec/ip
$ tree .
.
|-- libUI.jar
|-- a1_abc123
|   `-- HelloWorld2.java
|-- a1_bcd500
|   |-- HelloWorld1.java
|   `-- HelloWorld2.java
|-- a1_efg390
|   |-- helloWorld1
|   |   `-- HelloWorld1.java
|   `-- helloWorld2
|       `--HelloWorld2.java
|-- a1_fgh390
|   |-- HelloWorld1.java
|   `-- HelloWorld2.java
```

Note the different ways in which students submit their assignments: Some put all files in their base directory, some use packages for each of the exercises, etc. To make our live easier, we want them all in common format. That is possible with the `collect` command.

`ipvu collect a1*` will move all Java files from subdirectories of any of the directories starting with _a1_ into the corresponding base directory.
```
$ ipvu collect a1*
$ tree .
.
|-- libUI.jar
|-- a1_abc123
|   `-- HelloWorld2.java
|-- a1_bcd500
|   |-- HelloWorld1.java
|   `-- HelloWorld2.java
|-- a1_efg390
|   |-- HelloWorld1.java
|   `-- HelloWorld2.java
|-- a1_fgh390
|   |-- HelloWorld1.java
|   `-- HelloWorld2.java
```
If files are moved, their package names will be changes automatically.

Before compiling we need to set the path to `libUI.jar`. This file can be downloaded from Blackboard. With `ipvu config libUI.jar` the path will be stored in a hidden file `.ipvu_config`. This path will used as classpath both for compiling and executing all assignments.

Now they can be compiled.
```
$ ipvu compile a1*
Building of a1_abc123 was successfull.
Building of a1_bcd500 was successfull.
Building of a1_efg390 was successfull.
Building of a1_fgh390 was successfull.
```
If for any reason a program can't be compiled, you will see javac's error messages just as you are used to.

As a next step you can create Tex files to be used for giving feedback. These files will include all Java files for each of the students. They are also prepared for easily adding comments and feedback. This is done using the [todonotes package](http://www.ctan.org/tex-archive/macros/latex/contrib/todonotes/).

The command `ipvu tex a1*` will create a .tex file in each of the directories starting with _a1_. These files include the necessary LaTex definitions and all Java files in listing environments. Inside these listing environments you can use `§\todo{Hello World}§` to give comments on the code. These comments can be written anywhere inside the submitted code and will be displayed inline (with `§\todo[inline]{Hello World}§`) or placed at the margin.

These LaTex files also include a line `\todo{Grade: }` just after the start of the document. The grade filled in here can also be displayed in a grade list for later use.

But first let's evaluate the programs: In order to run the compiled submissions, we can use the `run` command. `ipvu run a1_abc123` runs all the main methods in the directory `a1_abc123`. For later assignments it is also helpful to include the input file: `ipvu run g8_abc123 PirateInput.txt` will pipe the contents of `PirateInput.txt` to standard input of the submitted program. That way you can just click _Cancel_ when the program asks you to select an input file.

After the submissions are evaluated and grades are filled in in the LaTex file, a grade list can be shown.
```
$ ipvu grades a1*
Module: a1  ID: abc123  Grade: 6
Module: a1  ID: abc123  Grade: 8.5
Module: a1  ID: abc123  Grade: 7
Module: a1  ID: abc123  Grade: 5.5
```

That way you can easily copy the grades into Practool.

Using your favorite LaTex compiler, you can create PDFs from the LaTex files and print them or send them via email.


## Installation

Copy `ipvu` somewhere in your path and make it executable with `chmod +x ipvu`.

Alternatively you can just copy it to the directory where you store all the submissions and call it with `./ipvu`.

Once inside the directory with all submissions, tell `ipvu` where the Java library `libUI.jar` is located:
```
$ ipvu config ~/path/to/libUI.jar
```

Now you're done. Have fun.
