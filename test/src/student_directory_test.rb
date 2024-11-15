require 'minitest/autorun'
require_relative '../../lib/student'
require_relative '../../lib/student_directory'


class StudentDirectoryTest < Minitest::Test
  def setup
    @student1 = Student.new('Dumchik', 'Petro', '2000-01-01')
    @student2 = Student.new('Nikolaev', 'Vasil', '1999-12-31')
    @student3 = Student.new('Kovalenko', 'Mykola', '2001-05-20')
    
    @directory = StudentDirectory.new
  end


  def teardown
    @directory.clear
  end


  def test_add
    @directory.add(@student1)
    assert_includes @directory.instance_variable_get(:@students), @student1
  end


  def test_add_duplicate_student
    @directory.add(@student1)
    assert_raises(ArgumentError) { @directory.add(@student1) }
  end


  def test_remove
    @directory.add(@student1)
    @directory.remove(@student1)
    refute_includes @directory.instance_variable_get(:@students), @student1
  end


  def test_remove_non_existent_student
    assert_raises(ArgumentError) { @directory.remove(@student1) }
  end


  def test_get_students_by_age
    @directory.add(@student1)
    @directory.add(@student2)
    @directory.add(@student3)

    assert_equal [@student1, @student2], @directory.get_students_by_age(24)
    assert_equal [@student3], @directory.get_students_by_age(23)
    assert_empty @directory.get_students_by_age(20)
  end


  def test_get_students_by_name
    @directory.add(@student1)
    @directory.add(@student2)

    assert_equal [@student1], @directory.get_students_by_name('Petro')
    assert_equal [@student2], @directory.get_students_by_name('Vasil')
    assert_empty @directory.get_students_by_name('Oleksandr')
  end


  def test_get_students_by_age_no_students
    assert_empty @directory.get_students_by_age(30)
  end
  

  def test_get_students_by_name_no_students
    assert_empty @directory.get_students_by_name('Unknown')
  end
end
