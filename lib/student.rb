require 'date'

class Student
  public
  
  attr_reader :surname, :name, :date_of_birth

  def initialize(surname, name, date_of_birth_str)
    @surname = surname
    @name = name
    @date_of_birth = parse_date(date_of_birth_str)
  end


  def age
    today = Date.today
    age = today.year - date_of_birth.year
    age -= 1 if today.month < date_of_birth.month || (today.month == date_of_birth.month && today.day < date_of_birth.day)
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
    raise ArgumentError, 'Invalid date format (expected format: yyyy-mm-dd)' if parts.size != 3

    year, month, day = parts.map(&:to_i)
    input_date = Date.new(year, month, day)

    raise ArgumentError, 'Date is in the future' if input_date > Date.today

    input_date
  end
end
