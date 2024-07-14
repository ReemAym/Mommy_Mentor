const express = require('express');
const router = express.Router();
const verifyToken = require('../middlewares/verifyToken');

const {
    createMother,
    getAllMothers,
    getMotherById,
    updateMother,
    editCurrentIndexForMother,
    deleteMother,
    addBabyToMother,
    getBabyById,
    getAllBabiesForMother,
    deleteBabyByIdForMother,
    updateMotherStatus,
    getOnlineMothers
} = require('../controllers/MotherController');

router.route('/')
    .post(createMother);

router.route('/all')
    .get(getAllMothers);

router.route('/online')
    .get(verifyToken,getOnlineMothers);
    
router.route('/:id')
    .get(getMotherById)
    .put(verifyToken,updateMother)
    .delete( deleteMother);

router.route('/:motherId/editCurrentIndex')
    .put(verifyToken,editCurrentIndexForMother);

router.route('/:motherId/babies')
    .post( verifyToken,addBabyToMother)
    .get(verifyToken,getAllBabiesForMother);

router.route('/:motherId/babies/:babyId')
    .get(getBabyById)
    .delete( deleteBabyByIdForMother);

router.route('/:motherId/status')
    .put(verifyToken,updateMotherStatus);


module.exports = router;
