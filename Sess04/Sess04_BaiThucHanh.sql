CREATE DATABASE Library;
USE Library;

CREATE TABLE Reader (
    reader_id INT AUTO_INCREMENT PRIMARY KEY,
    reader_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    register_date DATE DEFAULT CURRENT_DATE,
    email VARCHAR(100),
    UNIQUE (phone, email)
);

CREATE TABLE Book (
    book_id INT PRIMARY KEY,
    book_title VARCHAR(150) NOT NULL,
    author VARCHAR(150),
    publish_year INT CHECK (publish_year >= 1900)
);

CREATE TABLE Borrow (
    borrow_id INT AUTO_INCREMENT PRIMARY KEY,
    reader_id INT,
    book_id INT,
    borrow_date DATE DEFAULT CURRENT_DATE,
    return_date DATE,
    CHECK (return_date IS NULL OR return_date >= borrow_date),
    FOREIGN KEY (reader_id) REFERENCES Reader(reader_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id)
);

INSERT INTO Reader (reader_id, reader_name, phone, register_date, email) VALUES
(1, 'Nguyễn Văn An', '0901234567', '2024-09-01', 'an.nguyen@gmail.com'),
(2, 'Trần Thị Bình', '0912345678', '2024-09-05', 'binh.tran@gmail.com'),
(3, 'Lê Minh Châu', '0923456789', '2024-09-10', 'chau.le@gmail.com');

-- =========================
-- INSERT DỮ LIỆU BOOK
-- =========================
INSERT INTO Book VALUES
(101, 'Lập trình C căn bản', 'Nguyễn Văn A', 2018),
(102, 'Cơ sở dữ liệu', 'Trần Thị B', 2020),
(103, 'Lập trình Java', 'Lê Minh C', 2019),
(104, 'Hệ quản trị MySQL', 'Phạm Văn D', 2021);

INSERT INTO Borrow (reader_id, book_id, borrow_date, return_date) VALUES
(1, 101, '2024-09-15', NULL),
(1, 102, '2024-09-15', '2024-09-25'),
(2, 103, '2024-09-18', NULL);

UPDATE Borrow
SET return_date = '2024-10-01'
WHERE reader_id = 1 AND book_id = 101;

UPDATE Book
SET publish_year = 2023
WHERE publish_year >= 2021;

DELETE FROM Borrow
WHERE borrow_date < '2024-09-18';

SELECT * FROM Reader;
SELECT * FROM Book;
SELECT * FROM Borrow;
