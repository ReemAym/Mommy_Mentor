const mongoose = require('mongoose');
const validator = require('validator');

const VaccineSchema = new mongoose.Schema({
    age: {
        type: Number,
        required: [true, 'Please provide the age'],
        min: [0, 'Age cannot be negative']
    },
    vaccine: {
        type: String,
        required: [true, 'Please provide the vaccine name'],
        trim: true
    },
    diseases: {
        type: [String], // Array of strings for multiple diseases
        required: [true, 'Please provide the disease(s) the vaccine protects against'],
        validate: {
            validator: function (value) {
                return value.length > 0;
            },
            message: 'Please provide at least one disease'
        }
    },
    dosage: {
        type: String,
        required: [true, 'Please provide the dosage information'],
        trim: true
    },
    adminstrationMethod: {
        type: String,
        required: [true, 'Please specify the method of applying the vaccine'],
        trim: true
    }
}, { timestamps: true });

const VaccineModel = mongoose.model('Vaccine', VaccineSchema);

module.exports = VaccineModel;
