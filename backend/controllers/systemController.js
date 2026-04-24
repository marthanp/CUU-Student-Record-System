/**
 * CUU SYSTEM - CORE CONTROLLERS
 * SDLC Phase: Implementation & Integration
 * This file contains the logic for the six core modules.
 */

const db = require('../db'); // Assuming a DB connection module exists

// 1. MODULE: USER AUTHENTICATION
exports.login = async (req, res) => {
    const { username, password } = req.body;
    // SDLC: Authentication logic
    const [user] = await db.execute('SELECT * FROM users WHERE username = ? AND password = ?', [username, password]);
    if (!user) return res.status(401).json({ error: 'Authentication failed' });
    res.json({ message: 'Welcome', user: { id: user.id, role: user.role, name: user.full_name } });
};

// 2. MODULE: STUDENT REGISTRATION
exports.registerStudent = async (req, res) => {
    const { fullName, regNumber, department, program } = req.body;
    // SDLC: Profile storage logic
    const [result] = await db.execute(
        'INSERT INTO students (user_id, reg_number, department, program) VALUES (?, ?, ?, ?)',
        [req.user.id, regNumber, department, program]
    );
    res.json({ message: 'Student registered successfully', id: result.insertId });
};

// 3. MODULE: COURSE REGISTRATION (Enrollment)
exports.enrollInCourse = async (req, res) => {
    const { studentId, courseId, semester } = req.body;
    // SDLC: Validation - Prevent duplicate enrollment
    const [exists] = await db.execute('SELECT id FROM enrollments WHERE student_id = ? AND course_id = ?', [studentId, courseId]);
    if (exists) return res.status(400).json({ error: 'Already enrolled in this course' });

    await db.execute(
        'INSERT INTO enrollments (student_id, course_id, semester) VALUES (?, ?, ?)',
        [studentId, courseId, semester]
    );
    res.json({ message: 'Enrolled successfully' });
};

// 4. MODULE: FINANCE & PAYMENT TRACKING
exports.getFeeLedger = async (req, res) => {
    const { studentId } = req.params;
    // SDLC: Real-time Ledger Retrieval
    const [ledger] = await db.execute('SELECT total_due, paid_amount, balance, status FROM fees WHERE student_id = ?', [studentId]);
    res.json(ledger || { message: 'No financial records found' });
};

// 5. MODULE: RESULT MANAGEMENT (The "Interlock" Logic)
exports.getAcademicResults = async (req, res) => {
    const { studentId } = req.params;

    try {
        // --- THE EXTRAORDINARY INTERLOCK FUNCTION ---
        // SDLC: Security/Business Logic Phase
        const [feeInfo] = await db.execute('SELECT balance FROM fees WHERE student_id = ?', [studentId]);
        
        if (feeInfo && feeInfo.balance > 0) {
            return res.status(403).json({
                error: 'Results Blocked',
                reason: 'Financial Outstanding: ' + feeInfo.balance + ' UGX',
                instruction: 'Please visit the Finance Office or pay via the mobile portal.'
            });
        }
        // ---------------------------------------------

        // If fees are clear, proceed with Mark Retrieval
        const [results] = await db.execute(`
            SELECT c.code, c.name, m.total_score, m.grade 
            FROM marks m
            JOIN enrollments e ON m.enrollment_id = e.id
            JOIN courses c ON e.course_id = c.id
            WHERE e.student_id = ?
        `, [studentId]);

        res.json({ studentId, results });

    } catch (err) {
        res.status(500).json({ error: 'System processing error' });
    }
};

// 6. MODULE: REPORT GENERATION (Transcripts)
exports.generateTranscript = async (req, res) => {
    const { studentId } = req.params;
    // SDLC: Document Generation logic
    // This would typically involve a PDF library like PDFKit, 
    // but here we provide the data structure for the report.
    const [student] = await db.execute('SELECT * FROM students s JOIN users u ON s.user_id = u.id WHERE s.id = ?', [studentId]);
    const [results] = await db.execute('SELECT * FROM marks ...'); // Reuse result logic
    
    res.json({
        reportHeader: 'CAVENDISH UNIVERSITY UGANDA - OFFICIAL TRANSCRIPT',
        studentInfo: student,
        academicHistory: results,
        generatedAt: new Date().toISOString()
    });
};
