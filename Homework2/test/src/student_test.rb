require 'minitest/autorun'
require_relative '../../lib/student'


class StudentTest < Minitest::Test
  def setup
    @valid_date = '2000-01-01'
    @student = Student.new('Dumchik', 'Petro', @valid_date)
  end


  def test_initialize
    assert_equal 'Dumchik', @student.surname
    assert_equal 'Petro', @student.name
    assert_equal Date.parse(@valid_date), @student.date_of_birth
  end


  def test_age_calculation
    today = Date.today

    expected_age = today.year - Date.parse(@valid_date).year
    expected_age -= 1 if today < Date.new(today.year, 1, 1)

    assert_equal expected_age, @student.age
  end


  def test_equality
    same_student = Student.new('Dumchik', 'Petro', @valid_date)
    different_student = Student.new('Nikolaev', 'Vasil', '1999-12-31')

    assert @student.eql?(same_student)
    refute @student.eql?(different_student)
  end


  def test_hash
    same_student = Student.new('Dumchik', 'Petro', @valid_date)
    different_student = Student.new('Nikolaev', 'Vasil', '1999-12-31')

    assert_equal @student.hash, same_student.hash
    refute_equal @student.hash, different_student.hash
  end


  def test_invalid_date_format
    assert_raises(ArgumentError) { Student.new('Dumchik', 'Petro', '01/01/2000') }
  end


  def test_future_date
    future_date = (Date.today + 1).to_s
    assert_raises(ArgumentError) { Student.new('Dumchik', 'Petro', future_date) }
  end


  def test_edge_case_age
    student_born_today = Student.new('Born', 'Today', Date.today.to_s)
    assert_equal 0, student_born_today.age
    
    student_born_yesterday = Student.new('Born', 'Yesterday', (Date.today - 1).to_s)
    assert_equal 0, student_born_yesterday.age
    
    student_born_last_year = Student.new('Born', 'LastYear', (Date.today.prev_year).to_s)
    assert_equal 1, student_born_last_year.age
  end


  def test_birthdate_on_leap_year
    leap_year_student = Student.new('Leap', 'year', '2000-02-29')
    assert_equal 24, leap_year_student.age
  end


  def test_birthdate_on_boundary
    boundary_student = Student.new('Zhuravel', 'Oleksandr', '2000-12-31')
    assert_equal 23, boundary_student.age
  end
end
