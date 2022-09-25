-- snp Verison 1.0
-- 

CREATE DATABASE IF NOT EXISTS snp;
USE snp;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  username VARCHAR(20) PRIMARY KEY,
  password VARCHAR(64) NOT NULL,
  #reputation INT DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP()
);

DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
  postId INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(20) REFERENCES users(username) ON DELETE CASCADE ON UPDATE CASCADE,
  header VARCHAR(255) NOT NULL,
  contents VARCHAR(16000)
  
  #reputation INT DEFAULT 0,
  #is_comment TINYINT(1) NOT NULL,
  #update_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  #created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  #CHECK(is_comment = 1 OR is_comment = 0)
);






--For SQLite
CREATE TABLE users (
  user_id INT PRIMARY KEY,
  name VARCHAR(20) NOT NULL,
  password VARCHAR(64) NOT NULL, 
  reputation INT DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE posts (
  post_id INT PRIMARY KEY,
  user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
  header VARCHAR(255),
  contents VARCHAR(256),
  is_comment TINYINT(1) NOT NULL,
  update_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CHECK(is_comment = 1 OR is_comment = 0)
);

CREATE TABLE is_comment_of (
  parent INT NOT NULL REFERENCES posts(post_id) ON DELETE CASCADE ON UPDATE CASCADE,
  child INT NOT NULL REFERENCES posts(post_id) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (parent, child)
);

CREATE TABLE votes (
  user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
  post_id INT NOT NULL REFERENCES posts(post_id) ON DELETE CASCADE ON UPDATE CASCADE,
  is_upvote TINYINT(1) NOT NULL,
  update_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, post_id),
  CHECK(is_upvote = 1 OR is_upvote = 0)
);

--For MySQL
