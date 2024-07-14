const VaccineModel = require('../models/VaccineModel');

// Create a new vaccine record
exports.uploadVaccine = async (req, res) => {
    try {
        const vaccine = new VaccineModel(req.body);
        await vaccine.save();
        res.status(201).json({ success: true, data: vaccine });
    } catch (error) {
        res.status(400).json({ success: false, error: error.message });
    }
};

// Get all vaccine records
exports.getVaccines = async (req, res) => {
    try {
        const vaccines = await VaccineModel.find();
        res.status(200).json({ success: true, data: vaccines });
    } catch (error) {
        res.status(400).json({ success: false, error: error.message });
    }
};

// Get a single vaccine record by ID
exports.getVaccineById = async (req, res) => {
    try {
        const vaccine = await VaccineModel.findById(req.params.id);
        if (!vaccine) {
            return res.status(404).json({ success: false, error: 'Vaccine record not found' });
        }
        res.status(200).json({ success: true, data: vaccine });
    } catch (error) {
        res.status(400).json({ success: false, error: error.message });
    }
};

// Update a vaccine record by ID
exports.updateVaccine = async (req, res) => {
    try {
        const vaccine = await VaccineModel.findByIdAndUpdate(req.params.id, req.body, {
            new: true,
            runValidators: true,
        });
        if (!vaccine) {
            return res.status(404).json({ success: false, error: 'Vaccine record not found' });
        }
        res.status(200).json({ success: true, data: vaccine });
    } catch (error) {
        res.status(400).json({ success: false, error: error.message });
    }
};

// Delete a vaccine record by ID
exports.deleteVaccine = async (req, res) => {
    try {
        const vaccine = await VaccineModel.findByIdAndDelete(req.params.id);
        if (!vaccine) {
            return res.status(404).json({ success: false, error: 'Vaccine record not found' });
        }
        res.status(200).json({ success: true, data: {} });
    } catch (error) {
        res.status(400).json({ success: false, error: error.message });
    }
};

// Get vaccine records by age
exports.getVaccinesByAge = async (req, res) => {
    try {
        const age = parseInt(req.params.age);
        if (isNaN(age)) {
            return res.status(400).json({ success: false, error: 'Invalid age parameter' });
        }
        const vaccines = await VaccineModel.find({ age: age });
        res.status(200).json({ success: true, data: vaccines });
    } catch (error) {
        res.status(400).json({ success: false, error: error.message });
    }
};
