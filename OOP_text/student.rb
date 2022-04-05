class Student
  attr_accessor :name

  def initialize(name, grade)
    self.name = name
    @grade = grade
  end

  def better_grade_than?(other_name)
    self.grade > other_name.grade
  end

  protected

  def grade
    @grade
  end
end

troy = Student.new('Troy', 98)
james = Student.new('James', 80)
puts "Troy scores higher!" if troy.better_grade_than?(james)
