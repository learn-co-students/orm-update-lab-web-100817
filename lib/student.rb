require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade, :id #correct

  def initialize(id=nil, name, grade) #working
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table #working
    sql = <<-SQL
    CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table #working
    sql = <<-SQL
    DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(sql)
  end

  def update #correct code?!
   sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
   DB[:conn].execute(sql, self.name, self.grade, self.id)
 end


  def save #working
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end #DONT FORGET TO ASSIGN AN ID!!!!
  end

  def self.create(name, grade)
     student = Student.new(name, grade)
     student.save
   end

  def self.new_from_db(row) #working
    id = row[0]
    name = row[1]
    grade = row[2]
    self.new(id, name, grade)
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
    SQL
    row = DB[:conn].execute(sql, name).map do |db_row|
      self.new_from_db(db_row)
    end
    row[0]
  end


end
