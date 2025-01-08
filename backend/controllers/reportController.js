const connection = require('../models/db');

exports.getAllReports = async (req, res) => {
    console.log('Fetching all reports');
    try {
        const [rows] = await connection.execute('SELECT * FROM reports');
        res.json(rows);
    } catch (error) {
        console.error('Error fetching reports:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
};

exports.createReport = async (req, res) => {
    const { title, description, category, userId } = req.body;
    console.log(`Creating report with title: ${title}`);
    try {
        const [result] = await connection.execute(
            'INSERT INTO reports (title, description, category, userId) VALUES (?, ?, ?, ?)',
            [title, description, category, userId]
        );
        console.log('Report created successfully');
        res.status(201).json({ id: result.insertId });
    } catch (error) {
        console.error('Error creating report:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
};