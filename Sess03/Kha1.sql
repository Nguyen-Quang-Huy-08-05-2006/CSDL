
CREATE DATABASE IF NOT EXISTS SchoolDB;
USE SchoolDB;
DROP TABLE IF EXISTS Student;

CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE
);

INSERT INTO Student (student_id, full_name, date_of_birth, email)
VALUES
    (1, 'Nguyen Van A', '2004-05-12', 'an.nguyen@gmail.com'),
    (2, 'Tran Thi Bi', '2003-11-20', 'binh.tran@gmail.com'),
    (3, 'Le Van C', '2004-02-01', 'cuong.le@gmail.com');

SELECT * 
FROM Student;

SELECT student_id, full_name
FROM Student;
