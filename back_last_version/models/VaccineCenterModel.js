const mongoose = require('mongoose');
const validator = require('validator');

// Define the vaccine center schema
const vaccineCenterSchema = new mongoose.Schema({
    name: {
        type: String,
        required: [true, 'A vaccine center must have a name'],
        trim: true
    },
    address: {
        type: String,
        required: [true, 'A vaccine center must have an address'],
        trim: true
    },
    phone: {
        type: String,
        required: [true, 'A vaccine center must have a phone number'],
    }
});

// Create the model from the schema
const VaccineCenter = mongoose.model('VaccineCenter', vaccineCenterSchema);

module.exports = VaccineCenter;
