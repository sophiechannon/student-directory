def input_students
  students = []

  while true do
    puts "Enter next student name or press return twice to exit"
    name = gets.chomp.split(" ").map!{|x| x.capitalize}.join(" ")
    break if name.empty?

    puts "Please enter their gender (M/F/NB)"
    gender = gets.chomp.upcase
    if gender == "M"
      gender = :male
    elsif gender == "F"
      gender = :female
    else
      gender = :neutral
    end

    puts "Please enter #{$pronoun[gender][:possessive]} height in cm"
    height = gets.chomp.to_i

    puts "Please enter #{$pronoun[gender][:possessive]} hobbies, press return twice when done"
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

$pronoun = {
  male: {subject: "he", verb: "is", possessive: "his"},
  female: {subject: "she", verb: "is", possessive: "her"},
  neutral: {subject: "they", verb: "are", possessive: "their"}
}

def print_students(names)
  names.each_with_index do |student, index| 
    gender = student[:gender]
    puts "#{index + 1}. #{student[:name]} (#{student[:cohort]} cohort)"
    puts "#{$pronoun[gender][:subject].capitalize} #{$pronoun[gender][:verb]} #{student[:height]}cm tall and #{$pronoun[gender][:possessive]} hobbies are"
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