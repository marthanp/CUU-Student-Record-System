-- ==========================================================
-- CUU SYSTEM DATABASE DUMP (.sql)
-- Cavendish University Student Records Management System
-- Version: 2.0 (Fully Populated Prototype)
-- ==========================================================

-- 1. DATABASE STRUCTURE
DROP TABLE IF EXISTS marks;
DROP TABLE IF EXISTS fees;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('Admin', 'Registry', 'Finance', 'Lecturer', 'Student') NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    reg_number VARCHAR(20) NOT NULL UNIQUE,
    dob DATE,
    gender VARCHAR(10),
    department VARCHAR(100),
    program VARCHAR(100),
    year_of_study INT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(10) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    credits INT DEFAULT 3
);

CREATE TABLE enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    semester VARCHAR(10),
    academic_year VARCHAR(10),
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

CREATE TABLE fees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    total_due DECIMAL(10, 2) DEFAULT 0.00,
    paid_amount DECIMAL(10, 2) DEFAULT 0.00,
    balance DECIMAL(10, 2) GENERATED ALWAYS AS (total_due - paid_amount) STORED,
    status ENUM('Fully Paid', 'Partial', 'Unpaid') DEFAULT 'Unpaid',
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

CREATE TABLE marks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    coursework_score DECIMAL(5, 2) DEFAULT 0.00,
    exam_score DECIMAL(5, 2) DEFAULT 0.00,
    total_score DECIMAL(5, 2) GENERATED ALWAYS AS (coursework_score + exam_score) STORED,
    grade VARCHAR(2),
    recorded_by INT,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(id) ON DELETE CASCADE,
    FOREIGN KEY (recorded_by) REFERENCES users(id)
);

-- 2. DUMMY DATA POPULATION

-- 2.1 Users (Admins, Lecturers, Students)
INSERT INTO users (username, password, role, full_name, email) VALUES
('cuu_admin', 'pass123', 'Admin', 'Kintu Moses', 'kmoses@cavendish.ac.ug'),
('cuu_registry', 'pass123', 'Registry', 'Sarah Namutebi', 'snamutebi@cavendish.ac.ug'),
('cuu_finance', 'pass123', 'Finance', 'Bursar Office', 'bursar@cavendish.ac.ug'),
('lecturer_jane', 'pass123', 'Lecturer', 'Dr. Jane Doe', 'jdoe@cavendish.ac.ug'),
('lecturer_bob', 'pass123', 'Lecturer', 'Prof. Bob Smith', 'bsmith@cavendish.ac.ug'),
('mary_atwine', 'stud123', 'Student', 'Mary Atwine', 'matwine@students.cavendish.ac.ug'), -- ID 6
('john_musoke', 'stud123', 'Student', 'John Musoke', 'jmusoke@students.cavendish.ac.ug'),
('brian_k', 'stud123', 'Student', 'Brian Katerega', 'brian@students.cavendish.ac.ug'),
('fiona_n', 'stud123', 'Student', 'Fiona Nakazzi', 'fiona@students.cavendish.ac.ug'),
('ali_m', 'stud123', 'Student', 'Ali Mohammed', 'ali@students.cavendish.ac.ug'),
('hope_w', 'stud123', 'Student', 'Hope Wambui', 'hope@students.cavendish.ac.ug'),
('david_o', 'stud123', 'Student', 'David Okello', 'david@students.cavendish.ac.ug'),
('grace_m', 'stud123', 'Student', 'Grace Mutoni', 'grace@students.cavendish.ac.ug'),
('peter_b', 'stud123', 'Student', 'Peter Bukenya', 'peter@students.cavendish.ac.ug'),
('lydia_t', 'stud123', 'Student', 'Lydia Tusingirwe', 'lydia@students.cavendish.ac.ug');

-- 2.2 Students (10 Profiles)
INSERT INTO students (user_id, reg_number, department, program, year_of_study) VALUES
(6, 'CUU/BIT/2024/001', 'ICT', 'Bachelor of IT', 2),
(7, 'CUU/BIT/2024/002', 'ICT', 'Bachelor of IT', 2),
(8, 'CUU/BA/2024/003', 'Business', 'Business Administration', 1),
(9, 'CUU/BA/2024/004', 'Business', 'Business Administration', 1),
(10, 'CUU/LAW/2024/010', 'Law', 'Bachelor of Laws', 3),
(11, 'CUU/PH/2024/020', 'Health', 'Public Health', 2),
(12, 'CUU/ENG/2024/050', 'Engineering', 'Civil Engineering', 1),
(13, 'CUU/ENG/2024/051', 'Engineering', 'Civil Engineering', 1),
(14, 'CUU/BIT/2024/099', 'ICT', 'Bachelor of IT', 1),
(15, 'CUU/IR/2024/100', 'Socio-Econ', 'International Relations', 2);

-- 2.3 Courses (5 Focus Courses)
INSERT INTO courses (code, name, credits) VALUES
('BIT212', 'System Analysis & Design', 4),
('CSC101', 'Introduction to C++', 4),
('LAW101', 'Constitutional Law', 3),
('MGT201', 'Principles of Management', 3),
('BIT213', 'Database Systems', 4);

-- 2.4 Enrollments (Mixed for testing)
INSERT INTO enrollments (student_id, course_id, semester, academic_year) VALUES
(1, 1, 'SEM 1', '2023/2024'), (1, 5, 'SEM 1', '2023/2024'),
(2, 1, 'SEM 1', '2023/2024'), (2, 2, 'SEM 1', '2023/2024'),
(3, 4, 'SEM 1', '2023/2024'),
(5, 3, 'SEM 1', '2023/2024'),
(9, 1, 'SEM 1', '2023/2024'), (9, 2, 'SEM 1', '2023/2024');

-- 2.5 Fee Tracking (Real-time Ledger Data)
-- Mary Atwine: Partial (Blocked)
INSERT INTO fees (student_id, total_due, paid_amount, status) VALUES
(1, 4500000.00, 2000000.00, 'Partial');
-- John Musoke: Fully Paid (Allowed)
INSERT INTO fees (student_id, total_due, paid_amount, status) VALUES
(2, 4500000.00, 4500000.00, 'Fully Paid');
-- Peter Bukenya: Unpaid (Blocked)
INSERT INTO fees (student_id, total_due, paid_amount, status) VALUES
(9, 4500000.00, 0.00, 'Unpaid');
-- Others mostly Paid for demo
INSERT INTO fees (student_id, total_due, paid_amount, status) VALUES
(3, 3000000.00, 3000000.00, 'Fully Paid'),
(5, 5000000.00, 5000000.00, 'Fully Paid');

-- 2.6 Result Management (Grades)
INSERT INTO marks (enrollment_id, coursework_score, exam_score, grade, recorded_by) VALUES
(1, 25.5, 50.0, 'B+', 4), -- Mary BIT212
(2, 28.0, 55.0, 'A', 4),  -- Mary BIT213
(3, 20.0, 45.5, 'C+', 5), -- John BIT212
(4, 29.0, 60.0, 'A+', 5); -- John CSC101
