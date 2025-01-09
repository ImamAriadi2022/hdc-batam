exports.uploadImage = (req, res) => {
    res.json({ url: `/uploads/${req.file.filename}` });
};