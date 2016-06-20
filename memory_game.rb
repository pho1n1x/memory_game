################################################################################
#                                                                              #
#                             Memory Game                                      #
#                                                                              #
#             Author:     PhO3n1x | Chris Völkel                               #
#             Language:   Ruby                                                 #
#             OS:         *nix                                                 #
#                                                                              #
################################################################################


## Variables, Arrays, Hashes, ...
# Array of shuffled letters that will go inside the boxes
letters = [ 'a', 'a', 'b', 'b', 'c', 'c', 'd', 'd', 'e', 'e', 'f', 'f', 'g', 'g', 'h', 'h', 'i', 'i', 'j', 'j' ].shuffle

# Array of box numbers
boxes = (1..20).to_a

# Array of the remaining boxes
@remaining_boxes = boxes

# Array that will hold the two consecutive guesses
@guesses = []

# Hash of box numbers and letters
@hash_boxes = boxes.zip(letters).to_h

# Variable that holds the number of the from player selected box
chosen_box = 0

# Variable for amount of max guesses
@max_guesses = 40

# Variable for the guess counter
@guess_count = 0

# Variable to hold a boolean for the guess
@guess = false

# Variable to hold a boolean for the game clear condition
@game_clear = false


## Methods

# Method that clears the screen -> requires a *nix plattform
def clear_screen
  system 'clear'
end

# Method that prints the remaining boxes
def print_boxes
  puts "\nThe following boxes are still in the game:"
  puts "\t[ #{ @remaining_boxes.join( ' ' ) } ]"
end

# Method that asks the player to pick one of the remaining boxes
def open_box
  valid_number = false
  until valid_number do
    
    # Print the remaining boxes to the player
    print_boxes
    
    # Ask player which box he/she would like to choose
    print "\nWhich one of the remaining boxes would you like to open (Remaining guesses: #{ @max_guesses - @guess_count })? "
    box_number = gets.chomp.to_i
    
    # Check if the selected box is valid
    if @remaining_boxes.include?(box_number)
      valid_number = true
    else
      puts "\nOops! Something must have gone wrong. #{ box_number } is not a valid input."
      puts "Please choose one of the remaining boxes."
    end
  end
  
  box_number
end

# Method that prints the content of the selected box to the screen
def print_box_content(box_number)
  puts "\nThe content of Box \##{ box_number } is the letter: #{ @hash_boxes[box_number] }"
  sleep(5)
  clear_screen
end

# Method that compares two consecutive guesses
def guessed_correctly?(guesses)
  @hash_boxes[guesses[0]] == @hash_boxes[guesses[1]] ? true : false
end

# Method that removes the boxes from the remaining_boxes array
def remove_boxes(guesses)
  guesses.each do |guess|
    @remaining_boxes.delete(guess)
  end
end


## Main Program

# Welcome message for the user
clear_screen
puts 'Welcome to the Memory Game'
puts '-' * 80
puts 'Game Instructions:'
puts "  This game is mape up of 20 boxes. Each box containes a letter from a - j."
puts "  Every turn you may open one of the boxes. After opening the box the content"
puts "  will be printed on your screen. You have 5 seconds to memorise the letter"
puts "  before the screen will be cleared and you may open another box."
puts "  Are the letters of two consecutive guesses the same the 2 boxes, which"
puts "  which contained the letters, will be removed from the game."
puts 'Limit:'
puts "  You may open up to #{ @max_guesses } boxes."
puts 'Goal:'
puts "  Find all the pairs before you use up all of your guesses."
puts '-' * 80

# Let the guessing begin
while @guess_count < @max_guesses do
  
  # Let the player select one box
  chosen_box = open_box
  
  # Print the content of the box to the screen
  print_box_content(chosen_box)
  
  # Increment the guess counter by 1
  @guess_count += 1
  
  # Append the box number to the guesses array
  @guesses.push(chosen_box)
  
  # First element of the guesses array will be removed if length > 2
  if @guesses.length > 2
    @guesses.shift
  end
  
  # Compare the two consecutive guesses
  if @guesses.length == 2
    if guessed_correctly?(@guesses)
      remove_boxes(@guesses)
      puts "\nHooray, you have found a matching pair. Boxes \##{@guesses[0]} and \##{@guesses[1]} have been removed."
      @guesses.clear
    end
  end
  
  # Check if the game clear condition is fulfilled
  if @remaining_boxes.length == 0
    @game_clear = true
    break
  end
end

# Evaluate the outcome of the game
puts @game_clear ? "\nCongratulations! You have cleared the game!" : "\nToo bad, you did not clear the game! Better luck next time mate."