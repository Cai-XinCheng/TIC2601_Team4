CREATE TABLE users (
  user_id INT PRIMARY KEY,
  name VARCHAR NOT NULL,
  password VARCHAR(60) NOT NULL, 
  reputation INT DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE posts (
  post_id INT PRIMARY KEY,
  user_id INT NOT NULL REFERENCES users(user_id),
  header VARCHAR(255),
  contents VARCHAR,
  is_comment TINYINT NOT NULL,
  update_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE is_comment_of (
  parent INT NOT NULL REFERENCES posts(post_id),
  child INT NOT NULL REFERENCES posts(post_id),
  PRIMARY KEY (parent, child)
);

CREATE TABLE votes (
  user_id INT NOT NULL REFERENCES users(user_id),
  post_id INT NOT NULL REFERENCES posts(post_id),
  is_upvote TINYINT NOT NULL,
  PRIMARY KEY (user_id, post_id)
  last_updated DATETIME
);
