const Chat = require('../models/Chat');
const ApiError = require('../utils/ApiError');

// Controller function to send a message
exports.sendMessage = async (req, res, next) => {
    try {
        const { sender, senderModel, receiver, receiverModel, message } = req.body;

        console.log(sender, senderModel, receiver, receiverModel, message);
        const chat = new Chat({ sender, senderModel, receiver, receiverModel, message });
        console.log(chat);
        await chat.save();

        res.status(201).json({
            success: true,
            data: chat
        });
    } catch (err) {
        next(new ApiError('Error sending message', 500, err.message));
    }
};

// Controller function to fetch chat history
// exports.getChatHistory = async (req, res, next) => {
//     try {
//         const { senderId, receiverId } = req.query;

//         const chats = await Chat.find({
//             $or: [
//                 { sender: senderId, receiver: receiverId },
//                 { sender: receiverId, receiver: senderId }
//             ]
//         }).sort({ timestamp: 1 });

//         console.log()
//         res.status(200).json({
//             success: true,
//             data: chats
//         });
//     } catch (err) {
//         next(new ApiError('Error fetching chat history', 500, err.message));
//     }
// };


exports.getChatHistory = async (req, res) => {
    const { userId, userModel, contactId, contactModel } = req.query;

    try {
        const chatHistory = await Chat.find({
            $or: [
                { sender: userId, senderModel: userModel, receiver: contactId, receiverModel: contactModel },
                { sender: contactId, senderModel: contactModel, receiver: userId, receiverModel: userModel }
            ]
        }).sort({ timestamp: 1 });

        res.status(200).json({ success: true, chatHistory: chatHistory });
    } catch (error) {
        res.status(500).json({ success: false, error: 'Error retrieving chat history', details: error.message });
    }
};


// exports.getChatHistory = async (req, res) => {
//     const { userId, userModel, contactId, contactModel } = req.query;

//     try {
//         const chatHistory = await Chat.find({
//             $or: [
//                 { sender: userId, senderModel: userModel, receiver: contactId, receiverModel: contactModel },
//                 { sender: contactId, senderModel: contactModel, receiver: userId, receiverModel: userModel }
//             ]
//         }).sort({ timestamp: 1 });

//         // Mark all messages as read for this user with contact
//         await Chat.updateMany(
//             { sender: contactId, receiver: userId, isRead: false },
//             { $set: { isRead: true } }
//         );

//         const unreadCount = await Chat.countDocuments({
//             sender: contactId,
//             receiver: userId,
//             isRead: false
//         });

//         res.status(200).json({ success: true, chatHistory: chatHistory, unreadCount: unreadCount });
//     } catch (error) {
//         res.status(500).json({ success: false, error: 'Error retrieving chat history', details: error.message });
//     }
// };


