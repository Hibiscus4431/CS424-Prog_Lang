/*

Paige Smith
Programming Assignment 1
Course: CS 424-01
Due: 2/21/2025

File: SmithProgrammingAssignment1.go
Description:
This program will read in quarterback data from an input file
and put it into a list/collection. It will print the data sorted
by the player last name, first name. The equations to calculate
the passer rating and completion percentage are given in the
assignment description.

Testing the program (ver: 1.24.0):
I created a file called "playerinput.txt" with the following data:

Jayden Daniels 331 480 3568 25 9
Justin Hebert 332 504 3870 23 3
Joe Burrow 460 652 4918 43 9
Jared Goff 390 539 4629 41 16
Lamar Jackson 316 474 4172 41 4
Brock Purdy 300 455 3864 20 12
Patrick Mahomes 392 581 3928 26 11
Josh Allen 307 483 3731 28 6
Jalen Hurts 248 361 2903 18 5
Derek Carr 189 279 2145 15 5

The program was tested with this data and produced the correct output
when compared to the given one in the assignment.

*/
//------------------------------------------------------------------------------
//imports for basic libraries
package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"
)

/*
	struct for the quarterback data

This struct will hold the data for each quarterback
and will be used to calculate the passer rating and completion percentage.
*/
type Quarterback struct {
	//hold name of QB
	firstName string
	lastName  string
	//hold QB statistics
	completions   int
	attempts      int
	yards         int
	touchdowns    int
	interceptions int
	//hold calculated statistics
	completionPercent float64
	passerRating      float64

	//end of struct
}

/*
	function to calculate the completion percentage

This function will take in a quarterback struct variable and calculate the completion
percentage and passer rating. It will then store the values in the passed in struct.
*/
func calculateCompPercent(qb *Quarterback) {
	//all equations given in assignment description
	//calculate the passer rating and completion percentage
	//and store them in the struct for qb
	//convert ints to float64 for calculations

	//calculate the comepletion percentage using completions and attempts stats
	qb.completionPercent = (float64(qb.completions) / (float64(qb.attempts))) * 100

	//calculate value 1 from completions and attempts stats
	value1 := ((float64(qb.completions) / float64(qb.attempts)) - 0.3) * 5

	//calculate value 2 from yards and attempts stats
	value2 := ((float64(qb.yards) / float64(qb.attempts)) - 3) * 0.25

	//calculate value 3 from touchdowns and attempts stats
	value3 := (float64(qb.touchdowns) / float64(qb.attempts)) * 20

	//calculate value 4 from interceptions and attempts stats
	//(0.095/0.04) = 2.375
	//1/0.04 = 25
	//the equation was giving issues, simplified it down so the math would be accurate
	value4 := 2.375 - ((float64(qb.interceptions) / float64(qb.attempts)) * 25)

	//use values 1-4 to calculate passer rating
	qb.passerRating = ((value1 + value2 + value3 + value4) / 6) * 100

	//end of function
}

