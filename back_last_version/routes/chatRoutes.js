const express = require('express');
const router = express.Router();
const chatController = require('../controllers/chatController');
const verifyToken = require('../middlewares/verifyToken');

router.post('/send',verifyToken ,chatController.sendMessage);
router.get('/history',verifyToken, chatController.getChatHistory);
// router.get('/unread-counts/:userId/:userModel', chatController.getUnreadMessageCounts);

module.exports = router;
