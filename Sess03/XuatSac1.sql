USE SchoolDB;
DROP TABLE IF EXISTS Score;

CREATE TABLE Score (
    student_id INT,
    subject_id INT,
    mid_score DECIMAL(4,2),
    final_score DECIMAL(4,2),

    PRIMARY KEY (student_id, subject_id),

    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id),

    CHECK (mid_score BETWEEN 0 AND 10),
    CHECK (final_score BETWEEN 0 AND 10)
);

INSERT INTO Score (student_id, subject_id, mid_score, final_score)
VALUES
    (1, 101, 7.5, 8.0),
    (1, 102, 6.0, 7.0),
    (2, 101, 8.0, 8.5),
    (2, 103, 7.0, 9.0);


UPDATE Score
SET final_score = 8.2
WHERE student_id = 1
  AND subject_id = 102;

SELECT *
FROM Score;

SELECT *
FROM Score
WHERE final_score >= 8;
