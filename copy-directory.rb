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

    puts "Which cohort #{$pronoun[gender][:verb]} #{$pronoun[gender][:subject]} on?"
    months = [:January, :February, :March, :April, :May, :June, :July, :August, :September, :October, :November, :December]
    while true do
      cohort = gets.chomp.capitalize.to_sym
      cohort = :November if cohort.empty?
      break if months.any? {|month| month == cohort}
    end

    puts "Please enter #{$pronoun[gender][:possessive]} height in cm"
    height = gets.chomp.to_i

    puts "Please enter #{$pronoun[gender][:possessive]} hobbies, press return twice when done"
    hobbies = []
    while true do
      input = gets.chomp.downcase
      !input.empty? ? hobbies << input : break
    end

    students << {name: name, cohort: cohort, gender: gender, height: height, hobbies: hobbies }
    text = "Now we have #{students.count} student"
    puts students.count > 1 ? "#{text}s" : text
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
    if student[:height] > 0
      puts " - #{$pronoun[gender][:subject].capitalize} #{$pronoun[gender][:verb]} #{student[:height]}cm tall"
    end
    if student[:hobbies] != []
      puts " - #{$pronoun[gender][:possessive]} hobbies are #{student[:hobbies].join(", ")}."
    end
  end
end

def print_by_cohort(names)
  puts "Which cohort would you like to see?"
    months = [:January, :February, :March, :April, :May, :June, :July, :August, :September, :October, :November, :December]
    while true do
      cohort = gets.chomp.capitalize.to_sym
      break if months.any? {|month| month == cohort}
    end
  result = names.select { |student| student[:cohort] == cohort }
  result.each { |student| puts student[:name] }
end

def print_by_cohort_all(names)
  cohorts = {}
  names.each do |student|
    cohort = student[:cohort]
    cohorts[cohort] = [] if cohorts[cohort] == nil
    cohorts[cohort] << student[:name]
  end
  cohorts.each do |key, value|
    puts key.to_s.center(20)
    puts value
    puts nil
  end
end

def print_header
  puts "The students of Villains Academy".center(50)
  puts "-------------".center(50)
end

def print_footer(names)
  text =  "Overall, we have #{names.count} great student."
  puts names.count > 1 ? text.insert(-2, "s") : text
end

def blank_line
  puts ""
end

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