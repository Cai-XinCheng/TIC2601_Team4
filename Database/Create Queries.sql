CREATE DATABASE IF NOT EXISTS rabbit;
USE rabbit;

DROP TABLE IF EXISTS user;
CREATE TABLE user (
  username VARCHAR(20) PRIMARY KEY,
  password VARCHAR(64) NOT NULL,
  email VARCHAR(35) NOT NULL UNIQUE,
  reputation INT NOT NULL DEFAULT 0,
  is_admin TINYINT(1) NOT NULL DEFAULT 0,
  is_blocked TINYINT(1) NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  check(length(username) >=3)
);

DROP TABLE IF EXISTS category;
CREATE TABLE category (
  category VARCHAR(45) NOT NULL PRIMARY KEY,
  reputation INT NOT NULL DEFAULT 0
);

/*
DROP TABLE IF EXISTS image;
CREATE TABLE image (
  image_id INT NOT NULL PRIMARY KEY,
  data BLOB NOT NULL
);
*/

DROP TABLE IF EXISTS data;
CREATE TABLE data (
  post_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(20) NOT NULL REFERENCES user(username) ON DELETE CASCADE ON UPDATE CASCADE,
  category VARCHAR(45) NOT NULL REFERENCES category(category) ON DELETE CASCADE ON UPDATE CASCADE,
  header VARCHAR(255) NOT NULL,
  content VARCHAR(16000),
  #image_id INT NOT NULL REFERENCES image(image_id) ON DELETE CASCADE ON UPDATE CASCADE,
  reputation INT NOT NULL DEFAULT 0,
  update_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP(),
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP()
);

DROP TABLE IF EXISTS subscribe;
CREATE TABLE subscribe (
  username VARCHAR(20) REFERENCES user(username) ON DELETE CASCADE,
  category VARCHAR(45) REFERENCES category(category) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (username, category)
);

DROP TABLE IF EXISTS vote;
CREATE TABLE vote (
  username VARCHAR(20) NOT NULL REFERENCES user(username) ON DELETE CASCADE ON UPDATE CASCADE,
  post_id INT NOT NULL REFERENCES data(post_id) ON DELETE CASCADE ON UPDATE CASCADE,
  is_upvote TINYINT(1) NOT NULL,
  update_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP(),
  PRIMARY KEY (username, post_id),
  CHECK(is_upvote = 1 OR is_upvote = 0)
);

DROP TABLE IF EXISTS post;
CREATE TABLE post (
  post_id INT NOT NULL REFERENCES data(post_id) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS is_comment_of;
CREATE TABLE is_comment_of (
  parent INT NOT NULL REFERENCES data(post_id) ON DELETE CASCADE ON UPDATE CASCADE,
  child INT NOT NULL REFERENCES data(post_id) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (parent, child)
);

TRUNCATE user;
INSERT INTO user (username, password, email) VALUES 
('Kelvin', '$2b$10$V4bx3onIgab/mvuIlkgAVOTlB/dzOCeGy7Q5GY6aeZUr.f/u3zy/y', 'Kelvin@rabbit.com'),
('James', '$2b$10$TRXpr7RpJn2jVs1EWAR9aOoEHElhee4PpOxIsJtbc2nCXSyVjnlmS','James@rabbit.com'),
('Robert', '$2b$10$wTudTtgk6FXR0rU.akBl3.luCzPDLtDnvc7o9YeQTdkfWK7xA.E0O', 'Robert@rabbit.com'),
('John', '$2b$10$WRXgM85h4Wy6iib9djz1duK8BynJ2SQYuod4UB9Tc9OPTakqh0eyi', 'John@rabbit.com');
INSERT INTO user (username, password, email, is_admin) VALUES 
('admin', '$2b$10$AWfAC5/7tx4Nk/uoSNYYgeL7lrZ6AM6KZZSW1AZDQbmzgrUUAPJBm', 'admin@rabbit.com', 1);
##admin Admin123

TRUNCATE category;
INSERT INTO category (category) VALUES
('test1'),
('test2'),
('test3'),
('test4'),
('test5');

TRUNCATE data;
INSERT INTO data (username, header, category, content) VALUES 
('Kelvin', 'TESTING1', 'test1', 'This is testing 1 contents'),
('James', 'TESTING2', 'test2', 'This is testing 2 contents'),
('Robert', 'TESTING3', 'test3', 'This is testing 3 contents'),
('John', 'TESTING4', 'test4', 'This is testing 4 contents'),
('James', 'TESTING5', 'test1', 'This is testing 5 contents'),
('John', 'TESTING6', 'test3', 'This is testing 6 contents'),
('John', 'TESTING7', 'test5', 'This is testing 7 contents'),
('James', 'TESTING5', 'test1', 'This is testing 5 reply'),
('Robert', 'TESTING3', 'test1', 'This is testing 6 reply'),
('John', 'TESTING4', 'test1', 'This is testing 7 reply');

INSERT INTO post (post_id) VALUES
(1),
(2),
(3),
(4);

INSERT INTO is_comment_of (parent, child) VALUES
(1, 5),
(1, 6),
(5, 7);

INSERT INTO vote (username, post_id, is_upvote) VALUES
('Kelvin', 1, 1),
('Kelvin', 5, 0);

UPDATE data SET reputation = 1 WHERE post_id = 1;
UPDATE data SET reputation = -1 WHERE post_id = 5;

INSERT INTO subscribe (username, category) VALUES
('Kelvin', 'test1'),
('Kelvin', 'test3'),
('James', 'test2'),
('James', 'test3'),
('James', 'test4');