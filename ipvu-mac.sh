#!/bin/bash
###############################################################################
# ipvu
#
# A tool to assist teaching assistants of Introduction to Programming at VU
# Amsterdam. Use this to prepare, compile, and run submissions. It also
# generates Tex-Files of all submitted Java files for easy feedback.
#
# License: Feel free to do what ever you want to do with this
# but don't blame me for anything :-)
# I'm happy to accept pull requests with fixes and/or improvements.
#
# Version: 0.9
# Author: Franz Geiger <f.x.geiger@vu.nl>
#
###############################################################################

COMMAND=$(basename $0)
SUBCOMMAND="$1"
ARGUMENTS=${*: 2}


usage() {
	if [ $1 ]
	then
		case $1 in
			compile|com|c) helpCompile ; return 0 ;;
			collect|col) helpCollect ; return 0 ;;
			config) helpConfig ; return 0 ;;
			grades|gr|g) helpGrades ; return 0 ;;
			help|he|h) usage ; return 0 ;;
			run|ru|r) helpRun ; return 0 ;;
			tex|te|t) helpTex ; return 0 ;;
		esac

		echo "$1 is not a known command. Try compile, collect, config, grades, run, or tex."
	else
	cat << EOF
Usage: $COMMAND COMMAND [OPTIONS]

$COMMAND helps teaching assistants of Introduction to Programming at VU Amstardam to evaluate and grade programming submissions.

COMMAND:
	collect	Moves all Java files from subdirectories to each student\'s
		directory of this submission.
	compile	Compiles all Java files in directories.
	config	Save path of libUI.jar for compiling and executing submissions.
	grades	Lists grades of students as given in the Tex files.
	help	Prints this message and more detailed information.
	run	Executes all main methods in given directory.
	tex	Prepares a Tex file from all Java files for each student.
