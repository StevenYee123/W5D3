require 'sqlite3'
require 'singleton'

require_relative 'Questions'
require_relative 'Replies'
require_relative 'QuestionFollow'


class QuestionsDBConnection < SQLite3::Database 
  include Singleton 

  def initialize 
    super('questions.db')
    self.type_translation = true 
    self.results_as_hash = true     
  end
end

class Users
  attr_accessor :id, :fname, :lname 
  
  def self.all 
    data = QuestionsDBConnection.instance.execute("SELECT * FROM users")
    data.map { |datum| Users.new(datum)}
  end

  def self.find_by_id(num)
    data = QuestionsDBConnection.instance.execute(<<-SQL, num)
      SELECT
        *
      FROM 
        Users
      WHERE
        id = ?
    SQL
    return nil if data.empty?
    
    Users.new(data.first)
  end

  def self.find_by_name(fname, lname)
    data = QuestionsDBConnection.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM 
        Users
      WHERE
        fname = ? AND lname = ?
    SQL
    return nil if data.empty?
    
    Users.new(data.first)
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_questions 
    # data = QuestionsDBConnection.instance.execute(<<-SQL)
    #   SELECT
    #     id 
    #   FROM
    #     Users
    # SQL
    # return nil if data.empty?
    # data.map! { |ele| ele['id']}
    # data.map { |ele| Questions.find_by_author_id(ele)}

    Questions.find_by_author_id(self.id)
  end

  def authored_replies
      data = QuestionsDBConnection.instance.execute(<<-SQL)
      SELECT
        id 
      FROM
        Users
    SQL
    return nil if data.empty?
    data.map! { |ele| ele['id']}
    data.map { |ele| Replies.find_by_user_id(ele)}
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(self.id)
  end

end


 