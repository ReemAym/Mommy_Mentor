const mongoose = require('mongoose');
const validator = require('validator');

const NormalGrowthSchema = new mongoose.Schema({
    gender: {
        type: String,
        required: [true, 'Please provide the gender'] 
    },
    month: {
        type: String,
        required: [true, 'Please provide the month']
    },
    fromNormalHeight: {
        type: Number,
        required: [true, 'Please provide the fromNormalHeight']
    }
    ,
    toNormalHeight: {
        type: Number,
        required: [true, 'Please provide the toNormalHeight']
    },
    fromNormalWeight: {
        type: Number,
        required: [true, 'Please provide the fromNormalWeight']
    },
    toNormalWeight: {
        type: Number,
        required: [true, 'Please provide the toNormalWeight']
    },
    fromNormalHeadCircumference: {
        type: Number,
        required: [true, 'Please provide the fromNormalHeadCircumference']
    },
    toNormalHeadCircumference: {
        type: Number,
        required: [true, 'Please provide the toNormalHeadCircumference']
    },
    token : {
        type: String
    }
},{timestamps: true});

const NormalGrowthModel = mongoose.model('NormalGrowth', NormalGrowthSchema);
module.exports = NormalGrowthModel;