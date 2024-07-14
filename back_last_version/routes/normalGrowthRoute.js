const express = require('express')
const route = express.Router()
const verifyToken = require('../middlewares/verifyToken')

const{getAllNormalGrowthByGenderAndAge,createNormalGrowth,checkNormalGrowth}=require('../controllers/normalGrowthController')

route.route('/').get(verifyToken,getAllNormalGrowthByGenderAndAge)
route.route('/').post(createNormalGrowth)
route.route('/check').post(verifyToken,checkNormalGrowth)

module.exports = route