//-----------------------------------------------------------------------------------
/*
	main function start

The main function will read in the data from the input file
and store it in a list of quarterbacks. It will then sort the list
by last name, first name and display the data in a table format to the user.
*/
func main() {
	//variables used in the main program
	//variable to call bufio.Scanner for keyboard input
	var keyboard = bufio.NewScanner(os.Stdin)
	//variable to call the Quarterback struct
	//var quarterback Quarterback
	//variable to hold the name of the file to open
	var fileName string
	//variable to hold the error message
	var estat error
	//variable to hold the file to open
	var inFile *os.File

	//display program use to user
	fmt.Printf("\nWelcome to the passer rating test program. I am going to read player\n")
	fmt.Printf("statistics from an input data file. You will tell me the name of\n")
	fmt.Printf("your input file.\n")
	//prompt user for input file name
	fmt.Printf("\nEnter the input file name: ")
	keyboard.Scan()
	fileName = keyboard.Text()

	//open the file
	inFile, estat = os.Open(fileName)

	//check if the file opened correctly
	if estat != nil {
		//exit if file did not open correctly
		fmt.Println("\nUnable to open file named: " + fileName)
		fmt.Println("\nExiting program.")
		os.Exit(1)
	} else {
		//tell user file opened successfully if no errors
		fmt.Println("\nFile opened successfully: " + fileName)
	}
	//close file if unanticipated error occurs
	defer inFile.Close()

	//make a list of quarterbacks
	var quarterbacks []Quarterback

	//create a scanner to read the file
	scanner := bufio.NewScanner(inFile)

	//file format: firstname lastname completions yards touchdowns interceptions
	//read until the end of file is found, assume no errors with data.
	//read the file line by line
	for scanner.Scan() {
		//create a new quarterback to store the data
		var quarterback Quarterback

		//make a string that can read in each line of the file
		line := scanner.Text()

		//read the line into the quarterback struct
		//read in first and last name of QB by parsing the line variable
		quarterback.firstName = strings.Fields(line)[0]
		quarterback.lastName = strings.Fields(line)[1]

		//read in each of the stats of the QB by parsing the line variable
		quarterback.completions, estat = strconv.Atoi(strings.Fields(line)[2])
		quarterback.attempts, estat = strconv.Atoi(strings.Fields(line)[3])
		quarterback.yards, estat = strconv.Atoi(strings.Fields(line)[4])
		quarterback.touchdowns, estat = strconv.Atoi(strings.Fields(line)[5])
		quarterback.interceptions, estat = strconv.Atoi(strings.Fields(line)[6])

		//compute a passer rating and completion percentage for each quarterback
		//by calling function
		calculateCompPercent(&quarterback)

		//append the quarterback to the list of quarterbacks
		quarterbacks = append(quarterbacks, quarterback)
	}

	//check for errors reading the file
	if err := scanner.Err(); err != nil {
		fmt.Println("Error reading file:", err)
		return
	}
	//end of file reading

	//begin sorting read in data in the list of quarterbacks
	//sort the list of quarterbacks by last name, then first name using the sort library
	sort.Slice(quarterbacks, func(i, j int) bool {
		//check last name if lower than next
		//replace name in list spot
		return quarterbacks[i].lastName < quarterbacks[j].lastName
	})

	//go through the list of quarterbacks and find the qb with the highest passer rating
	//create a variable to hold the highest passer rating
	var highRating float64
	//create a variable to hold the qb with highest passer rating
	var highIndex int

	//go through the list of quarterbacks and compare the ratings
	for i := 0; i < len(quarterbacks); i++ {
		//check if the passer rating is higher than the current highest passer rating
		if quarterbacks[i].passerRating > highRating {
			//if higher set the new highRating
			highRating = quarterbacks[i].passerRating

			//set the highest rated quarterback to the current quarterback
			highIndex = i
		}
	}

	//display the report to the screen
	//formatting for the heading that displays number of players in inputfile, and highest passer rated quarterback
	fmt.Printf("\n\nQUARTERBACK REPORT === %d PLAYERS FOUND IN FILE", len(quarterbacks))
	fmt.Printf("\nHIGHEST PASSER RATING - %s, %s\n\n", quarterbacks[highIndex].lastName, quarterbacks[highIndex].firstName)

	//formatting for the table
	fmt.Println("	PLAYER NAME 	:	Rating		Comp%")
	fmt.Println("-----------------------------------------------------")

	//go through the list of quarterbacks and display their data
	for i := 0; i < len(quarterbacks); i++ {
		//formatting for the table
		//this formatting was harder than the rest of the code fr
		fmt.Printf("%12s, %s	:	%.1f		%.1f\n", quarterbacks[i].lastName, quarterbacks[i].firstName, quarterbacks[i].passerRating, quarterbacks[i].completionPercent)
	}
	//end of table formatting

	//end of main
	fmt.Println("\nEnd of program.")
}