Try '$COMMAND help COMMAND' for more detailed information.
EOF
	fi
}
helpCollect() {
	cat << EOF
* collect
Usage: $COMMAND collect DIRECTORIES
Moves all .java files in subdirectories of each directory in DIRECTORIES to that directory and changes package name to the name of the directory.
Downloads from practool contain one directory for each student in the form of g8_fgr200 where g8 identifies the module and fgr200 is the student ID. This command moves for instance g8_fgr250/pirate/Pirate.java to g8_fgr250/Pirate.java and changes the package name from "package pirate;" to "package g8_fgr250;".
DIRECTORIES: One or more directories of student submissions.
Examples:
	$COMMAND collect f4_fgr200
	$COMMAND collect f4_fgr200 f4_zns300
	$COMMAND collect f4_*
EOF
}
helpCompile() {
	cat << EOF
* compile
Usage: $COMMAND compile DIRECTORIES
Compiles all .java files in all DIRECTORIES.
Use '$COMMAND collect' in order to move all .java files to those directories before you compile. Uses the Java library LibUI as additional classpath as configured (see '$COMMAND help config').
DIRECTORIES: One or more directories of student submissions with all.
Examples:
	$COMMAND compile f4_fgr200
	$COMMAND compile f4_fgr200 f4_zns300
	$COMMAND compile f4_*
EOF
}
helpConfig() {
	cat << EOF
* config
Usage: $COMMAND config LIB_UI_PATH
Saves the path to libUI.jar for compilation and running of submissions.
If there is already a config file .ipvu_config in the current or any parent directory, that file's contents get overwritten with LIB_UI_PATH.

If such a file doesn't exist yet, it will be created in the current directory.
LIB_UI_PATH: Path of libUI.jar as downloaded from Blackboard.
Examples:
	$COMMAND config libUI.jar
	$COMMAND config ~/Downloads/libUI.jar
EOF
}
helpGrades() {
	cat << EOF
* grades
Usage: $COMMAND grades [LOCATIONS]
Prints a list with grades of all assignments at LOCATIONS.
Grades are read from the line '\\todo{Grade: }' in any .tex files and displayed in a table with module and student IDs next to the grade.  By default all .tex files in and under the current path are read.
LOCATIONS: One or more files or directories to read grades from.
Examples:
	$COMMAND grades
	$COMMAND grades f4_fgr200
	$COMMAND grades f4*
	$COMMAND grades f4_fgr200/f4_fgr200.tex
	$COMMAND grades f4_fgr200/f4_fgr200.tex f4_zns300
EOF
}
helpRun() {
	cat << EOF
* run
Usage: $COMMAND run DIRECTORY [INPUT_FILE]
Executes all main methods in any Java class in DIRECTORY. Use '$COMMAND compile' to compile them first.
If INPUT_FILE is given, it gets piped to standard input of the Java program (you can just click cancel when asked to select the input file).
Uses the Java library LibUI as additional classpath as configured (see '$COMMAND help config').
DIRECTORY: The directory which contains the Java class(es) to be executed.
INPUT_FILE: An input file (e.g. PirateInput.txt).
Examples:
	$COMMAND run f4_fgr200
	$COMMAND run f4_fgr200 PirateInput.txt
EOF
}
helpTex() {
	cat << EOF
* tex
Usage: $COMMAND tex DIRECTORIES
Creates .tex file in each of DIRECTORIES from all .java files in each of DIRECTORIES. The file will be called after the name of the directory in which it gets created (e.g. g8_fgr200.tex).
DIRECTORIES: One or more directories with .java files in them.
Examples:
	$COMMAND tex f4_fgr200
	$COMMAND tex f4_fgr200 f4_zns300
	$COMMAND tex f4_*
EOF
}
texStart(){
	cat << EOF
% This is a template for grading programming assignments.
% The code should be placed between \\begin{lstlisting} and \\end{lstlisting}
% (use the bash script for that! This script also takes care of closing the
% listing environment and the document).
% Your comments can go either in the margin by using §\\todo{Hello World}§ or
% inline with §\\todo[inline]{Hello World}§.
%
% You can find all details about the todonotes package at:
% http://mirrors.ctan.org/macros/latex/contrib/todonotes/todonotes.pdf
%
% Note the escape character § around the commands. This is necessary inside
% the listing environment.
%
% You might have to compile it two or three times for all lines pointing to
% the correct locations.
%
% License: Feel free to do what ever you want to do with this
% but don't blame me for anything :-)
% I'm happy to accept pull requests with improvements.
% Version: 0.9
% Author: Franz Geiger <f.x.geiger@vu.nl>
%
\\documentclass[12pt,a4paper]{report}
\\usepackage[utf8]{inputenc}
\\usepackage[left=1.00cm, right=6.00cm, top=1.00cm, bottom=2.00cm]{geometry}
\\usepackage{color}
\\definecolor{dkgreen}{rgb}{0,0.6,0}
\\definecolor{mauve}{rgb}{0.58,0,0.82}
\\definecolor{blue}{rgb}{0.25,0.35,0.75}
\\usepackage{listingsutf8}
\\lstloadlanguages{Java}
\\lstset{
    language=Java,
    basicstyle=\\footnotesize\\ttfamily,
    showstringspaces=false,
    breaklines=true,
    tabsize=2,
    keywordstyle=\\color{mauve},
    commentstyle=\\color{dkgreen},
    stringstyle=\\color{blue},
    numberstyle=\\color{blue},
    inputencoding=utf8/latin1,
    escapechar=§
}
\\setlength{\\marginparwidth}{5.5cm}
\\usepackage[pdftex,dvipsnames]{xcolor}
\\usepackage{xargs}
\\usepackage[colorinlistoftodos,prependcaption,textsize=small]{todonotes}
\\newcommand{\\bad}[2][1=]{\\todo[linecolor=red,backgroundcolor=red!25,bordercolor=red]{#2}}
\\newcommand{\\improvement}[2][1=]{\\todo[linecolor=blue,backgroundcolor=blue!25,bordercolor=blue]{#2}}
\\newcommand{\\good}[2][1=]{\\todo[linecolor=green,backgroundcolor=green!25,bordercolor=green]{#2}}
% Use like §\\todo{Hello World}§
\\begin{document}
\\todo[noline, size=\\large]{Grade: }
EOF
}
texEnd() {
	cat << EOF
\end{document}
EOF
}
parentDirectory(){
	echo $(dirname $(readlink -f $1))
}
setLib() {
	LIB=$(readlink -f "$1")
	if [ ! -f $LIB ]
	then
		echo "$1 does not exist".
		return 1
	fi
	CONFIG=$(findConfigFile)
	if [ ! $? == 0 ]
	then
		CONFIG=".ipvu_config"
	fi
	echo "$LIB" > "$CONFIG"
}
findConfigFile() {
	DIR=$PWD

	while [ ! "$DIR" == $(dirname "$DIR") ]
	do
		if [ -f "$DIR/.ipvu_config" ]
		then
			echo $(readlink -f "$DIR/.ipvu_config")
			return 0
		fi
		DIR=$(parentDirectory "$DIR")
	done
	return 1
}
getLib() {
	CONFIG=$(findConfigFile)
	if [ $? == 0 ]
	then
		cat "$CONFIG"
		return 0
	else
		echo "There is no configuration file .ipvu_config in this or any parent directory"
		echo "Please specify the location of libUI.jav using '$COMMAND config <PATH_TO_LIBUI>'."
		exit 1
	fi
}
compile(){
	DIR="$1"
	# Get ID of student from parent directory name
	ID=$(basename "$DIR")
	LIB=$(getLib)
	fixPackagePaths "$DIR"
	cd $(dirname "$DIR")
	if `javac -classpath $LIB $ID/*.java`
	then
		echo "Building of $ID was successfull."
	else
		echo "Building of $ID was not successfull."
	fi
	return 0
}
compileAll(){
	for ARG in $ARGUMENTS
	do
		DIR=$(readlink -f "$ARG")
		if [ -d "$DIR" ]
		then
			compile "$DIR"
		else
			echo "$DIR is not a directory"
		fi
	done

	return 0
}
run(){
	DIR=$(readlink -f "$1")
	if [ ! -d "$DIR" ]
	then
		echo "$1 is not a directory"
		exit 1
	fi
	# Get ID of student from parent directory name
	ID=$(basename "$DIR")
	INPUT=$(readlink -f "$2")
	LIB=$(getLib)
	cd $(dirname "$DIR")

	# Execute every main method in this directory
	for FILE in `grep -E -l "static.*main\s*\(.*\)" "$DIR"/*.java`
	do
		MAIN=`echo $(basename "$FILE") | sed "s/\//./" | sed "s/.java//"`

		if [ -n "$2" -a -f "$INPUT" ]
		then
			java -classpath .:"$LIB" "$ID.$MAIN" < "$INPUT"
		else
			java -classpath .:"$LIB" "$ID.$MAIN"
		fi
	done
	return 0
}
createTexFile(){
	DIR="$1"
	OUTFILE="$DIR"/$(basename "$DIR").tex
	if [ -f "$OUTFILE" ]
	then
		echo "$OUTFILE already exists"
	else
		texStart >> "$OUTFILE"
		for file in "$DIR"/*.java
		do
			FILENAME=$(basename "$file")
			echo "\\begin{lstlisting}[caption={$FILENAME}]" >> "$OUTFILE"
			cat "$file" >> "$OUTFILE"
			echo "\\end{lstlisting}" >> "$OUTFILE"
		done
		texEnd >> "$OUTFILE"
	fi
	return 0
}
createTexFiles(){
	for ARG in $ARGUMENTS
	do
		DIR=$(readlink -f "$ARG")
		if [ -d "$DIR" ]
		then
			createTexFile "$DIR"
		fi
	done

	return 0

}
fixPackagePaths(){
	# Patch all Java files to be in package $ID
	DIR=$(readlink -f "$1")
	ID=$(basename "$DIR")
	gsed -i "s/package .*$/package $ID;/i" $DIR/*.java
	return 0
}
collectFiles(){
	for ARG in $ARGUMENTS
	do
		DIR=$(readlink -f "$ARG")
		if [ -d "$DIR" ]
		then
			find "$DIR" -mindepth 2 -iname *.java -print0 | xargs -0 -I file mv file "$DIR"
			fixPackagePaths "$DIR"
		fi
	done

	return 0
}
gradeList(){
	if [ ! "$ARGUMENTS" ]
	then
		ARGUMENTS="*/*.tex"
	fi
	grep \
		-iIHr \
		--exclude="$COMMAND" \
		"\\todo\(\[.*\]\)*{Grade:" $ARGUMENTS \
	| gsed \
		"s/.*\([a-z][0-9]\)_\([a-z]\{3\}[0-9]\{3\}\).*tex:\\\\todo\\(\\[.*\\]\\)*{Grade:\s*\(.*\)}.*/Module: \1\tID: \2\tGrade: \4/" \
		--
}
case $SUBCOMMAND in
	collect|col) collectFiles ; exit 0 ;;
	compile|com|c) compileAll $2 $3 ; exit 0 ;;
	config) setLib $2 ; exit 0 ;;
	grades|gr|g) gradeList ; exit 0 ;;
	help|he|h) usage $2 ; exit 0 ;;
	run|ru|r) run $2 $3 ; exit 0 ;;
	tex|te|t) createTexFiles ; exit 0 ;;
esac
usage
exit 0
