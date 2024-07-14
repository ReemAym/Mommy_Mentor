const mongoose = require('mongoose');
const validator = require('validator');

const nameValidator = [
  {
    validator: function(value) {
      return /^[a-zA-Z\s]+$/.test(value); // Check if value contains only letters and spaces
    },
    message: 'Only letters and spaces are allowed for {PATH}'
  }
];

const BabySchema = new mongoose.Schema({
  firstname: {
    type: String,
    required: [true, 'Please provide a first name'],
    trim: true,
    minlength: [3, 'First name should be at least 3 characters long'],
    maxlength: [10, 'First name should not exceed 10 characters'],
    validate: nameValidator
  },
  lastname: {
    type: String,
    required: [true, 'Please provide a last name'],
    trim: true,
    minlength: [3, 'Last name should be at least 3 characters long'],
    maxlength: [10, 'Last name should not exceed 10 characters'],
    validate: nameValidator
  },
  birthdate: {
    type: Date,
    required: [true, 'Please provide a birthdate']
  },
  gender: {
    type: String,
    required: [true, 'Please provide a gender']
  },
  weight: {
    type: Number
  },
  height: {
    type: Number
  },
  headCircumference: {
    type: Number
  },
  token: {
    type: String
  },
  measurements: [{
    month: {
      type: Number,
      required: [true, 'Please provide the month (number of months) of the measurement'],
      min: [0, 'Month should be 0 or greater']
    },
    height: {
      type: Number,
      required: [true, 'Please provide the height']
    },
    weight: {
      type: Number,
      required: [true, 'Please provide the weight']
    },
    headCircumference: {
      type: Number,
      required: [true, 'Please provide the head circumference']
    }
  }]
}, { timestamps: true });

BabySchema.pre('save', function(next) {
  this.name = `${this.firstname} ${this.lastname}`;
  next();
});

const BabyModel = mongoose.model('Baby', BabySchema);
module.exports = BabyModel;
