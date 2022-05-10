# ````
# global variables etc
# ````
@students = []

require 'date'
@months = Date::MONTHNAMES

require 'csv'

$pronoun = {
  "male" => {subject: "he", verb: "is", possessive: "his"},
  "female" => {subject: "she", verb: "is", possessive: "her"},
  "neutral" => {subject: "they", verb: "are", possessive: "their"}
}

# ````
# menu methods
# ````

def interactive_menu
  loop do
    print_menu
    process(STDIN.gets.chomp)
  end
end

def print_menu
  blank_line
  puts "What would you like to do?"
  blank_line
  puts "1. Input the students"
  puts "2. Show the students"
  puts "3. Save students to file"
  puts "4. Load students from file"
  puts "5. Search students by cohort"
  puts "6. View students by cohort"
  puts "7. Remove student"
  puts "8. No operation"
  puts "9. Exit"
end

def process(selection)
  case selection
  when "1"
    students = input_students
    puts "input complete"
  when "2"
    show_students
  when "3"
    save_students
  when "4"
    load_students
  when "5"
    print_by_cohort 
  when "6"
    print_by_cohort_all
  when "7"
    remove_student
  when "8"
    puts "I haven't set that one yet, oops"
  when "9"
    exit
  else
    puts "Please enter a number between 1 and 9..."
  end
end

def show_students
  print_header
  print_students if @students.count > 0
  blank_line
  @students.empty? ? print_footer_no_students : print_footer
  blank_line
end

def save_students(filename = "students.csv")
  # check if they want to save or save as
  puts "You are about to save to #{filename}"
  puts "Hit enter to continue or type any key followed by enter to save to another / new file"
  input = gets.chomp
  filename = save_or_load_new if !input.empty?
  #open file for writing
  CSV.open(filename, "w") do |file|
    #iterate over students array
    @students.each do |student|
      # push each line directly to CSV
      file << [student[:name], student[:cohort], student[:gender], student[:height], student[:hobbies]]
    end
  end 
  puts "save to #{filename} complete"
end

def load_students(filename = "students.csv")
  # check this is the file they want to open
  puts "You are about to open our default file: #{filename}"
  puts "Hit enter to continue or type any letter followed by enter to open a different file"
  input = gets.chomp.downcase
  filename = save_or_load_new if !input.empty?
  # open file for reading
  CSV.foreach(filename) do |file|
    name, cohort, gender, height = file[0..3]
    hobbies = file[4..-1]
    push_to_students(name, cohort, gender, height, hobbies)
  end
  print_load_success_text(filename)
end

def save_or_load_new
  puts "Enter file name"
  filename = STDIN.gets.chomp
  filename = "#{filename}.csv" if !filename.include?(".csv")
  filename
end

def print_by_cohort #user enters the cohort they would like to see
  puts "Which cohort would you like to see?"
  #validation - user input matches a valid month
  while true do
    cohort = STDIN.gets.chomp.capitalize
    if @months.any? {|month| month == cohort}
      break
    elsif cohort == "Quit"
      return
    else
      puts "That's not a valid entry, try again or type quit to cancel operation"
    end
  end
  #creating a new array with just names of student in the selected cohort
  result = @students.select { |student| student[:cohort] == cohort }
  #print names, or error message
  if result.empty? 
    puts "There are no students enrolled on this cohort"
  else
    result.each { |student| puts student[:name] }
  end
end

def print_by_cohort_all #shows all student names split by cohort
  cohorts = {}
  @students.each do |student|
    cohort = student[:cohort]
    #checking if there is already a key for the cohort & creating a new one if not
    cohorts[cohort] = [] if cohorts[cohort] == nil
    #pushing student name to corresponding key
    cohorts[cohort] << student[:name]
  end
  cohorts.each do |key, value|
    puts key.to_s.center(20)
    puts value
    blank_line
  end
end

# ````
# functionality methods
# ````

def input_students
  while true do
    puts "Enter next student name or press return twice to exit"
    name = STDIN.gets.chomp.split(" ").map!{|x| x.capitalize}.join(" ") #getting the name and ensuring each word is capitalized
    break if name.empty?

    # assigning centre through set_gender method
    puts "Please enter their gender (M/F/NB)"
    gender = set_gender

    puts "Which cohort #{$pronoun[gender][:verb]} #{$pronoun[gender][:subject]} on?"
    puts "leave blank if they are in the current month's cohort"
    cohort = set_cohort

    puts "Please enter #{$pronoun[gender][:possessive]} height in cm"
    height = STDIN.gets.chomp

    puts "Please enter #{$pronoun[gender][:possessive]} hobbies, press return twice when done"
    hobbies = set_hobbies

    push_to_students(name, cohort, gender, height, hobbies)
    student_input_count
  end
end

