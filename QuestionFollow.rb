require_relative 'QuestionsDatabase'

class QuestionFollow
  attr_accessor :id, :question_id, :user_id

  def self.all
    data = QuestionsDBConnection.instance.execute("SELECT * FROM question_follows")
    data.map { |datum| Users.new(datum)}
  end

  def self.followers_for_question_id(question_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      users
    JOIN
      question_follows ON question_follows.user_id = users.id
    WHERE
      question_follows.question_id = ?;
    SQL
  end

  def self.followed_questions_for_user_id(user_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
    SELECT
      *
    FROM
      questions
    JOIN
      question_follows ON question_follows.question_id = questions.id
    WHERE
      question_follows.user_id = ?;
    SQL
  end

  def self.most_followed_questions(n)
    data = QuestionsDBConnection.instance.execute(<<-SQL, n)
    SELECT
      questions.title, COUNT(title)
    FROM
      questions
    JOIN
      question_follows ON question_follows.question_id = questions.id 
    GROUP BY
      title
    LIMIT 
      ?
    SQL
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

  

  


end