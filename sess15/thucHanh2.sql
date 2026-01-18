DROP DATABASE IF EXISTS social_network_practice;
CREATE DATABASE social_network_practice;
USE social_network_practice;

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    like_count INT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    user_id INT,
    content TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Likes (
    user_id INT,
    post_id INT,
    PRIMARY KEY(user_id, post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (post_id) REFERENCES Posts(post_id)
);

CREATE TABLE Friends (
    sender_id INT,
    receiver_id INT,
    status ENUM('pending','accepted'),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(sender_id, receiver_id),
    FOREIGN KEY (sender_id) REFERENCES Users(user_id),
    FOREIGN KEY (receiver_id) REFERENCES Users(user_id)
);

CREATE TABLE user_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(100),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE post_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    action VARCHAR(100),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE like_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    post_id INT,
    action VARCHAR(50),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE friend_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    sender_id INT,
    receiver_id INT,
    action VARCHAR(100),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- BÀI 1 - REGISTER USER
DELIMITER $$

CREATE PROCEDURE sp_register_user(
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(100),
    IN p_email VARCHAR(100)
)
BEGIN
    IF EXISTS(SELECT 1 FROM Users WHERE username = p_username) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username already exists';
    END IF;

    IF EXISTS(SELECT 1 FROM Users WHERE email = p_email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email already exists';
    END IF;

    INSERT INTO Users(username, password, email)
    VALUES(p_username, p_password, p_email);
END$$

DELIMITER ;

-- Trigger log register
DELIMITER $$

CREATE TRIGGER tg_user_register_log
AFTER INSERT ON Users
FOR EACH ROW
BEGIN
    INSERT INTO user_log(user_id, action)
    VALUES(NEW.user_id, 'REGISTER USER');
END$$

DELIMITER ;

-- DEMO BÀI 1
CALL sp_register_user('alice','123','alice@mail.com');
CALL sp_register_user('bob','123','bob@mail.com');
CALL sp_register_user('charlie','123','charlie@mail.com');

-- Test lỗi
SELECT * FROM Users;
SELECT * FROM user_log;

-- BÀI 2 - CREATE POST
DELIMITER $$

CREATE PROCEDURE sp_create_post(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    IF p_content IS NULL OR p_content = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Post content cannot be empty';
    END IF;

    INSERT INTO Posts(user_id, content)
    VALUES(p_user_id, p_content);
END$$

DELIMITER ;

-- Trigger log post
DELIMITER $$

CREATE TRIGGER tg_post_log
AFTER INSERT ON Posts
FOR EACH ROW
BEGIN
    INSERT INTO post_log(post_id, action)
    VALUES(NEW.post_id, 'CREATE POST');
END$$

DELIMITER ;

-- DEMO BÀI 2
CALL sp_create_post(1, 'Hello world');
CALL sp_create_post(1, 'My second post');
CALL sp_create_post(2, 'Bob is here');
CALL sp_create_post(3, 'Charlie online');

-- Test lỗi
SELECT * FROM Posts;
SELECT * FROM post_log;

-- BÀI 3 - LIKE / UNLIKE
DELIMITER $$

CREATE TRIGGER tg_like_add
AFTER INSERT ON Likes
FOR EACH ROW
BEGIN
    UPDATE Posts
    SET like_count = like_count + 1
    WHERE post_id = NEW.post_id;

    INSERT INTO like_log(user_id, post_id, action)
    VALUES(NEW.user_id, NEW.post_id, 'LIKE');
END$$

CREATE TRIGGER tg_like_remove
AFTER DELETE ON Likes
FOR EACH ROW
BEGIN
    UPDATE Posts
    SET like_count = like_count - 1
    WHERE post_id = OLD.post_id;

    INSERT INTO like_log(user_id, post_id, action)
    VALUES(OLD.user_id, OLD.post_id, 'UNLIKE');
END$$

DELIMITER ;
-- DEMO BÀI 3
INSERT INTO Likes VALUES(1,1);
INSERT INTO Likes VALUES(2,1);
INSERT INTO Likes VALUES(3,1);

DELETE FROM Likes WHERE user_id=2 AND post_id=1;

SELECT * FROM Posts;
SELECT * FROM like_log;

-- BÀI 4 - FRIEND REQUEST
DELIMITER $$

CREATE PROCEDURE sp_send_friend_request(
    IN p_sender INT,
    IN p_receiver INT
)
BEGIN
    IF p_sender = p_receiver THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot send friend request to yourself';
    END IF;

    IF EXISTS(
        SELECT 1 FROM Friends
        WHERE sender_id = p_sender AND receiver_id = p_receiver
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Friend request already exists';
    END IF;

    INSERT INTO Friends(sender_id, receiver_id, status)
    VALUES(p_sender, p_receiver, 'pending');
END$$

DELIMITER ;

-- Trigger log friend request
DELIMITER $$

CREATE TRIGGER tg_friend_log
AFTER INSERT ON Friends
FOR EACH ROW
BEGIN
    INSERT INTO friend_log(sender_id, receiver_id, action)
    VALUES(NEW.sender_id, NEW.receiver_id, 'SEND FRIEND REQUEST');
END$$

DELIMITER ;

-- DEMO BÀI 4
CALL sp_send_friend_request(1,2);
CALL sp_send_friend_request(1,3);

SELECT * FROM Friends;
SELECT * FROM friend_log;

-- BÀI 5 - ACCEPT FRIEND
DELIMITER $$

CREATE TRIGGER tg_accept_friend
AFTER UPDATE ON Friends
FOR EACH ROW
BEGIN
    IF NEW.status = 'accepted' AND OLD.status = 'pending' THEN
        INSERT IGNORE INTO Friends(sender_id, receiver_id, status)
        VALUES(NEW.receiver_id, NEW.sender_id, 'accepted');
    END IF;
END$$

DELIMITER ;
-- DEMO BÀI 5
UPDATE Friends
SET status='accepted'
WHERE sender_id=1 AND receiver_id=2;

SELECT * FROM Friends;

-- BÀI 6 - DELETE FRIEND (TRANSACTION)
DELIMITER $$

CREATE PROCEDURE sp_delete_friend(
    IN p_user1 INT,
    IN p_user2 INT
)
BEGIN
    START TRANSACTION;

    DELETE FROM Friends WHERE sender_id=p_user1 AND receiver_id=p_user2;
    DELETE FROM Friends WHERE sender_id=p_user2 AND receiver_id=p_user1;

    COMMIT;
END$$

DELIMITER ;
-- DEMO
CALL sp_delete_friend(1,2);
SELECT * FROM Friends;

-- BÀI 7 - DELETE POST
DELIMITER $$

CREATE PROCEDURE sp_delete_post(
    IN p_post_id INT,
    IN p_user_id INT
)
BEGIN
    DECLARE owner INT;

    SELECT user_id INTO owner FROM Posts WHERE post_id = p_post_id;

    IF owner <> p_user_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not post owner';
    END IF;

    START TRANSACTION;

    DELETE FROM Likes WHERE post_id = p_post_id;
    DELETE FROM Comments WHERE post_id = p_post_id;
    DELETE FROM Posts WHERE post_id = p_post_id;

    COMMIT;
END$$

DELIMITER ;
-- DEMO
CALL sp_delete_post(1,1);
SELECT * FROM Posts;

-- BÀI 8 - DELETE USER
DELIMITER $$

CREATE PROCEDURE sp_delete_user(
    IN p_user_id INT
)
BEGIN
    START TRANSACTION;

    DELETE FROM Likes WHERE user_id = p_user_id;
    DELETE FROM Comments WHERE user_id = p_user_id;
    DELETE FROM Friends WHERE sender_id = p_user_id OR receiver_id = p_user_id;
    DELETE FROM Posts WHERE user_id = p_user_id;
    DELETE FROM Users WHERE user_id = p_user_id;

    COMMIT;
END$$

DELIMITER ;

-- DEMO
CALL sp_delete_user(3);

SELECT * FROM Users;
SELECT * FROM Posts;
SELECT * FROM Friends;
SELECT * FROM Likes;