def push_to_students(name, cohort, gender, height, hobbies)
  @students << {name: name, cohort: cohort, gender: gender, height: height.to_i, hobbies: hobbies}
end

def set_gender
  gender = STDIN.gets.delete("\n").upcase # using an alternative to chomp for test
  #checking that input matches validation, using neutral as default
  case gender 
  when "M"
    gender = "male"
  when "F"
    gender = "female"
  else
    gender = "neutral"
  end
  gender
end

def set_cohort
  current_month = Time.now.month
  while true do
    cohort = STDIN.gets.chomp.capitalize
    # using current month as default if no month entered
    cohort = @months[current_month] if cohort.empty?
    #checking that input matches validation
    break if @months[1..12].any? { |month| month == cohort }
  end
  cohort
end

def set_hobbies
  hobbies = []
  #allows input of multiple hobbies into an array
  while true do
    input = STDIN.gets.chomp.downcase
    !input.empty? ? hobbies << input : break
  end
  hobbies
end

def try_load_students(filename = "students.csv")
  filename = ARGV.first unless ARGV.first.nil? # first argument from the command line
  if File.exist?(filename) # check file exists
    load_students(filename)
  else # if it doesn't exists
    puts "Sorry, #{filename} does not exist."
    exit
  end
end

def remove_student
  student_to_delete = nil
  while true do
    puts "Please enter the name of the student you'd like to remove"
    input = STDIN.gets.chomp.split(" ").map!{|x| x.capitalize}.join(" ")
    @students.each_with_index { |student, index| student_to_delete = index if student[:name] == input }
    if student_to_delete != nil
      @students.delete_at(student_to_delete)
      puts "#{input} deleted."
      break
    else
      puts "There is no student called `#{input}` on our records. Please select one of the follow students"
      puts "or type `quit` to cancel operation"
      print_by_cohort_all
      return if ask_quit_operation
    end
  end
end

def ask_quit_operation
  quit = gets.chomp
  return true if quit == "quit"
end

# ````
# printing methods
# ````

def student_input_count
  text = "Now we have #{@students.count} student"
  #pluralises sentence if there are multiple students
  puts @students.count > 1 ? "#{text}s" : text
end

def print_students
  @students.each_with_index do |student, index| 
    gender = student[:gender]
    puts "#{index + 1}. #{student[:name]} (#{student[:cohort]} cohort)"
    #if they didn't enter anything, don't print height
    if student[:height] > 0
      puts " - #{$pronoun[gender][:subject].capitalize} #{$pronoun[gender][:verb]} #{student[:height]}cm tall"
    end
    # if they didn't enter anything, don't print hobbies
    if student[:hobbies] != []
      puts " - #{$pronoun[gender][:possessive].capitalize} hobbies: #{student[:hobbies].join(", ")}"
    end
  end
end

def print_load_success_text(filename)
  puts "Loaded #{@students.count} entries from #{filename}"
end

def print_header
  puts "The students of Villains Academy".center(50)
  puts "-------------".center(50)
end

def print_footer
  text =  "Overall, we have #{@students.count} great student."
  #different approach to addressing plural in the case of multiple students / no students
  puts @students.count > 1 ? text.insert(-2, "s") : text
end

def print_footer_no_students
  puts "We currently habve no students :("
end

def blank_line
  puts nil
end

try_load_students
interactive_menu

# ````
# redundant but useful code for reference
# ````

=begin
````Loading students from a file, not one line at a time from a CSV````

def load_students(filename = "students.csv")
  # check this is the file they want to open
  puts "You are about to open our default file: #{filename}"
  puts "Hit enter to continue or type any letter followed by enter to open a different file"
  input = gets.chomp.downcase
  filename = save_or_load_new if !input.empty?
  # open file for reading
  file = File.open(filename, "r") do |file|
    # iterate over each line of the file
    file.readlines.each do |line|
      line = line.chomp.split(",")
      name, cohort, gender, height = line[0..3]
      hobbies = line[4..-1]
      push_to_students(name, cohort, gender, height, hobbies)
    end
  end
  print_load_success_text(filename)
end

````Saving to a file, not using CSV library````

def save_students(filename = "students.csv")
  # check if they want to save or save as
  puts "You are about to save to #{filename}"
  puts "Hit enter to continue or type any key followed by enter to save to another / new file"
  input = gets.chomp
  filename = save_or_load_new if !input.empty?
  #open file for writing
  file = File.open(filename, "w") do |file|
    #iterate over students array
    @students.each do |student|
      #converting hash into array
      student_data = [student[:name], student[:cohort], student[:gender], student[:height], student[:hobbies]]
      #converting array into string
      csv_line = student_data.join(",")
      file.puts(csv_line)
    end
  end 
  puts "save to #{filename} complete"
end

=end