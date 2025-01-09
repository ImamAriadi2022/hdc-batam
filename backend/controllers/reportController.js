const connection = require('../models/db');
const Report = require('../models/reportModel');
const Notification = require('../models/notificationModel');
const sharp = require('sharp');

exports.getAllReports = async (req, res) => {
    console.log('Fetching all reports');
    try {
        const reports = await Report.findAll();
        res.json(reports);
    } catch (error) {
        console.error('Error fetching reports:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
};

exports.createReport = async (req, res) => {
    const { tingkatSiaga, deskripsi, lokasi, jumlahPenumpang, jenisPesawat, statusAncaman } = req.body;
    const userId = req.user.id; // Ambil userId dari req.user
    console.log(`Creating report with tingkatSiaga: ${tingkatSiaga}`);

    // Validasi input
    if (!tingkatSiaga || !deskripsi || !lokasi || !jumlahPenumpang || !jenisPesawat || !statusAncaman || !userId) {
        console.log('Missing required fields');
        return res.status(400).json({ message: 'Missing required fields' });
    }

    let compressedImageBuffer = null;
    if (req.file) {
        try {
            compressedImageBuffer = await sharp(req.file.buffer)
                .resize({ width: 800 }) // Resize image to width 800px (height auto)
                .jpeg({ quality: 80 })  // Compress image with 80% quality
                .toBuffer();
        } catch (sharpError) {
            console.error('Error compressing image:', sharpError);
            return res.status(500).json({ message: 'Error processing image' });
        }
    }

    try {
        const reportId = await Report.create(tingkatSiaga, deskripsi, lokasi, jumlahPenumpang, jenisPesawat, statusAncaman, compressedImageBuffer, userId);
        console.log('Report created successfully');

        // Create notification
        const message = `Laporan baru dengan tingkat siaga ${tingkatSiaga} telah ditambahkan.`;
        await Notification.create(userId, message);

        res.status(201).json({ id: reportId });
    } catch (error) {
        console.error('Error creating report:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
};
