const express = require('express')
const route = express.Router()
const verifyToken = require('../middlewares/verifyToken')

const {
    login 
} = require('../controllers/LogInController');

route.route('/').post(login);
module.exports = route;