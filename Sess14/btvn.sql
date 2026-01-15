DROP DATABASE IF EXISTS social_network;
CREATE DATABASE social_network;
USE social_network;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY, 
    username VARCHAR(50) NOT NULL,        
    posts_count INT DEFAULT 0            
);

CREATE TABLE posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_posts_users
        FOREIGN KEY (user_id) REFERENCES users(user_id)
);

INSERT INTO users (username) VALUES
('alice'),
('bob');

START TRANSACTION;

INSERT INTO posts (user_id, content)
VALUES (1, 'Bai viet dau tien cua Alice');

UPDATE users
SET posts_count = posts_count + 1
WHERE user_id = 1;

COMMIT;

SELECT * FROM posts;
SELECT * FROM users;

START TRANSACTION;

INSERT INTO posts (user_id, content)
VALUES (999, 'Bai viet nay se loi');

UPDATE users
SET posts_count = posts_count + 1
WHERE user_id = 999;

ROLLBACK;

SELECT * FROM posts;
SELECT * FROM users;

-- Bài 2
USE social_network;

ALTER TABLE posts
ADD COLUMN likes_count INT DEFAULT 0;

CREATE TABLE likes (
    like_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    CONSTRAINT fk_likes_posts
        FOREIGN KEY (post_id) REFERENCES posts(post_id),
    CONSTRAINT fk_likes_users
        FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT unique_like UNIQUE (post_id, user_id)
);

START TRANSACTION;

INSERT INTO likes (post_id, user_id)
VALUES (1, 1);

UPDATE posts
SET likes_count = likes_count + 1
WHERE post_id = 1;

COMMIT;

SELECT * FROM likes;
SELECT post_id, likes_count FROM posts WHERE post_id = 1;

START TRANSACTION;

	INSERT INTO likes (post_id, user_id)
VALUES (1, 1);

UPDATE posts
SET likes_count = likes_count + 1
WHERE post_id = 1;

ROLLBACK;

SELECT * FROM likes;
SELECT post_id, likes_count FROM posts WHERE post_id = 1;

-- Bài 3
USE social_network;

ALTER TABLE users
ADD COLUMN following_count INT DEFAULT 0,
ADD COLUMN followers_count INT DEFAULT 0;

CREATE TABLE followers (
    follower_id INT NOT NULL,
    followed_id INT NOT NULL,
    PRIMARY KEY (follower_id, followed_id),
    CONSTRAINT fk_follower_user
        FOREIGN KEY (follower_id) REFERENCES users(user_id),
    CONSTRAINT fk_followed_user
        FOREIGN KEY (followed_id) REFERENCES users(user_id)
);

CREATE TABLE follow_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    follower_id INT,
    followed_id INT,
    error_message VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE PROCEDURE sp_follow_user(
    IN p_follower_id INT,
    IN p_followed_id INT
)
BEGIN
    DECLARE v_count INT DEFAULT 0;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_count
    FROM users
    WHERE user_id = p_follower_id;

    IF v_count = 0 THEN
        INSERT INTO follow_log(follower_id, followed_id, error_message)
        VALUES (p_follower_id, p_followed_id, 'Follower không tồn tại');
        ROLLBACK;
        LEAVE proc_end;
    END IF;

    SELECT COUNT(*) INTO v_count
    FROM users
    WHERE user_id = p_followed_id;

    IF v_count = 0 THEN
        INSERT INTO follow_log(follower_id, followed_id, error_message)
        VALUES (p_follower_id, p_followed_id, 'Followed user không tồn tại');
        ROLLBACK;
        LEAVE proc_end;
    END IF;

    IF p_follower_id = p_followed_id THEN
        INSERT INTO follow_log(follower_id, followed_id, error_message)
        VALUES (p_follower_id, p_followed_id, 'Không thể tự follow chính mình');
        ROLLBACK;
        LEAVE proc_end;
    END IF;

    SELECT COUNT(*) INTO v_count
    FROM followers
    WHERE follower_id = p_follower_id
      AND followed_id = p_followed_id;

    IF v_count > 0 THEN
        INSERT INTO follow_log(follower_id, followed_id, error_message)
        VALUES (p_follower_id, p_followed_id, 'Đã follow trước đó');
        ROLLBACK;
        LEAVE proc_end;
    END IF;

    INSERT INTO followers(follower_id, followed_id)
    VALUES (p_follower_id, p_followed_id);

    UPDATE users
    SET following_count = following_count + 1
    WHERE user_id = p_follower_id;

    UPDATE users
    SET followers_count = followers_count + 1
    WHERE user_id = p_followed_id;

    COMMIT;

    proc_end: BEGIN END;

