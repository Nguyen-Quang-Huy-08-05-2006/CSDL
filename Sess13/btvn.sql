DROP DATABASE IF EXISTS trigger_social;
CREATE DATABASE trigger_social;
USE trigger_social;
 
-- Bài 1 PHẦN 1
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,  
    username VARCHAR(50) NOT NULL UNIQUE,         
    email VARCHAR(100) NOT NULL UNIQUE,         
    created_at DATE,                           
    follower_count INT DEFAULT 0,        
    post_count INT DEFAULT 0                     
);

CREATE TABLE posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,        
    user_id INT,                        
    created_at DATETIME,              
    like_count INT DEFAULT 0,                   
    CONSTRAINT fk_posts_users
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE                   
);

-- Bài 2 PHẦN 1
CREATE TABLE likes (
    like_id INT AUTO_INCREMENT PRIMARY KEY,  
    post_id INT,                             
    liked_at DATETIME DEFAULT CURRENT_TIMESTAMP,    
    CONSTRAINT fk_likes_users
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE,                   
    CONSTRAINT fk_likes_posts
        FOREIGN KEY (post_id) REFERENCES posts(post_id)
        ON DELETE CASCADE                          
);

-- Bài 2 PHẦN 2
INSERT INTO likes (user_id, post_id, liked_at) VALUES
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),
(1, 3, '2025-01-11 10:00:00'),
(3, 4, '2025-01-12 16:00:00');

-- Bài 1 PHẦN 2:
INSERT INTO users (username, email, created_at) VALUES
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

-- Bài 1 PHẦN 3
DELIMITER $$

CREATE TRIGGER trg_after_insert_post
AFTER INSERT ON posts
FOR EACH ROW
BEGIN
    UPDATE users
    SET post_count = post_count + 1
    WHERE user_id = NEW.user_id;
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_after_delete_post
AFTER DELETE ON posts
FOR EACH ROW
BEGIN
    UPDATE users
    SET post_count = post_count - 1
    WHERE user_id = OLD.user_id;
END $$

DELIMITER ;

-- Bài 2 PHẦN 3
DELIMITER $$

CREATE TRIGGER trg_after_insert_like
AFTER INSERT ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count + 1
    WHERE post_id = NEW.post_id;
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_after_delete_like
AFTER DELETE ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count - 1
    WHERE post_id = OLD.post_id;
END $$

DELIMITER ;

-- Bài 2 PHẦN 4
CREATE OR REPLACE VIEW user_statistics AS
SELECT 
    u.user_id,
    u.username,
    u.post_count,
    COALESCE(SUM(p.like_count), 0) AS total_likes
FROM users u
LEFT JOIN posts p ON u.user_id = p.user_id
GROUP BY u.user_id, u.username, u.post_count;

-- Bài 1 PHẦN 4
INSERT INTO posts (user_id, content, created_at) VALUES
(1, 'Hello world from Alice!', '2025-01-10 10:00:00'),
(1, 'Second post by Alice', '2025-01-10 12:00:00'),
(2, 'Bob first post', '2025-01-11 09:00:00'),
(3, 'Charlie sharing thoughts', '2025-01-12 15:00:00');

SELECT * FROM users;
-- Bài 1 PHẦN 5
DELETE FROM posts WHERE post_id = 2;
SELECT * FROM users;

-- Bài 2 PHẦN 5
INSERT INTO likes (user_id, post_id, liked_at)
VALUES (2, 4, NOW());
SELECT * FROM posts WHERE post_id = 4;
SELECT * FROM user_statistics;

-- Bài 2 PHẦN 6
DELETE FROM likes
WHERE user_id = 3 AND post_id = 4
LIMIT 1;
SELECT * FROM posts WHERE post_id = 4;
SELECT * FROM user_statistics;

-- Bài 3
USE trigger_social;

SELECT * FROM users;
SELECT * FROM posts;
SELECT * FROM likes;

DROP TRIGGER IF EXISTS trg_after_insert_like;
DROP TRIGGER IF EXISTS trg_after_delete_like;
DROP TRIGGER IF EXISTS trg_before_insert_like;
DROP TRIGGER IF EXISTS trg_after_update_like;

DELIMITER $$


