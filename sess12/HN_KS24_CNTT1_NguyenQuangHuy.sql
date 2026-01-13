DROP DATABASE IF EXISTS QLSinhVien;
CREATE DATABASE QLSinhVien;
USE QLSinhVien;

-- Bảng Khoa
CREATE TABLE Department (
    DeptID CHAR(5) PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL
);

-- Bảng Sinh viên
CREATE TABLE Student (
    StudentID CHAR(6) PRIMARY KEY,
    FullName VARCHAR(50),
    Gender VARCHAR(10),
    BirthDate DATE,
    DeptID CHAR(5),
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

-- Bảng Môn học
CREATE TABLE Course (
    CourseID CHAR(6) PRIMARY KEY,
    CourseName VARCHAR(50),
    Credits INT
);

-- Bảng Đăng ký
CREATE TABLE Enrollment (
    StudentID CHAR(6),
    CourseID CHAR(6),
    Score FLOAT,
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- =====================================================
-- 2. DỮ LIỆU MẪU
-- =====================================================

INSERT INTO Department VALUES
('IT','Information Technology'),
('BA','Business Administration'),
('ACC','Accounting');

INSERT INTO Student VALUES
('S00001','Nguyen An','Male','2003-05-10','IT'),
('S00002','Tran Binh','Male','2003-06-15','IT'),
('S00003','Le Hoa','Female','2003-08-20','BA'),
('S00004','Pham Minh','Male','2002-12-12','ACC'),
('S00005','Vo Lan','Female','2003-03-01','IT'),
('S00006','Do Hung','Male','2002-11-11','BA'),
('S00007','Nguyen Mai','Female','2003-07-07','ACC'),
('S00008','Tran Phuc','Male','2003-09-09','IT');

INSERT INTO Course VALUES
('C00001','Database Systems',3),
('C00002','C Programming',3),
('C00003','Microeconomics',2),
('C00004','Financial Accounting',3);

INSERT INTO Enrollment VALUES
('S00001','C00001',8.5),
('S00001','C00002',7.0),
('S00002','C00001',6.5),
('S00003','C00003',7.5),
('S00004','C00004',8.0),
('S00005','C00001',9.0),
('S00006','C00003',6.0),
('S00007','C00004',7.0),
('S00008','C00001',5.5),
('S00008','C00002',6.5);

-- PHẦN A
-- Câu 1:
CREATE VIEW View_StudentBasic AS
SELECT 
    s.StudentID,
    s.FullName,
    d.DeptName
FROM Student s
JOIN Department d ON s.DeptID = d.DeptID;

SELECT * FROM View_StudentBasic;

-- Câu 2
CREATE INDEX idx_student_fullname
ON Student(FullName);

-- Câu 3
DELIMITER $$

CREATE PROCEDURE GetStudentsIT()
BEGIN
    SELECT 
        s.StudentID,
        s.FullName,
        s.Gender,
        s.BirthDate,
        d.DeptName
    FROM Student s
    JOIN Department d ON s.DeptID = d.DeptID
    WHERE d.DeptName = 'Information Technology';
END $$

DELIMITER ;

CALL GetStudentsIT();

-- PHẦN B
-- Câu 4a
CREATE VIEW View_StudentCountByDept AS
SELECT 
    d.DeptName,
    COUNT(s.StudentID) AS TotalStudents
FROM Department d
LEFT JOIN Student s ON d.DeptID = s.DeptID
GROUP BY d.DeptName;

-- Câu 4b
SELECT *
FROM View_StudentCountByDept
ORDER BY TotalStudents DESC
LIMIT 1;

-- Câu 5a
DELIMITER $$

CREATE PROCEDURE GetTopScoreStudent(
    IN p_CourseID CHAR(6)
)
BEGIN
    SELECT 
        s.StudentID,
        s.FullName,
        e.Score
    FROM Enrollment e
    JOIN Student s ON e.StudentID = s.StudentID
    WHERE e.CourseID = p_CourseID
      AND e.Score = (
          SELECT MAX(Score)
          FROM Enrollment
          WHERE CourseID = p_CourseID
      );
END $$

DELIMITER ;

-- Câu 5b
CALL GetTopScoreStudent('C00001');

-- PHẦN C – GIỎI
-- Câu 6a
CREATE VIEW View_IT_Enrollment_DB AS
SELECT 
    e.StudentID,
    e.CourseID,
    e.Score
FROM Enrollment e
JOIN Student s ON e.StudentID = s.StudentID
WHERE s.DeptID = 'IT'
  AND e.CourseID = 'C00001'
WITH CHECK OPTION;