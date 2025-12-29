DROP DATABASE IF EXISTS TrainingDB;
CREATE DATABASE TrainingDB;
USE TrainingDB;

CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL
);

CREATE TABLE Subject (
    subject_id VARCHAR(10) PRIMARY KEY,
    subject_name NVARCHAR(100) NOT NULL
);

CREATE TABLE Enrollment (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    subject_id VARCHAR(10) NOT NULL,
    enroll_date DATE NOT NULL,
    UNIQUE (student_id, subject_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
);

CREATE TABLE Score (
    student_id INT NOT NULL,
    subject_id VARCHAR(10) NOT NULL,
    process_score DECIMAL(3,1),
    final_score DECIMAL(3,1),
    PRIMARY KEY (student_id, subject_id),
    CHECK (process_score BETWEEN 0 AND 10),
    CHECK (final_score BETWEEN 0 AND 10),
    FOREIGN KEY (student_id, subject_id)
        REFERENCES Enrollment(student_id, subject_id)
);

INSERT INTO Student VALUES
(1001, N'Nguyễn Văn A'),
(1002, N'Trần Thị B');

INSERT INTO Subject VALUES
('DB101', N'Cơ sở dữ liệu'),
('PR102', N'Lập trình C');

INSERT INTO Enrollment (student_id, subject_id, enroll_date)
VALUES (1001, 'DB101', CURRENT_DATE);

INSERT INTO Score (student_id, subject_id, process_score, final_score)
VALUES (1001, 'DB101', 7.5, 8.0);

UPDATE Score
SET final_score = 8.5
WHERE student_id = 1001
  AND subject_id = 'DB101';


SELECT s.student_id,
       s.full_name,
       sub.subject_name,
       sc.process_score,
       sc.final_score
FROM Student s
JOIN Score sc ON s.student_id = sc.student_id
JOIN Subject sub ON sc.subject_id = sub.subject_id;

SELECT sub.subject_name,
       sc.process_score,
       sc.final_score
FROM Score sc
JOIN Subject sub ON sc.subject_id = sub.subject_id
WHERE sc.student_id = 1001;

DELETE FROM Score
WHERE student_id = 1001
  AND subject_id = 'DB101';

DELETE FROM Enrollment
WHERE student_id = 1001
  AND subject_id = 'DB101';
