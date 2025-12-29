USE SchoolDB;
SELECT * FROM Student;

UPDATE Student
SET email = 'cuong.le_new@gmail.com'
WHERE student_id = 3;

UPDATE Student
SET date_of_birth = '2003-10-15'
WHERE student_id = 2;

DELETE FROM Student
WHERE student_id = 5;

SELECT * FROM Student;
