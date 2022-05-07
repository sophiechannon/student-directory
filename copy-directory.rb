def input_students
  students = []

  while true do
    puts "Enter next student name or press return twice to exit"
    name = gets.chomp.capitalize
    break if name.empty?
    puts "Please enter their gender (M/F/NB)"
    gender = gets.chomp.upcase
    puts "Please enter the student's height in cm"
    height = gets.chomp.to_i
    puts "Please enter their hobbies"
    hobbies = []
    while true do
      input = gets.chomp.downcase
      !input.empty? ? hobbies << input : break
    end
    students << {name: name, cohort: :November, gender: gender, height: height, hobbies: hobbies }
    puts "Now we have #{students.count} students"
  end

  students
end

def print_students(names)
  names.each_with_index do |student, index| 
    subject_pronoun = ""
    being_verb = "is"
    possessive_pronoun = ""
    case student[:gender] 
    when "M"
      subject_pronoun = "he"
      possessive_pronoun = "his"
    when "F"
      subject_pronoun = "she"
      possessive_pronoun = "her"
    else
      subject_pronoun = "they"
      being_verb = "are"
      possessive_pronoun = "their"
    end

    puts "#{index + 1}. #{student[:name]} (#{student[:cohort]} cohort)"
    puts "#{subject_pronoun.capitalize} #{being_verb} #{student[:height]}cm tall and #{possessive_pronoun} hobbies are"
    puts "#{student[:hobbies].join(", ")}."
  end
end

def print_header
  puts "The students of Villains Academy".center(50)
  puts "-------------".center(50)
end

def print_footer(names)
  puts "Overall, we have #{names.count} great students"
end

def blank_line
  puts ""
end

students = input_students
print_header
blank_line
print_students(students)
blank_line
print_footer(students)