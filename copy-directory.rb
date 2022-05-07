def input_students
  puts "Please enter the names of the students"
  puts "To finish, just hit return twice"

  students = []

  name = gets.chomp.capitalize

  while !name.empty? do
    students << {name: name, cohort: :november}
    puts "Now we have #{students.count} students"
    name = gets.chomp.capitalize
  end

  students
end

def print_header
  puts "The students of Villains Academy"
  puts "-------------"
end

def print_students(names)
  counter = 0
  while counter < names.count
    puts "#{counter + 1}. #{names[counter][:name]} (#{names[counter][:cohort]} cohort)"
    counter += 1
  end
end

def print_footer(names)
  puts "Overall, we have #{names.count} great students"
end

students = input_students
puts students
print_header
print_students(students)
print_footer(students)

=begin
def print(students)
  students.each_with_index do |student, index| 
    if student[:name].length < 12
      puts "#{index + 1}. #{student[:name]} (#{student[:cohort]} cohort)"
    end
  end
end
=end