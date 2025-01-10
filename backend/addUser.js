const bcrypt = require('bcrypt');
const connection = require('./models/db');

async function addUser(username, password) {
    try {
        const hashedPassword = await bcrypt.hash(password, 10);
        const [result] = await connection.execute(
            'INSERT INTO users (username, password) VALUES (?, ?)',
            [username, hashedPassword]
        );
        console.log('User added successfully:', result);
    } catch (error) {
        console.error('Error adding user:', error);
    } finally {
        connection.end();
    }
}

// Gantilah 'admin' dan 'admin' dengan username dan password yang diinginkan
addUser('lanal', 'hangnadim');