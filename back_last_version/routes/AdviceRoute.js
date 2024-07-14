const express = require('express');
const router = express.Router();
const verifyToken = require('../middlewares/verifyToken');
const {
    createAdvice,
    updateAdvice,
    deleteAdvice,
    getAllAdvice,
    getAdvice,
    getAdvicesByAge,
    getAdvicesInArabic,
    getAdvicesInEnglish
} = require('../controllers/AdviceController');

router.route('/').post(createAdvice);

router.route('/:id').put(updateAdvice);

router.route('/:id').delete(deleteAdvice);

router.route('/').get(getAllAdvice);

router.route('/:id').get(getAdvice);

router.route('/age/:age').get(verifyToken,getAdvicesByAge);

router.route('/arabic/age/:age').get(verifyToken,getAdvicesInArabic); 

router.route('/age/:age').get(verifyToken,getAdvicesInEnglish);


module.exports = router;
