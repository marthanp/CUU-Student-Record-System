const fs = require('fs');
const path = require('path');

// Load Mock Database for Prototype
const users = JSON.parse(fs.readFileSync(path.join(__dirname, 'users.json'), 'utf8'));

const db = {
    execute: async (query, params) => {
        console.log(`Executing: ${query} with params: ${params}`);
        
        // Mocking 'SELECT * FROM users WHERE username = ? AND password = ?'
        if (query.includes('SELECT * FROM users WHERE username = ? AND password = ?')) {
            const user = users.find(u => u.username === params[0] && u.password === params[1]);
            return user ? [user] : [];
        }

        // Mocking 'SELECT balance FROM fees WHERE student_id = ?'
        if (query.includes('SELECT balance FROM fees WHERE student_id = ?')) {
            const user = users.find(u => u.id == params[0]);
            // Return as an array containing one object (simulating mysql2)
            return user ? [{ balance: user.balance }] : [];
        }

        // Mocking 'SELECT * FROM students s JOIN users u ON s.user_id = u.id WHERE s.id = ?'
        if (query.includes('SELECT * FROM students s JOIN users u ON s.user_id = u.id WHERE s.id = ?')) {
            const user = users.find(u => u.id == params[0]);
            return user ? [user] : [];
        }

        return []; 
    }
};

module.exports = db;
