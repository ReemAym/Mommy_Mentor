const express = require('express');
const router = express.Router();
const verifyToken = require('../middlewares/verifyToken');


const {
    uploadArticle,
    updateArticle,
    deleteArticle,
    getArticles,
    getArticleById,
    getArticlesByCategory,
    getArticlesInArabic,
    getArticlesInEnglish
} = require('../controllers/ArticleController');

router.route('/')
    .post(verifyToken, uploadArticle)
    .get(getArticles);

router.route('/arabic')
    .get(verifyToken,getArticlesInArabic);
    
router.route('/english')
    .get(verifyToken,getArticlesInEnglish);

router.route('/:id')
    .put( updateArticle)
    .delete( deleteArticle)
    .get(getArticleById);

router.route('/category/:category')
    .get(getArticlesByCategory);

module.exports = router;
