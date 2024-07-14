const express = require('express');
const router = express.Router();
const VaccineController = require('../controllers/VaccineCenterController');

const verifyToken = require('../middlewares/verifyToken');

router.post('/', VaccineController.createVaccineCenter);
router.get('/', VaccineController.getAllVaccineCenters);
router.get('/inCity',verifyToken,VaccineController.getVaccineCentersInCity);
router.put('/:id', VaccineController.updateVaccineCenter);
router.delete('/:id', VaccineController.deleteVaccineCenter);

module.exports = router;
