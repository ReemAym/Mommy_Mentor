// 

const mongoose = require('mongoose');
const { Schema } = mongoose;

const chatSchema = new mongoose.Schema({
    sender: {
        type: Schema.Types.ObjectId,
        required: true,
        refPath: 'senderModel'
    },
    senderModel: {
        type: String,
        required: true,
        enum: ['Mother', 'Doctor']
    },
    receiver: {
        type: Schema.Types.ObjectId,
        required: true,
        refPath: 'receiverModel'
    },
    receiverModel: {
        type: String,
        required: true,
        enum: ['Mother', 'Doctor']
    },
    message: {
        type: String,
        required: true
    },
    timestamp: {
        type: Date,
        default: Date.now
    },
    isRead: {
        type: Boolean,
        default: false
    }
}, { timestamps: true });

const Chat = mongoose.model('Chat', chatSchema);

module.exports = Chat;
