const express = require('express');
const router = express.Router();
const verifyToken = require('../middlewares/verifyToken');

const {
    addAppointment,
    updateAppointment,
    deleteAppointment,
    getAppointments,
    getAllAppointments
} = require('../controllers/AppointmentController');

router.route('/').post(verifyToken,addAppointment);

router.route('/:id').put(updateAppointment);

router.route('/:id').delete(deleteAppointment);

// router.route('/search').post(verifyToken,getAppointments);
router.route('/').get(verifyToken,getAllAppointments);

module.exports = router;
