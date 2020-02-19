PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS question_follows;

  CREATE TABLE question_follows(
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY(question_id) REFERENCES questions(id)
    FOREIGN KEY(user_id) REFERENCES users(id)
  );

DROP TABLE IF EXISTS replies;

  CREATE TABLE replies(
    id INTEGER PRIMARY KEY,
    body VARCHAR(255) NOT NULL,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    parent_id INTEGER,

    FOREIGN KEY(question_id) REFERENCES questions(id),
    FOREIGN KEY(parent_id) REFERENCES replies(id),
    FOREIGN KEY(user_id) REFERENCES users(id)
  );

DROP TABLE IF EXISTS question_likes;

  CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(question_id) REFERENCES questions(id)
  );

  DROP TABLE IF EXISTS questions;

  CREATE TABLE questions(
    id INTEGER PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY(author_id) REFERENCES users(id)
  );

DROP TABLE IF EXISTS users;

  CREATE TABLE users(
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
  );

  INSERT INTO
    users (fname, lname)
  VALUES 
    ('Bob', 'Dylan'), 
    ('Matt', 'Damon'),
    ('Heath', 'Ledger'),
    ('Banana', 'Man');
  
  INSERT INTO
    questions (title, body, author_id)
  VALUES
    ('Age', 'How old are you??', (SELECT id FROM users WHERE fname = 'Bob')),
    ('Whats Up', 'How is you day going?', (SELECT id FROM users WHERE fname = 'Matt')),
    ('Food', 'Whats your favorite food?', (SELECT id FROM users WHERE fname = 'Heath'));

  INSERT INTO
    replies (body, question_id, user_id)
  VALUES
    ('I am thirty-seven.', (SELECT id FROM questions WHERE title = 'Age'), (SELECT id FROM users WHERE fname = 'Banana')),
    ('My day is going fine.', (SELECT id FROM questions WHERE title = 'Whats Up'), (SELECT id FROM users WHERE fname = 'Bob')),
    ('I like hotdogs.', (SELECT id FROM questions WHERE title = 'Food'), (SELECT id FROM users WHERE fname = 'Heath'));

  INSERT INTO
    question_likes (question_id, user_id)
  VALUES
    ((SELECT id FROM questions WHERE title = 'Age'), (SELECT id FROM users WHERE fname = 'Banana')),
    ((SELECT id FROM questions WHERE title = 'Whats Up'), (SELECT id FROM users WHERE fname = 'Bob')),
    ((SELECT id FROM questions WHERE title = 'Food'), (SELECT id FROM users WHERE fname = 'Heath'));

  INSERT INTO
    question_follows (question_id, user_id)
  VALUES
    ((SELECT id FROM questions WHERE title = 'Age'), (SELECT id FROM users WHERE fname = 'Banana')),
    ((SELECT id FROM questions WHERE title = 'Whats Up'), (SELECT id FROM users WHERE fname = 'Bob')),
    ((SELECT id FROM questions WHERE title = 'Food'), (SELECT id FROM users WHERE fname = 'Heath'));

  --    CREATE TABLE question_follows(
  --   id INTEGER PRIMARY KEY,
  --   question_id INTEGER NOT NULL,
  --   user_id INTEGER NOT NULL,

  --   FOREIGN KEY(question_id) REFERENCES questions(id)
  --   FOREIGN KEY(user_id) REFERENCES users(id)
  -- );