require_relative 'QuestionsDatabase.rb'
require_relative 'Questions.rb'

class Replies 
  attr_accessor :id, :body, :question_id, :user_id, :parent_id

  def self.insert
    raise "#{self} already in database" if self.id
    QuestionsDBConnection.instance.execute(<<-SQL, self.body, self.question_id, self.user_id, self.parent_id)
      INSERT INTO
        Replies (body, question_id, user_id, parent_id)
      VALUES
        (?, ?, ?, ?)
    SQL
    self.id = QuestionsDBConnection.instance.last_insert_row_id
  end

  def self.all 
    data = QuestionsDBConnection.instance.execute("SELECT * FROM replies")
    data.map { |datum| Replies.new(datum)}
  end
  
  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM 
        replies
      WHERE
        id = ?
    SQL

    return nil if data.empty?
    Replies.new(*data)
  end

  def self.find_by_user_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM 
        replies
      WHERE
        user_id = ?
    SQL

    return nil if data.empty?
    Replies.new(*data)
  end

  def self.find_by_question_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM 
        replies
      WHERE
        question_id = ?
    SQL

    return nil if data.empty?
    Replies.new(*data)
  end

  def self.find_by_parent_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM 
        replies
      WHERE
        parent_id = ?
    SQL

    return nil if data.empty?
    Replies.new(*data)
  end

  def initialize(options)
    @id = options['id']
    @body = options['body']
    @question_id = options['question_id']
    @user_id = options['user_id']
    @parent_id = options['parent_id']
  end
  
  def author
    Users.find_by_id(self.user_id)
  end

  def question
    Questions.find_by_id(self.question_id)
  end

  def parent_reply 
    Replies.find_by_id(self.parent_id)
  end

  def child_replies
    Replies.find_by_parent_id(self.id)
  end
end