require_relative 'QuestionsDatabase'
require_relative 'Replies'
require_relative 'QuestionFollow'

class Questions
  attr_accessor :id, :title, :body, :author_id

  def self.all 
    data = QuestionsDBConnection.instance.execute("SELECT * FROM questions")
    data.map { |datum| Questions.new(datum)}
  end

  def self.find_by_id(num)
    data = QuestionsDBConnection.instance.execute(<<-SQL, num)
      SELECT
        *
      FROM 
        Questions
      WHERE
        id = ?
    SQL
    return nil if data.empty?
    
    Questions.new(data.first)
  end

  def self.find_by_author_id(author_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        Questions
      WHERE
        author_id = ?
    SQL

    return nil if data.empty?
    Questions.new(data.first)
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def author
    data = QuestionsDBConnection.instance.execute(<<-SQL, self.author_id)
     SELECT
      fname, lname
     FROM
      Users     
     WHERE
      id = ?
    SQL
    return nil if data.empty?
    Users.new(data.first)
  end

  def replies
    data = QuestionsDBConnection.instance.execute(<<-SQL, self.id)
      SELECT
        id
      FROM
        Questions
      WHERE
        id = ?
    SQL
    return nil if data.empty?
    data.map! { |ele| ele['id']}
    data.map { |ele| Replies.find_by_question_id(ele)}
  end

  def followers
    QuestionFollow.followers_for_question_id(self.id)
  end


end
