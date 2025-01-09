const connection = require('./db');

const Report = {
    findAll: async () => {
        const [rows] = await connection.execute('SELECT * FROM reports');
        return rows;
    },

    create: async (tingkatSiaga, deskripsi, lokasi, jumlahPenumpang, jenisPesawat, statusAncaman, imageFile, userId) => {
        const [result] = await connection.execute(
            'INSERT INTO reports (tingkatSiaga, deskripsi, lokasi, jumlahPenumpang, jenisPesawat, statusAncaman, imageFile, userId) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
            [tingkatSiaga, deskripsi, lokasi, jumlahPenumpang, jenisPesawat, statusAncaman, imageFile, userId]
        );
        return result.insertId;
    },

    findByUserId: async (userId) => {
        const [rows] = await connection.execute('SELECT * FROM reports WHERE userId = ?', [userId]);
        return rows;
    },

    deleteById: async (id) => {
        await connection.execute('DELETE FROM reports WHERE id = ?', [id]);
    },
};

module.exports = Report;