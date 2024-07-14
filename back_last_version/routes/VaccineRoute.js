const express = require('express');
const router = express.Router();
const VaccineController = require('../controllers/VaccineController');
const verifyToken = require('../middlewares/verifyToken');

router.post('/', VaccineController.uploadVaccine);
router.get('/', VaccineController.getVaccines);
router.get('/:id', VaccineController.getVaccineById);
router.put('/:id', VaccineController.updateVaccine);
router.delete('/:id', VaccineController.deleteVaccine);
router.get('/age/:age', verifyToken,VaccineController.getVaccinesByAge);


module.exports = router;
