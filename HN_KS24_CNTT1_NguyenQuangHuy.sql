/*
 * DATABASE SETUP - SESSION 15 EXAM
 * Database: StudentManagement
 */

-- DROP DATABASE IF EXISTS StudentManagement;
CREATE DATABASE StudentManagement;
USE StudentManagement;

-- =============================================
-- 1. TABLE STRUCTURE
-- =============================================

-- Table: Students
CREATE TABLE Students (
    StudentID CHAR(5) PRIMARY KEY,
    FullName VARCHAR(50) NOT NULL,
    TotalDebt DECIMAL(10,2) DEFAULT 0
);

-- Table: Subjects
CREATE TABLE Subjects (
    SubjectID CHAR(5) PRIMARY KEY,
    SubjectName VARCHAR(50) NOT NULL,
    Credits INT CHECK (Credits > 0)
);

-- Table: Grades
CREATE TABLE Grades (
    StudentID CHAR(5),
    SubjectID CHAR(5),
    Score DECIMAL(4,2) CHECK (Score BETWEEN 0 AND 10),
    PRIMARY KEY (StudentID, SubjectID),
    CONSTRAINT FK_Grades_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    CONSTRAINT FK_Grades_Subjects FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);

-- Table: GradeLog
CREATE TABLE GradeLog (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID CHAR(5),
    OldScore DECIMAL(4,2),
    NewScore DECIMAL(4,2),
    ChangeDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- 2. SEED DATA
-- =============================================

-- Insert Students
INSERT INTO Students (StudentID, FullName, TotalDebt) VALUES 
('SV01', 'Ho Khanh Linh', 5000000),
('SV03', 'Tran Thi Khanh Huyen', 0);

-- Insert Subjects
INSERT INTO Subjects (SubjectID, SubjectName, Credits) VALUES 
('SB01', 'Co so du lieu', 3),
('SB02', 'Lap trinh Java', 4),
('SB03', 'Lap trinh C', 3);

-- Insert Grades
INSERT INTO Grades (StudentID, SubjectID, Score) VALUES 																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																
('SV01', 'SB01', 8.5), -- Passed
('SV03', 'SB02', 3.0); -- Failed

-- End of File

-- Phan A
-- Bai 1
DELIMITER $$

CREATE TRIGGER tg_CheckScore
BEFORE INSERT ON Grades
FOR EACH ROW
BEGIN
    IF NEW.Score < 0 THEN
        SET NEW.Score = 0;
    END IF;

    IF NEW.Score > 10 THEN
        SET NEW.Score = 10;
    END IF;
END$$

DELIMITER ;

-- Bai 2
START TRANSACTION;

INSERT INTO Students (StudentID, FullName, TotalDebt)
VALUES ('SV02', 'Ha Bich Ngoc', 0);

UPDATE Students
SET TotalDebt = 5000000
WHERE StudentID = 'SV02';

COMMIT;

INSERT INTO Grades (StudentID, SubjectID, Score)
VALUES ('SV01', 'SB03', -5);

INSERT INTO Grades (StudentID, SubjectID, Score)
VALUES ('SV03', 'SB01', 20);

SELECT * FROM Grades;


-- Phan B
-- Bai 3
DELIMITER $$

CREATE TRIGGER tg_LogGradeUpdate
AFTER UPDATE ON Grades
FOR EACH ROW
BEGIN
    IF OLD.Score <> NEW.Score THEN
        INSERT INTO GradeLog (StudentID, OldScore, NewScore, ChangeDate)
        VALUES (
            NEW.StudentID,
            OLD.Score,
            NEW.Score,
            NOW()
        );
    END IF;
END$$

DELIMITER ;

-- Bai 4
DELIMITER $$

CREATE PROCEDURE sp_PayTuition()
BEGIN
    DECLARE v_totalDebt DECIMAL(10,2);
    START TRANSACTION;

    UPDATE Students
    SET TotalDebt = TotalDebt - 2000000
    WHERE StudentID = 'SV01';
    SELECT TotalDebt INTO v_totalDebt
    FROM Students
    WHERE StudentID = 'SV01';

    IF v_totalDebt < 0 THEN
        ROLLBACK;
    ELSE
        COMMIT;
    END IF;
END$$

DELIMITER ;


-- Phan C
-- Bai 5
DELIMITER $$

CREATE TRIGGER tg_PreventPassUpdate
BEFORE UPDATE ON Grades
FOR EACH ROW
BEGIN
    IF OLD.Score >= 4.0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Khong duoc phep sua diem: Sinh vien da qua mon!';
    END IF;
END$$

DELIMITER ;
