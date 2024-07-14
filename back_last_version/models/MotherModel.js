const mongoose = require('mongoose');
const validator = require('validator');
const nameValidator = [
    {
      validator: function(value) {
        return /^[a-zA-Z\s]+$/.test(value); // Check if value contains only letters
      },
      message: 'Only letters are allowed for {PATH}'
    }
  ];
  
  const addressValidator = [
    {
      validator: function(value) {
        // Allow letters (a-z, A-Z), numbers (0-9), spaces (\s), dash (-), forward slash (/), and backslash (\)
        return /^[a-zA-Z0-9\s\-,.]+$/.test(value);
      },
      message: 'Only alphanumeric characters, spaces, -, /, and \\ are allowed for {PATH}'
    }
  ];
const MotherSchema = new mongoose.Schema({
    name: {
        type: String,
        required: [true, 'Please provide a name'],
        trim: true,
        validate: nameValidator
    },
    email: {
        type: String,
        required: [true, 'Please provide an email'],
        unique: true,
        validate: [validator.isEmail, 'Please provide a valid email']
    },
    password: {
        type: String,
        required: [true, 'Please provide a password']
    },
    address: {
        type: String,
        required: [true, 'Please provide an address'],
        validate: addressValidator
    },
    babies: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Baby'
    }],
    currentIndex: {
        type: Number,
        required: [true, 'Please provide the fromNormalHeight']
    },
    online: {
      type: Boolean,
      default: false
  },
    token: {
        type: String
    },
}, {timestamps: true});

const MotherModel = mongoose.model('Mother', MotherSchema);
module.exports = MotherModel;
