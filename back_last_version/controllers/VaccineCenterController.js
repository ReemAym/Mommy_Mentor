const VaccineCenter = require('../models/VaccineCenterModel');

// Function to extract the city from the address (this is a simple example; in a real-world scenario, you might want to use a library or API for better accuracy)
const extractCityFromAddress = (address) => {
    const parts = address.split(',').map(part => part.trim());
    console.log(parts);
    return parts.length >= 2 ? parts[1] : null;
};


// Controller functions
exports.createVaccineCenter = async (req, res) => {
    try {
        const newCenter = await VaccineCenter.create(req.body);
        res.status(201).json({
        status: 'success',
        data: {
            vaccineCenter: newCenter
        }
        });
    } catch (err) {
        res.status(400).json({
        status: 'fail',
        message: err.message
        });
    }
    };

    exports.getAllVaccineCenters = async (req, res) => {
    try {
        const centers = await VaccineCenter.find();
        res.status(200).json({
        status: 'success',
        results: centers.length,
        data: {
            vaccineCenters: centers
        }
        });
    } catch (err) {
        res.status(400).json({
        status: 'fail',
        message: err.message
        });
    }
};

exports.getVaccineCentersInCity = async (req, res) => {
    try {
    const { address } = req.query;
    if (!address) {
        return res.status(400).json({
            status: 'fail',
            message: 'Address is required'
        });
    }

    const city = extractCityFromAddress(address);
    if (!city) {
        return res.status(400).json({
            status: 'fail',
            message: 'City could not be determined from the address'
        });
    }

    const centers = await VaccineCenter.find();
    const centersInCity = centers.filter(center => {
        const centerCity = extractCityFromAddress(center.address);
        return centerCity && centerCity.toLowerCase() === city.toLowerCase();
    });

    res.status(200).json({
        status: 'success',
        results: centersInCity.length,
        data: {
            vaccineCenters: centersInCity
        }
    });
} catch (err) {
    res.status(400).json({
        status: 'fail',
        message: err.message
    });
    }
};

exports.updateVaccineCenter = async (req, res) => {
    try {
        const center = await VaccineCenter.findByIdAndUpdate(req.params.id, req.body, {
            new: true,
            runValidators: true
        });
        if (!center) {
            return res.status(404).json({
                status: 'fail',
                message: 'Vaccine center not found'
            });
        }
        res.status(200).json({
            status: 'success',
            data: {
                vaccineCenter: center
            }
        });
    } catch (err) {
        res.status(400).json({
            status: 'fail',
            message: err.message
        });
    }
};

exports.deleteVaccineCenter = async (req, res) => {
    try {
        const center = await VaccineCenter.findByIdAndDelete(req.params.id);
        if (!center) {
            return res.status(404).json({
                status: 'fail',
                message: 'Vaccine center not found'
            });
        }
        res.status(204).json({
            status: 'success',
            data: null
        });
    } catch (err) {
        res.status(400).json({
            status: 'fail',
            message: err.message
        });
    }
};
