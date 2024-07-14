const mongoose = require('mongoose');
const validator = require('validator');

const ArticleSchema = new mongoose.Schema({
    title: {
        type: String,
        required: [true, 'Please provide a title'],
        trim: true, // Removes whitespace from both ends of a string
    },
    category: {
        type: String, 
        required: [true, 'Please provide a category'],
        trim: true,
    },
    content: {
        type: String,
        required: [true, 'Please provide content'],
        trim: true,
    },
    date: {
        type: Date,
        default: Date.now
    },
    token: {
        type: String,
        default: '', // Default to an empty string if not provided
        trim: true
    }
}, {timestamps: true});

const ArticleModel = mongoose.model('Article', ArticleSchema);

module.exports = ArticleModel;