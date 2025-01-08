const express = require('express');
const { getAllReports, createReport } = require('../controllers/reportController');
const router = express.Router();

router.get('/', getAllReports);
router.post('/', createReport);

module.exports = router;
