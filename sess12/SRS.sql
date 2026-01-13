DROP DATABASE IF EXISTS social_network;

CREATE DATABASE social_network
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE social_network;

-- BẢNG USERS
-- Quản lý thông tin người dùng
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,   
    password VARCHAR(255) NOT NULL,           
    email VARCHAR(100) NOT NULL UNIQUE,    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- BẢNG POSTS
-- Lưu trữ bài viết của người dùng
CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,                 
    content TEXT NOT NULL,                   
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- BẢNG COMMENTS
-- Quản lý bình luận của người dùng trên bài viết
CREATE TABLE Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY, 
    post_id INT NOT NULL,          
    user_id INT NOT NULL,                 
    content TEXT NOT NULL,                   
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- BẢNG FRIENDS
-- Quản lý quan hệ bạn bè / theo dõi
CREATE TABLE Friends (
    user_id INT NOT NULL, 
    friend_id INT NOT NULL,
    status VARCHAR(20) CHECK (status IN ('pending','accepted')), 
    PRIMARY KEY (user_id, friend_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (friend_id) REFERENCES Users(user_id)
);


-- BẢNG LIKES
-- Quản lý lượt thích bài viết
CREATE TABLE Likes (
    user_id INT NOT NULL, 
    post_id INT NOT NULL,  
    PRIMARY KEY (user_id, post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (post_id) REFERENCES Posts(post_id)
);

-- Tăng tốc tìm kiếm theo username
CREATE INDEX idx_users_username ON Users(username);

-- Tăng tốc JOIN giữa Users và Posts
CREATE INDEX idx_posts_user ON Posts(user_id);

-- Tăng tốc truy vấn bình luận theo bài viết
CREATE INDEX idx_comments_post ON Comments(post_id);

-- Tăng tốc thống kê lượt thích theo bài viết
CREATE INDEX idx_likes_post ON Likes(post_id);

-- Tăng tốc truy vấn quan hệ bạn bè
CREATE INDEX idx_friends_user ON Friends(user_id);

-- VIEW 1: Thông tin người dùng công khai
CREATE VIEW vw_public_users AS
SELECT user_id, username, email, created_at
FROM Users;

-- Thống kê hoạt động bài viết
CREATE VIEW vw_post_stats AS
SELECT 
    p.post_id,
    u.username,
    p.content,
    COUNT(DISTINCT l.user_id) AS total_likes,
    COUNT(DISTINCT c.comment_id) AS total_comments
FROM Posts p
JOIN Users u ON p.user_id = u.user_id
LEFT JOIN Likes l ON p.post_id = l.post_id
LEFT JOIN Comments c ON p.post_id = c.post_id
GROUP BY p.post_id;

-- Thêm người dùng mới
DELIMITER $$

CREATE PROCEDURE sp_add_user(
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(255),
    IN p_email VARCHAR(100)
)
BEGIN
    INSERT INTO Users(username, password, email)
    VALUES (p_username, p_password, p_email);
END$$

DELIMITER ;

-- Tạo bài viết mới
DELIMITER $$

CREATE PROCEDURE sp_create_post(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    INSERT INTO Posts(user_id, content)
    VALUES (p_user_id, p_content);
END$$

DELIMITER ;

--Đếm số bài viết của người dùng

DELIMITER $$

CREATE PROCEDURE sp_count_user_posts(
    IN p_user_id INT,
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*) INTO p_total
    FROM Posts
    WHERE user_id = p_user_id;
END$$

DELIMITER ;

-- Gợi ý bạn bè
DELIMITER $$

CREATE PROCEDURE sp_suggest_friends(
    IN p_user_id INT
)
BEGIN
    SELECT u.user_id, u.username
    FROM Users u
    WHERE u.user_id <> p_user_id
      AND u.user_id NOT IN (
          SELECT friend_id
          FROM Friends
          WHERE user_id = p_user_id
      );
END$$

DELIMITER ;

INSERT INTO Users(username,password,email)
VALUES 
('alice','123','alice@mail.com'),
('bob','123','bob@mail.com'),
('charlie','123','charlie@mail.com');

CALL sp_create_post(1, 'Hello world!');
CALL sp_create_post(2, 'My first post');

INSERT INTO Likes VALUES (2,1),(3,1);

INSERT INTO Comments(post_id,user_id,content)
VALUES 
(1,2,'Nice post'),
(1,3,'Great!');
