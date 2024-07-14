const mongoose = require('mongoose');

const adviceSchema = new mongoose.Schema({
    title: {
        type: String,
        required: [true, 'Advice must have a title']
    },
    content: {
        type: String,
        required: [true, 'Advice must have content']
    },
    age: {
        type: Number,
        required: [true, 'Advice must have an age']
    }
}, {
    timestamps: true
});

const Advice = mongoose.model('Advice', adviceSchema);

module.exports = Advice;