END$$

DELIMITER ;

CALL sp_follow_user(1, 2);
CALL sp_follow_user(1, 2);
CALL sp_follow_user(1, 1);
CALL sp_follow_user(999, 1);

SELECT * FROM followers;
SELECT user_id, following_count, followers_count FROM users;
SELECT * FROM follow_log;


-- Bai 4
USE social_network;

ALTER TABLE users
ADD COLUMN following_count INT DEFAULT 0,
ADD COLUMN followers_count INT DEFAULT 0;

CREATE TABLE followers (
    follower_id INT NOT NULL,
    followed_id INT NOT NULL,
    PRIMARY KEY (follower_id, followed_id),
    CONSTRAINT fk_follower_user
        FOREIGN KEY (follower_id) REFERENCES users(user_id),
    CONSTRAINT fk_followed_user
        FOREIGN KEY (followed_id) REFERENCES users(user_id)
);

CREATE TABLE follow_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    follower_id INT,
    followed_id INT,
    error_message VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE PROCEDURE sp_follow_user(
    IN p_follower_id INT,
    IN p_followed_id INT
)
BEGIN
    DECLARE v_count INT DEFAULT 0;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_count
    FROM users
    WHERE user_id = p_follower_id;

    IF v_count = 0 THEN
        INSERT INTO follow_log(follower_id, followed_id, error_message)
        VALUES (p_follower_id, p_followed_id, 'Follower không tồn tại');
        ROLLBACK;
        LEAVE proc_end;
    END IF;

    SELECT COUNT(*) INTO v_count
    FROM users
    WHERE user_id = p_followed_id;

    IF v_count = 0 THEN
        INSERT INTO follow_log(follower_id, followed_id, error_message)
        VALUES (p_follower_id, p_followed_id, 'Followed user không tồn tại');
        ROLLBACK;
        LEAVE proc_end;
    END IF;

    IF p_follower_id = p_followed_id THEN
        INSERT INTO follow_log(follower_id, followed_id, error_message)
        VALUES (p_follower_id, p_followed_id, 'Không thể tự follow chính mình');
        ROLLBACK;
        LEAVE proc_end;
    END IF;

    SELECT COUNT(*) INTO v_count
    FROM followers
    WHERE follower_id = p_follower_id
      AND followed_id = p_followed_id;

    IF v_count > 0 THEN
        INSERT INTO follow_log(follower_id, followed_id, error_message)
        VALUES (p_follower_id, p_followed_id, 'Đã follow trước đó');
        ROLLBACK;
        LEAVE proc_end;
    END IF;

    INSERT INTO followers(follower_id, followed_id)
    VALUES (p_follower_id, p_followed_id);

    UPDATE users
    SET following_count = following_count + 1
    WHERE user_id = p_follower_id;

    UPDATE users
    SET followers_count = followers_count + 1
    WHERE user_id = p_followed_id;

    COMMIT;

    proc_end: BEGIN END;

END$$

DELIMITER ;

CALL sp_follow_user(1, 2);
CALL sp_follow_user(1, 2);
CALL sp_follow_user(1, 1);
CALL sp_follow_user(999, 1);

SELECT * FROM followers;
SELECT user_id, following_count, followers_count FROM users;
SELECT * FROM follow_log;

USE social_network;

ALTER TABLE posts
ADD COLUMN comments_count INT DEFAULT 0;

CREATE TABLE comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_comment_post
        FOREIGN KEY (post_id) REFERENCES posts(post_id),
    CONSTRAINT fk_comment_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
);

DELIMITER $$

CREATE PROCEDURE sp_post_comment(
    IN p_post_id INT,
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO comments(post_id, user_id, content)
    VALUES (p_post_id, p_user_id, p_content);

    SAVEPOINT after_insert;

    UPDATE posts
    SET comments_count = comments_count + 1
    WHERE post_id = p_post_id;

    IF ROW_COUNT() = 0 THEN
        ROLLBACK TO after_insert;
        COMMIT;
    ELSE
        COMMIT;
    END IF;

END$$

DELIMITER ;

CALL sp_post_comment(1, 1, 'Bình luận hợp lệ, mọi thứ đều ổn');
CALL sp_post_comment(999, 1, 'Bình luận này sẽ bị rollback phần update');
SELECT * FROM comments;
SELECT post_id, comments_count FROM posts;
