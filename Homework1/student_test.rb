require_relative 'student'

def test_student_initialization
  student = Student.new("Zhuravel", "Oleksandr", "06-07-2006")
  
  raise "Test failed: Incorrect surname" if !student.surname == "Zhuravel"
  raise "Test failed: Incorrect name" if !student.name == "Oleksandr"
  raise "Test failed: Incorrect date_of_birth" if student.date_of_birth != {"day" => 6, "month" => 7, "year" => 2006}
  
  puts "test_student_initialization \tpassed"
end


def test_invalid_date_format
  Student.class_variable_get(:@@unique_students).clear

  begin
    Student.new("Zhuravel", "Oleksandr", "06/07/2006")
    raise "Test failed: No error raised for invalid date format"
  rescue ArgumentError => ex
    raise "Test failed: Incorrect error message" if ex.message != 'Invalid date format dd-mm-yyyy'
  end
  
  puts "test_invalid_date_format \tpassed"
end


def test_future_date_of_birth
  Student.class_variable_get(:@@unique_students).clear

  begin
    Student.new("Zhuravel", "Oleksandr", "06-07-2025")
    raise "Test failed: No error raised for future date of birth"
  rescue ArgumentError => ex
    raise "Test failed: Incorrect error message" if ex.message != 'Year is invalid'
  end
  
  puts "test_future_date_of_birth \tpassed"
end


def test_add_student
  Student.class_variable_get(:@@unique_students).clear

  student1 = Student.new("Zhuravel", "Oleksandr", "06-07-2024")
  raise "Test failed: Unique student not added" if Student.class_variable_get(:@@unique_students).size != 1
  
  begin
    Student.new("Zhuravel", "Oleksandr", "06-07-2024")
    raise "Test failed: No error raised for duplicate student"
  rescue ArgumentError => ex
    raise "Test failed: Incorrect error message" if ex.message != 'A student already exists'
  end
  
  puts "test_add_student \t\tpassed"
end


def test_remove_student
  Student.class_variable_get(:@@unique_students).clear

  student = Student.new("Zhuravel", "Oleksandr", "06-07-2006")
  Student.remove_student(student)

  raise "Test failed: Student not removed" if Student.class_variable_get(:@@unique_students).size != 0
  
  begin
    Student.remove_student(student)
    raise "Test failed: No error raised for removing non-existing student"
  rescue ArgumentError => ex
    raise "Test failed: Incorrect error message" if ex.message != 'A student was not found'
  end
  
  puts "test_remove_student \t\tpassed"
end


def test_calculate_age
  Student.class_variable_get(:@@unique_students).clear

  student = Student.new("Zhuravel", "Oleksandr", "06-07-2006")
  expected_age = Date.today.year - 2006
  raise "Test failed: Incorrect age calculation" if Student.calculate_age(student) != expected_age
  
  puts "test_calculate_age \t\tpassed"
end


def test_get_students_by_age
  Student.class_variable_get(:@@unique_students).clear

  student = Student.new("Zhuravel", "Oleksandr", "06-07-2006")
  age = Date.today.year - 2006
  raise "Test failed: Incorrect students by age" if !Student.get_students_by_age(age).include?(student)
  
  puts "test_get_students_by_age \tpassed"
end


def test_get_students_by_name
  Student.class_variable_get(:@@unique_students).clear

  student = Student.new("Zhuravel", "Oleksandr", "06-07-2006")
  raise "Test failed: Incorrect students by name" if !Student.get_students_by_name("Oleksandr").include?(student)
  
  puts "test_get_students_by_name \tpassed"
end


test_student_initialization
test_invalid_date_format
test_future_date_of_birth
test_add_student
test_remove_student
test_calculate_age
test_get_students_by_age
test_get_students_by_name


puts "\n\tAll tests passed!"