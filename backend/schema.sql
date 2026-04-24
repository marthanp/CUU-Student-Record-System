-- ==========================================================
-- University Student Records Management System (USRMS)
-- Target Database: MySQL
-- Author: Antigravity (SDLC Phase: Design & Implementation)
-- ==========================================================

-- 1. Create Tables
-- Entity: Users (Handles Authentication and Authorization)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- In production, use bcrypt hashes
    role ENUM('Admin', 'Registry', 'Finance', 'Lecturer', 'Student') NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Entity: Students (Profile information)
CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    reg_number VARCHAR(20) NOT NULL UNIQUE,
    department VARCHAR(100),
    program VARCHAR(100),
    year_of_study INT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Entity: Courses
CREATE TABLE IF NOT EXISTS courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(10) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    credits INT DEFAULT 3
);

-- Entity: Enrollments (Matches students to courses)
CREATE TABLE IF NOT EXISTS enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    semester VARCHAR(10),
    academic_year VARCHAR(10),
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

-- Entity: Fees (Financial Management)
CREATE TABLE IF NOT EXISTS fees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    total_due DECIMAL(10, 2) DEFAULT 0.00,
    paid_amount DECIMAL(10, 2) DEFAULT 0.00,
    balance DECIMAL(10, 2) GENERATED ALWAYS AS (total_due - paid_amount) STORED,
    status ENUM('Paid', 'Partial', 'Unpaid') DEFAULT 'Unpaid',
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

-- Entity: Marks (Academic Results)
CREATE TABLE IF NOT EXISTS marks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    score DECIMAL(5, 2) DEFAULT 0.00,
    recorded_by INT, -- Lecturer User ID
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(id) ON DELETE CASCADE,
    FOREIGN KEY (recorded_by) REFERENCES users(id)
);

-- 2. Insert Dummy Data for Testing
-- Roles: Admin, Registry, Finance, Lecturer, Student
INSERT INTO users (username, password, role, full_name, email) VALUES
('cuu_admin', 'admin123', 'Admin', 'CUU System Administrator', 'admin@cavendish.ac.ug'),
('cuu_registry', 'reg123', 'Registry', 'Head of Registry', 'registry@cavendish.ac.ug'),
('cuu_finance', 'fin123', 'Finance', 'Bursar Office', 'finance@cavendish.ac.ug'),
('lecturer_jane', 'prof123', 'Lecturer', 'Dr. Jane Doe', 'jdoe@cavendish.ac.ug'),
('student_john', 'stud123', 'Student', 'John Musoke', 'jmusoke@students.cavendish.ac.ug'),
('student_mary', 'stud123', 'Student', 'Mary Atwine', 'matwine@students.cavendish.ac.ug');

-- Insert Students
INSERT INTO students (user_id, reg_number, department, program, year_of_study) VALUES
(5, 'CUU/BIT/2024/001', 'ICT', 'Bachelor of IT', 1),
(6, 'CUU/BA/2024/005', 'Business', 'Bachelor of Arts', 1);

-- Insert Courses
INSERT INTO courses (code, name, credits) VALUES
('BIT1101', 'Introduction to Programming', 4),
('BIT1102', 'Database Management Systems', 4),
('BA1101', 'Business Economics', 3);

-- Enrollments
INSERT INTO enrollments (student_id, course_id, semester, academic_year) VALUES
(1, 1, 'SEM 1', '2023/2024'),
(1, 2, 'SEM 1', '2023/2024'),
(2, 3, 'SEM 1', '2023/2024');

-- Fees
-- John has paid in full
INSERT INTO fees (student_id, total_due, paid_amount, status) VALUES
(1, 2500000.00, 2500000.00, 'Paid');

-- Mary has a balance (Financial Gate should block results)
INSERT INTO fees (student_id, total_due, paid_amount, status) VALUES
(2, 2500000.00, 1000000.00, 'Partial');

-- Marks
INSERT INTO marks (enrollment_id, score, recorded_by) VALUES
(1, 75.00, 4), -- John's grade
(3, 82.00, 4); -- Mary's grade
