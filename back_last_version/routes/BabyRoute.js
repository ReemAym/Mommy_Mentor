// Import required modules
const express = require('express');
const route = express.Router();
const verifyToken = require('../middlewares/verifyToken');

// Import controllers
const {
    getAllBabies,
    getSpecificBaby,
    register,
    updateBaby,
    deleteBaby,
    getBabyByEmail, // Import the controller function
    deleteBabyByEmail,
    updateBabyByEmail,
    getMonthlyMeasurements,
    addMonthlyMeasurement,
    getAllMonthlyMeasurements

} = require('../controllers/BabyController');

// Define routes
route.route('/all').get(getAllBabies);
route.route('/').post(register);
route.route('/:id').get(getSpecificBaby).put(updateBaby).delete(verifyToken,deleteBaby);
route.route('/').get(getBabyByEmail); // Define route for getBabyByEmail
route.route('/').put(updateBabyByEmail).delete(deleteBabyByEmail);
// route.route('/login').post(login);

// Route to get monthly measurements
route.route('/measurements/:month/:id').get(getMonthlyMeasurements);
route.route('/measurements/:id').post(verifyToken,addMonthlyMeasurement);
route.route('/measurements/:id').get(verifyToken,getAllMonthlyMeasurements);
// Export the router
module.exports = route;
