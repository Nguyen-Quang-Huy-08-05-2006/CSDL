-- Tạo bảng Class
CREATE TABLE Class (
    class_id VARCHAR(10) PRIMARY KEY,
    class_name VARCHAR(50) NOT NULL,
    academic_year INT NOT NULL
);

-- Tạo bảng Student
CREATE TABLE Student (
    student_id VARCHAR(10) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    class_id VARCHAR(10) NOT NULL,

    CONSTRAINT fk_student_class
        FOREIGN KEY (class_id)
        REFERENCES Class(class_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
