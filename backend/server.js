const express = require('express');
const cors = require('cors');
const systemController = require('./controllers/systemController');

const db = require('./db');

const app = express();
app.use(cors());
app.use(express.json());


// ROUTE MAPPING TO MODULES (SDLC: Implementation Phase)

// 1. Auth Module
app.post('/api/auth/login', systemController.login);

// 2. Student Registration Module
app.post('/api/students/register', systemController.registerStudent);

// 3. Course Registration Module
app.post('/api/courses/enroll', systemController.enrollInCourse);

// 4. Finance Tracker Module
app.get('/api/finance/ledger/:studentId', systemController.getFeeLedger);

// 5. Result Management Module (Includes Financial Interlock)
app.get('/api/academic/results/:studentId', systemController.getAcademicResults);

// 6. Report Generation Module
app.get('/api/academic/transcript/:studentId', systemController.generateTranscript);

const PORT = 5000;
app.listen(PORT, () => {
    console.log(`CUU SYSTEM Backend running on port ${PORT}`);
    console.log('All six core modules successfully initialized.');
});
