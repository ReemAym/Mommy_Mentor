const express = require('express');
const router = express.Router();
const verifyToken = require('../middlewares/verifyToken');

const {
    getAllDoctors,
    getSpecificDoctor,
    register,
    updateDoctor,
    deleteDoctor,
    getDoctorByEmail,
    updateDoctorByEmail,
    deleteDoctorByEmail,
    updateDoctorStatus,
    getOnlineDoctors
} = require('../controllers/DoctorController');

router.route('/all')
    .get(getAllDoctors);

router.route('/online')
    .get(verifyToken,getOnlineDoctors);

router.route('/')
    .get(getDoctorByEmail)
    .put(updateDoctorByEmail)
    .delete( deleteDoctorByEmail)
    .post(register);

router.route('/:id')
    .get(getSpecificDoctor)
    .put(verifyToken,updateDoctor)
    .delete(deleteDoctor);

router.route('/:id/status')
    .put(verifyToken,updateDoctorStatus);

module.exports = router;
