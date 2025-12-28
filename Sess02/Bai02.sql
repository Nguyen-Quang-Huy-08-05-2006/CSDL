-- Tạo bảng Student
CREATE TABLE Student (
    student_id VARCHAR(10) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL
);

-- Tạo bảng Subject
CREATE TABLE Subject (
    subject_id VARCHAR(10) PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL,
    credit INT NOT NULL,
    
    CONSTRAINT chk_credit_positive CHECK (credit > 0)
);
