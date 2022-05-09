@students = []
def interactive_menu
  loop do
    print_menu
    user_input = gets.chomp
    case user_input
    when "1"
      students = input_students
    when "2"
      show_students
    when "9"
      exit
    else
      puts "Please enter a number between 1 and 9..."
    end


  end
end

def print_menu
  puts "1. Input the students"
  puts "2. Show the students"
  puts "9. Exit"
end

def show_students
  print_header
  print_students(@students)
  blank_line
  print_footer(@students)
end


def input_students
  while true do
    puts "Enter next student name or press return twice to exit"
    name = gets.chomp.split(" ").map!{|x| x.capitalize}.join(" ") #getting the name and ensuring each word is capitalized
    break if name.empty?

    # assigning centre through set_gender method
    puts "Please enter their gender (M/F/NB)"
    gender = set_gender

    puts "Which cohort #{$pronoun[gender][:verb]} #{$pronoun[gender][:subject]} on?"
    cohort = set_cohort

    puts "Please enter #{$pronoun[gender][:possessive]} height in cm"
    height = gets.chomp.to_i #to_i deletes any additional characters such as "cm"

    puts "Please enter #{$pronoun[gender][:possessive]} hobbies, press return twice when done"
    hobbies = set_hobbies

    @students << {name: name, cohort: cohort, gender: gender, height: height, hobbies: hobbies }
    
    student_input_count
  end
end

def set_gender
  gender = gets.delete("\n").upcase #using an alternative to chomp
  #checking that input matches validation, using neutral as default
  case gender 
  when "M"
    gender = :male
  when "F"
    gender = :female
  else
    gender = :neutral
  end
  gender
end

def set_cohort
  months = [:January, :February, :March, 
            :April, :May, :June, 
            :July, :August, :September, 
            :October, :November, :December] #validation
  while true do
    cohort = gets.chomp.capitalize.to_sym
    cohort = :November if cohort.empty?
    #checking that input matches validation
    break if months.any? {|month| month == cohort}
  end
  cohort
end

def set_hobbies
  hobbies = []
  #allows input of multiple hobbies into an array
  while true do
    input = gets.chomp.downcase
    !input.empty? ? hobbies << input : break
  end
  hobbies
end

def student_input_count
  text = "Now we have #{@students.count} student"
  #pluralises sentence if there are multiple students
  puts @students.count > 1 ? "#{text}s" : text
end


#global pronoun selector
$pronoun = {
  male: {subject: "he", verb: "is", possessive: "his"},
  female: {subject: "she", verb: "is", possessive: "her"},
  neutral: {subject: "they", verb: "are", possessive: "their"}
}

def print_students(names)
  if names.count > 0
    names.each_with_index do |student, index| 
      gender = student[:gender]
      puts "#{index + 1}. #{student[:name]} (#{student[:cohort]} cohort)"
      #if they didn't enter anything, don't print height
      if student[:height] > 0
        puts " - #{$pronoun[gender][:subject].capitalize} #{$pronoun[gender][:verb]} #{student[:height]}cm tall"
      end
      #if they didn't enter anything, don't print hobbies
      if student[:hobbies] != []
        puts " - #{$pronoun[gender][:possessive]} hobbies are #{student[:hobbies].join(", ")}."
      end
    end
  end
end

def print_by_cohort(names) #user enters the cohort they would like to see
  if names.count > 0
    puts "Which cohort would you like to see?"
      months = [:January, :February, :March, :April, :May, :June, :July, :August, :September, :October, :November, :December]
      #validation - user input matches a valid month
      while true do
        cohort = gets.chomp.capitalize.to_sym
        break if months.any? {|month| month == cohort}
      end
    #creating a new array with just names of student in the selected cohort
    result = names.select { |student| student[:cohort] == cohort }
    #print names, or error message
    if result.empty? 
      puts "There are no students enrolled on this cohort"
    else
      result.each { |student| puts student[:name] }
    end
  end
end

def print_by_cohort_all(names) #shows all student names split by cohort
  cohorts = {}
  names.each do |student|
    cohort = student[:cohort]
    #checking if there is already a key for the cohort & creating a new one if not
    cohorts[cohort] = [] if cohorts[cohort] == nil
    #pushing student name to corresponding key
    cohorts[cohort] << student[:name]
  end
  cohorts.each do |key, value|
    puts key.to_s.center(20)
    puts value
    puts nil #just a blank line
  end
end

def print_header
  puts "The students of Villains Academy".center(50)
  puts "-------------".center(50)
end

def print_footer(names)
  text =  "Overall, we have #{names.count} great student."
  #different approach to addressing plural in the case of multiple students / no students
  if names.count > 1
    puts text.insert(-2, "s")
  elsif names.count == 0
    puts "We currently have no students :("
  else
    puts text
  end
end

def blank_line
  puts nil
end

=begin
students = input_students
print_header
blank_line
print_students(students)
blank_line
print_by_cohort_all(students)
blank_line
print_by_cohort(students)
blank_line
print_footer(students)
=end

interactive_menu