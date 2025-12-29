USE SchoolDB;
DROP TABLE IF EXISTS Subject;

CREATE TABLE Subject (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL,
    credit INT CHECK (credit > 0)
);

INSERT INTO Subject (subject_id, subject_name, credit)
VALUES
    (101, 'Co so du lieu', 3),
    (102, 'Lap trinh C', 4),
    (103, 'Cau truc du lieu va giai thuat', 4);

UPDATE Subject
SET credit = 4
WHERE subject_id = 101;

UPDATE Subject
SET subject_name = 'Lap trinh C co ban'
WHERE subject_id = 102;

SELECT *
FROM Subject;
