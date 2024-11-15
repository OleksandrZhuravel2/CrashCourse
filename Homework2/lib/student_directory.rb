require 'set'

class StudentDirectory
  def initialize
    @students = Set.new
  end


  def add(student)
    if !@students.add?(student)
      raise ArgumentError, 'A student already exists'
    end
  end


  def remove(student)
    if !@students.delete?(student)
      raise ArgumentError, 'A student was not found'
    end
  end


  def get_students_by_age(age)
    @students.select { |student| student.age == age }
  end


  def get_students_by_name(name)
    @students.select { |student| student.name == name }
  end


  def clear
    @students.clear
  end
end