CREATE TRIGGER trg_before_insert_like
BEFORE INSERT ON likes
FOR EACH ROW
BEGIN
    DECLARE post_owner INT;

    SELECT user_id
    INTO post_owner
    FROM posts
    WHERE post_id = NEW.post_id;

    IF post_owner = NEW.user_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User cannot like their own post';
    END IF;
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_after_insert_like
AFTER INSERT ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count + 1
    WHERE post_id = NEW.post_id;
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_after_delete_like
AFTER DELETE ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count - 1
    WHERE post_id = OLD.post_id;
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_after_update_like
AFTER UPDATE ON likes
FOR EACH ROW
BEGIN
    -- Nếu đổi bài được like
    IF OLD.post_id <> NEW.post_id THEN

        -- Giảm like_count của bài cũ
        UPDATE posts
        SET like_count = like_count - 1
        WHERE post_id = OLD.post_id;

        -- Tăng like_count của bài mới
        UPDATE posts
        SET like_count = like_count + 1
        WHERE post_id = NEW.post_id;

    END IF;
END $$

DELIMITER ;

INSERT INTO likes (user_id, post_id)
VALUES (1, 1);

INSERT INTO likes (user_id, post_id)
VALUES (2, 2);

SELECT * FROM posts WHERE post_id = 2;

UPDATE likes
SET post_id = 4
WHERE user_id = 2 AND post_id = 2
LIMIT 1;

SELECT * FROM posts WHERE post_id IN (2, 4);

DELETE FROM likes
WHERE user_id = 2 AND post_id = 4
LIMIT 1;

SELECT * FROM posts WHERE post_id = 4;
SELECT * FROM user_statistics;

-- Bai 4

USE trigger_social;

CREATE TABLE post_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,     
    post_id INT,                          
    old_content TEXT,                           
    new_content TEXT,                          
    changed_at DATETIME,                        
    changed_by_user_id INT,                    
    CONSTRAINT fk_history_post
        FOREIGN KEY (post_id) REFERENCES posts(post_id)
        ON DELETE CASCADE                      
);

DROP TRIGGER IF EXISTS trg_before_update_post;
DROP TRIGGER IF EXISTS trg_after_delete_post_log;

DELIMITER $$

CREATE TRIGGER trg_before_update_post
BEFORE UPDATE ON posts
FOR EACH ROW
BEGIN
    -- Chỉ ghi log khi nội dung thực sự thay đổi
    IF OLD.content <> NEW.content THEN
        INSERT INTO post_history (
            post_id,
            old_content,
            new_content,
            changed_at,
            changed_by_user_id
        )
        VALUES (
            OLD.post_id,
            OLD.content,
            NEW.content,
            NOW(),
            OLD.user_id    
        );
    END IF;
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_after_delete_post_log
AFTER DELETE ON posts
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '01000'
    SET MESSAGE_TEXT = 'Post deleted, history removed by CASCADE';
END $$

DELIMITER ;

UPDATE posts
SET content = 'Hello world from Alice (edited version)'
WHERE post_id = 1;

UPDATE posts
SET content = 'Bob first post - updated content'
WHERE post_id = 3;

SELECT * FROM post_history
ORDER BY changed_at DESC;

SELECT post_id, content, like_count
FROM posts;
SELECT * FROM user_statistics;

-- Bài 5
USE trigger_social;

DROP TRIGGER IF EXISTS trg_before_insert_user;
DROP PROCEDURE IF EXISTS add_user;

DELIMITER $$

CREATE TRIGGER trg_before_insert_user
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    -- Kiểm tra email hợp lệ (đơn giản)
    IF NEW.email NOT LIKE '%@%.%' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid email format';
    END IF;

    -- Kiểm tra username chỉ chứa a-z, A-Z, 0-9, _
    IF NEW.username REGEXP '[^a-zA-Z0-9_]' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username contains invalid characters';
    END IF;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE add_user(
    IN p_username VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_created_at DATE
)
BEGIN
    INSERT INTO users (username, email, created_at)
    VALUES (p_username, p_email, p_created_at);
END $$

DELIMITER ;

CALL add_user('valid_user_01', 'valid01@example.com', '2025-02-01');
CALL add_user('invalid_email', 'invalidemail.com', '2025-02-01');
CALL add_user('bad@name!', 'badname@example.com', '2025-02-01');
SELECT * FROM users;
