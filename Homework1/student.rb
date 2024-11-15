require 'set'
require 'date'

class Student
  attr_reader :surname, :name, :date_of_birth
  @@unique_students = Set.new


  public

  def initialize(surname, name, date_of_birth)
    @surname = surname
    @name = name
    @date_of_birth = parse_date(date_of_birth)
    
    self.class.add_student(self)
  end


  def self.add_student(student)
    if !@@unique_students.add?(student)
      raise ArgumentError, 'A student already exists'
    end
  end


  def self.remove_student(student)
    if !@@unique_students.delete?(student)
      raise ArgumentError, 'A student was not found'
    end
  end


  def self.get_students_by_age(age)
    result = []
    
    for student in @@unique_students
      if calculate_age(student) == age
        result << student
      end
    end
    
    result
  end


  def self.get_students_by_name(name)
    result = []
  
    for student in @@unique_students
      if student.name == name
        result << student
      end
    end

    result
  end


  def self.calculate_age(student)
    today = Date.today
    age = today.year - student.date_of_birth["year"]

    if today < Date.new(student.date_of_birth["year"], student.date_of_birth["month"], student.date_of_birth["day"])
      age -= 1
    end

    age
  end


  def eql?(other)
    surname == other.surname && name == other.name && date_of_birth == other.date_of_birth
  end


  def hash
    [surname, name, date_of_birth].hash
  end



  private

  def parse_date(date_str)
    parts = date_str.split('-')
    
    if parts.size != 3
      raise ArgumentError, 'Invalid date format dd-mm-yyyy'
    end
    
    day = parts[0].to_i
    month = parts[1].to_i
    year = parts[2].to_i

    if date_in_past?(day, month, year)
        {"day" => day, "month" => month, "year" => year}
    else
        raise ArgumentError, 'Invalid date'
    end
  end


  def days_count_in_month(month, year)
    if year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
      days_count_in_february = 29
    else
      days_count_in_february = 28
    end
    
    days_per_month = [31, days_count_in_february, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    days_per_month[month - 1]   # counting starts from 0
  end


  def date_in_past?(day, month, year)
    raise ArgumentError, 'Day is invalid' if day < 1 || day > days_count_in_month(month, year)
    raise ArgumentError, 'Month is invalid' if month < 1 || month > 12
    raise ArgumentError, 'Year is invalid' if year > Date.today.year

    true
  end
end