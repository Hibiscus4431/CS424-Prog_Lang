#= 
Paige Smith
Programming Assignment 2
Course: CS 424-01
System: Windows 11
Due: 3/21/2025

File: SmithProgrammingAssignment2.jl
Description: 
This program reads in player data from an input file and sorts it by last name, then first name.
It will then sort it by passer rating and display both sort methods to the user. The same logic 
as programming assignment 1 is used to calculate the passer rating and completeion percentage, 
but with variations to convert to Julia syntax and is sorted by extra criteria.

Testing the program (ver: 1.11.4):
Using the Julia REPL, I ran the program with the following command: include("SmithProgrammingAssignment2.jl")
and it prompted me for the input file name. I entered "playerinput.txt" and the program executed.

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
=#

# imports for basic libraries
using Printf

##################################Functions####################################
#=
	function to calculate the completion percentage and passer rating

function to calculate passer rating (modified from programming assignment 1 logic)
This function will take in the data of the players and calculate the completion
percentage and passer rating. It returns the passer rating as a float value.
=#
function calculate_Pass_Comp(completions, attempts, yards, touchdowns, interceptions)
	if attempts == 0
		return 0.0
	end
	value1 = ((completions / attempts) - 0.3) * 5
	value2 = ((yards / attempts) - 3) * 0.25
	value3 = (touchdowns / attempts) * 20
	value4 = 2.375 - ((interceptions / attempts) * 25)
	return ((value1 + value2 + value3 + value4) / 6) * 100
end

#=
	function to read player data from a file

function to read player data from a given file and return it as an array of tuples.
Each tuple contains the player's first name, last name, completions, attempts, yards,
touchdowns, and interceptions.
=#
function read_Data(filename)
	# array to store file data
	players = []
	# open the file and read each line
	open(filename, "r") do file
		for line in eachline(file)
			# split the line into components and parse them
			data = split(strip(line))
			# save the player data as a tuple in the players array
			push!(players, (data[1], data[2], parse(Int, data[3]), parse(Int, data[4]),
				parse(Int, data[5]), parse(Int, data[6]), parse(Int, data[7])))
		end
	end
	# return the array of player data
	return players
end

#=
	function to sort players by name

function to sort players by last name, then first name. It uses the built-in sort functions
from Julia libraries to sort the players array based on name.
=#
function sort_Name(players)
	# sort players by last name, then first name 
	return sort(players, by = x -> (lowercase(x[2]), lowercase(x[1])))
end

#=
	function to sort players by passer rating

function to sort players by passer rating in decreasing order. It uses the calculate_Pass_Comp
function to compute the passer rating for each player and sorts them based on returned values.
=#
function sort_Rate(players)
	# sort players by passer rating (calculated using the calculate_Pass_Comp function)
	return sort(players, by = x -> -calculate_Pass_Comp(x[3], x[4], x[5], x[6], x[7]))
end

##################################Main Program##################################
#= 
	Main program execution

The main program prompts the user for an input file that is assumed to have no
invalid inputs. The program reads the player data from the file, sorts the players by name 
and by passer rating. It displays the results of each sort to the user then ends the program.
=#
function main()
	# debugging running in the Julia REPL or script 
	# # check the current directory
	# println("Current directory: ", pwd())

	# display welcome message and prompt for input file
	println("Welcome to the passer rating test program. I am going to read player")
	println("statistics from an input data file. You will tell me the name of")
	println("your input file.")
	print("Enter the name of your input file: ")
	# grab the input file name from the user
	filename = readline()

	# check if the file exists
	if !isfile(filename)
		println("Error: File '$filename' not found.")
		return
	end

	# read player data from the file and store it in array of tuples
	players = read_Data(filename)

	# formatting for output
	println("\nQUARTERBACK REPORT --- ", length(players), " PLAYERS FOUND IN FILES")

	# find the index of the highest-rated player using built in Julia findmax function
	_, highest_rated_index = findmax(p -> calculate_Pass_Comp(p[3], p[4], p[5], p[6], p[7]), players)
	# get the information on player with the highest index
	highest_rated_player = players[highest_rated_index]
	# print the player name
	println("HIGHEST PASSER RATING - ", highest_rated_player[2], ", ", highest_rated_player[1])

	# display header for sorting by player name ascending by lastname then firstname
	println("\nSorted by Name:")
	println("	PLAYER NAME 	:	Rating		Comp%")
	println("-----------------------------------------------------")
	# sort the playeys by name
	sorted_by_name = sort_Name(players)
	# display the sorted players by name
	for p in sorted_by_name
		rating = calculate_Pass_Comp(p[3], p[4], p[5], p[6], p[7])
		completion_percent = (p[3] / p[4]) * 100
		@printf("%12s, %s	:	%.1f		%.1f\n", p[2], p[1], rating, completion_percent)
	end

	# display header for sorting by passer rating in decreasing order
	println("\nSorted by Passer Rating:")
	println("	PLAYER NAME 	:	Rating		Comp%")
	println("-----------------------------------------------------")
	# sort the players by passer rating
	sorted_by_rating = sort_Rate(players)
	# display the sorted players by passer rating
	for p in sorted_by_rating
		rating = calculate_Pass_Comp(p[3], p[4], p[5], p[6], p[7])
		completion_percent = (p[3] / p[4]) * 100
		@printf("%12s, %s	:	%.1f		%.1f\n", p[2], p[1], rating, completion_percent)
	end

	# end of program message
	println("End of Program 2")
end

main()
