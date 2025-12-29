USE SchoolDB;
DROP TABLE IF EXISTS Enrollment;

CREATE TABLE Enrollment (
    student_id INT,
    subject_id INT,
    enroll_date DATE,

    /* Khóa chính kết hợp:
       1 sinh viên không được đăng ký trùng 1 môn */
    PRIMARY KEY (student_id, subject_id),

    /* Khóa ngoại liên kết */
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
);

INSERT INTO Enrollment (student_id, subject_id, enroll_date)
VALUES
    (1, 101, '2024-09-01'),
    (1, 102, '2024-09-02'),
    (2, 101, '2024-09-01'),
    (2, 103, '2024-09-03');

SELECT *
FROM Enrollment;

SELECT *
FROM Enrollment
WHERE student_id = 1;
