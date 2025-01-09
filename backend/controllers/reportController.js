const connection = require('../models/db');
const Report = require('../models/reportModel');
const Notification = require('../models/notificationModel');
const sharp = require('sharp');
const path = require('path');
const fs = require('fs');

exports.getAllReports = async (req, res) => {
    console.log('Fetching all reports');
    try {
        const reports = await Report.findAll();
        const reportsWithImagePath = reports.map(report => {
            if (report.imageFile) {
                const imagePath = path.join(__dirname, '..', 'uploads', `${report.id}.jpg`);
                fs.writeFileSync(imagePath, report.imageFile);
                report.imagePath = `/uploads/${report.id}.jpg`;
                delete report.imageFile;
            }
            return report;
        });
        res.json(reportsWithImagePath);
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

exports.updateReport = async (req, res) => {
    const { id } = req.params;
    const { tingkatSiaga, deskripsi, lokasi, jumlahPenumpang, jenisPesawat, statusAncaman } = req.body;
    const userId = req.user.id; // Ambil userId dari req.user
    console.log(`Updating report with id: ${id}`);

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
        await Report.update(id, tingkatSiaga, deskripsi, lokasi, jumlahPenumpang, jenisPesawat, statusAncaman, compressedImageBuffer, userId);
        console.log('Report updated successfully');
        res.status(200).json({ message: 'Report updated successfully' });
    } catch (error) {
        console.error('Error updating report:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
};

exports.deleteReport = async (req, res) => {
    const { id } = req.params;
    console.log(`Deleting report with id: ${id}`);

    try {
        const report = await Report.findById(id);
        if (report && report.imageFile) {
            const imagePath = path.join(__dirname, '..', 'uploads', `${id}.jpg`);
            if (fs.existsSync(imagePath)) {
                fs.unlinkSync(imagePath);
            }
        }

        await Report.deleteById(id);
        console.log('Report deleted successfully');
        res.status(200).json({ message: 'Report deleted successfully' });
    } catch (error) {
        console.error('Error deleting report:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
};