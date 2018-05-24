DROP TABLE IF EXISTS comment_stars;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS posts;

DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id int PRIMARY KEY AUTO_INCREMENT,
  username varchar (50) UNIQUE NOT NULL,
  password varchar (50) NOT NULL,
  email varchar (355) UNIQUE NOT NULL COMMENT 'ex. user@example.com',
  created timestamp NOT NULL,
  updated timestamp
) COMMENT = 'Users table';

CREATE TABLE posts (
  id bigint AUTO_INCREMENT,
  user_id int NOT NULL,
  title varchar (255) NOT NULL,
  body text NOT NULL,
  post_type enum('public', 'private', 'draft')  NOT NULL COMMENT 'public/private/draft',
  created datetime NOT NULL,
  updated datetime,
  CONSTRAINT posts_id_pk PRIMARY KEY(id),
  CONSTRAINT posts_user_id_fk FOREIGN KEY(user_id) REFERENCES users(id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE CASCADE,
  UNIQUE(user_id, title)
) COMMENT = 'Posts table';
CREATE INDEX posts_user_id_idx ON posts(id) USING BTREE;

CREATE TABLE comments (
  id bigint AUTO_INCREMENT,
  post_id bigint NOT NULL,
  user_id int NOT NULL,
  comment text NOT NULL,
  created datetime NOT NULL,
  updated datetime,
  CONSTRAINT comments_id_pk PRIMARY KEY(id),
  CONSTRAINT comments_post_id_fk FOREIGN KEY(post_id) REFERENCES posts(id) MATCH SIMPLE,
  CONSTRAINT comments_user_id_fk FOREIGN KEY(user_id) REFERENCES users(id) MATCH SIMPLE,
  UNIQUE(post_id, user_id)
);
CREATE INDEX comments_post_id_user_id_idx ON comments(post_id, user_id) USING HASH;

CREATE TABLE comment_stars (
  id bigint AUTO_INCREMENT,
  user_id int NOT NULL,
  comment_post_id bigint NOT NULL,
  comment_user_id int NOT NULL,
  created timestamp NOT NULL,
  updated timestamp,
  CONSTRAINT comment_stars_id_pk PRIMARY KEY(id),
  CONSTRAINT comment_stars_user_id_post_id_fk FOREIGN KEY(comment_post_id, comment_user_id) REFERENCES comments(post_id, user_id) MATCH SIMPLE,
  CONSTRAINT comment_stars_user_id_fk FOREIGN KEY(comment_user_id) REFERENCES users(id) MATCH SIMPLE,
  UNIQUE(user_id, comment_post_id, comment_user_id)
);
