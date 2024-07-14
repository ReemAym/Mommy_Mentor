const mongoose = require('mongoose');
const validator = require('validator');


const DoctorSchema = new mongoose.Schema({
    firstName: {
        type: String,
        required: [true, 'Please provide a first name']
    },
    lastName: {
        type: String,
        required: [true, 'Please provide a last name']
    },
    phone: {
        type: String,
        required: [true, 'Please provide a phone number']
    },
    specialization: {
        type: String,
        required: [true, 'Please provide a specialization']
    },
    degree: {
        type: String,
        required: [true, 'Please provide a degree']
    },
    workPlace:{
        type: String,
        required: [true, 'Please provide a workplace']
    },
    description: {
        type: String
    },
    email: {
        type: String,
        required: [true, 'Please provide an email'],
        unique: true
    },
    password:{
        type: String,
        required: [true, 'Please provide a password']
    },
    online: {
        type: Boolean,
        default: false
    },
    token : {
        type: String
    }
},{timestamps: true});
DoctorSchema.pre('save', function(next) {
    this.name = `${this.firstName} ${this.lastName}`;
    next();
});

// const Doctor = Receiver.discriminator('Doctor', DoctorSchema);

// module.exports = Doctor;
const DoctorModel = mongoose.model('Doctor', DoctorSchema);
module.exports = DoctorModel;