CREATE DATABASE OnlineLearning;
USE OnlineLearning;

CREATE TABLE Student (
    student_id VARCHAR(10) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Instructor (
    instructor_id VARCHAR(10) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Course (
    course_id VARCHAR(10) PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    total_sessions INT NOT NULL CHECK (total_sessions > 0),
    instructor_id VARCHAR(10),
    FOREIGN KEY (instructor_id) REFERENCES Instructor(instructor_id)
);

CREATE TABLE Enrollment (
    student_id VARCHAR(10),
    course_id VARCHAR(10),
    enroll_date DATE NOT NULL,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

CREATE TABLE Result (
    student_id VARCHAR(10),
    course_id VARCHAR(10),
    mid_score DECIMAL(4,2) CHECK (mid_score BETWEEN 0 AND 10),
    final_score DECIMAL(4,2) CHECK (final_score BETWEEN 0 AND 10),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id, course_id)
        REFERENCES Enrollment(student_id, course_id)
);

INSERT INTO Student VALUES
('SV01','Nguyen Van An','2004-05-10','an@gmail.com'),
('SV02','Tran Thi Binh','2004-08-21','binh@gmail.com'),
('SV03','Le Quang Huy','2003-11-02','huy@gmail.com'),
('SV04','Pham Minh Duc','2004-01-15','duc@gmail.com'),
('SV05','Hoang Thi Lan','2003-09-30','lan@gmail.com');

INSERT INTO Instructor VALUES
('GV01','Nguyen Van A','a@edu.vn'),
('GV02','Tran Thi B','b@edu.vn'),
('GV03','Le Van C','c@edu.vn'),
('GV04','Pham Thi D','d@edu.vn'),
('GV05','Hoang Van E','e@edu.vn');

INSERT INTO Course VALUES
('C01','C Programming','Learn C language',30,'GV01'),
('C02','Data Structure','Stack, Queue, List',45,'GV02'),
('C03','Database','SQL and Design',40,'GV03'),
('C04','Web Basic','HTML CSS JS',35,'GV04'),
('C05','Software Testing','QA Fundamentals',25,'GV05');

INSERT INTO Enrollment VALUES
('SV01','C01','2025-01-10'),
('SV01','C02','2025-01-11'),
('SV02','C03','2025-01-12'),
('SV03','C02','2025-01-13'),
('SV04','C04','2025-01-14');

INSERT INTO Result VALUES
('SV01','C01',7.5,8.0),
('SV01','C02',6.0,7.0),
('SV02','C03',8.0,8.5),
('SV03','C02',5.5,6.5),
('SV04','C04',7.0,7.5);

UPDATE Student
SET email = 'an_new@gmail.com'
WHERE student_id = 'SV01';

UPDATE Course
SET description = 'Advanced SQL and Database Design'
WHERE course_id = 'C03';

UPDATE Result
SET final_score = 9.0
WHERE student_id = 'SV01' AND course_id = 'C01';

DELETE FROM Result
WHERE student_id = 'SV04' AND course_id = 'C04';

DELETE FROM Enrollment
WHERE student_id = 'SV04' AND course_id = 'C04';

SELECT * FROM Student;
SELECT * FROM Instructor;
SELECT * FROM Course;
SELECT * FROM Enrollment;
SELECT * FROM Result;
