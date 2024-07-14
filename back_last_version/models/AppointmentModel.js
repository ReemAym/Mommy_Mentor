const mongoose = require('mongoose');
const validator = require('validator');

const AppointmentSchema = new mongoose.Schema({
    address: {
        type: String,
        required: [true, 'Please provide an address'],
        trim: true
    },
    fee: {
        type: Number,
        required: [true, 'Please provide a fee'],
        min: [0, 'Fee must be a positive number']
    },
    date: {
        type: Date,
        required: [true, 'Please provide a date'],
        validate: {
            validator: function(v) {
                return v >= Date.now();
            },
            message: 'Date must be in the future'
        }
    },
    token: {
        type: String,
        validate: {
            validator: function(v) {
                return validator.isUUID(v);
            },
            message: 'Token must be a valid UUID'
        }
    },
    doctor: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Doctor',
        required: [true, 'Please provide a doctor ID']
    },
    doctorName: {
        type: String
    }
}, {timestamps: true});

// Virtual to dynamically populate doctorName
AppointmentSchema.virtual('fullDoctorName', {
    ref: 'Doctor',
    localField: 'doctor',
    foreignField: '_id',
    justOne: true,
    options: { select: function() {
        return 'firstName lastName'; // Concatenate the fields you need
    } }
});

const AppointmentModel = mongoose.model('Appointment', AppointmentSchema);

module.exports = AppointmentModel;
