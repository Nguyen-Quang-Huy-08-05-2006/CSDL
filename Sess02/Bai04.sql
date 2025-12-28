-- ================================
-- TẠO BẢNG TEACHER
-- ================================
CREATE TABLE Teacher (
    teacher_id VARCHAR(10) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

-- ================================
-- CẬP NHẬT BẢNG SUBJECT
-- LIÊN KẾT VỚI TEACHER
-- ================================

-- Thêm cột teacher_id
ALTER TABLE Subject
ADD COLUMN teacher_id VARCHAR(10);

-- Thêm khóa ngoại
ALTER TABLE Subject
ADD CONSTRAINT fk_subject_teacher
    FOREIGN KEY (teacher_id)
    REFERENCES Teacher(teacher_id)
    ON UPDATE CASCADE
    ON DELETE SET NULL;
