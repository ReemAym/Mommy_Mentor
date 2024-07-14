const ArticleModel = require('../models/ArticleModel');
const translate = require('translate-google');

// Create a new article
exports.uploadArticle = async (req, res) => {
    try {
        const article = new ArticleModel(req.body);
        await article.save();
        res.status(201).json({ success: true, data: article });
    } catch (error) {
        res.status(400).json({ success: false, error: error.message });
    }
};

// Get all articles
exports.getArticles = async (req, res) => {
    try {
        const articles = await ArticleModel.find();
        res.status(200).json({ success: true, data: articles });
    } catch (error) {
        res.status(400).json({ success: false, error: error.message });
    }
};

// Get articles in Arabic
// exports.getArticlesInArabic = async (req, res) => {
//     try {
//         // Fetch all articles (assuming stored in the original language)
//         const articles = await ArticleModel.find();

//         // Translate each article's title, content, and category to Arabic
//         const translatedArticles = await Promise.all(articles.map(async (article) => {
//             let translatedTitle = article.title;
//             let translatedContent = article.content;
//             let translatedCategory = article.category;

//             // Check and translate title
//             if (article.title) {
//                 translatedTitle = await translate(article.title, { to: 'ar' }).catch(error => {
//                     console.error(`Error translating title: ${error.message}`);
//                     return article.title; // Fallback to original title
//                 });
//             }

//             // Check and translate content
//             if (article.content) {
//                 translatedContent = await translate(article.content, { to: 'ar' }).catch(error => {
//                     console.error(`Error translating content: ${error.message}`);
//                     return article.content; // Fallback to original content
//                 });
//             }

//             // Check and translate category
//             if (article.category) {
//                 translatedCategory = await translate(article.category, { to: 'ar' }).catch(error => {
//                     console.error(`Error translating category: ${error.message}`);
//                     return article.category; // Fallback to original category
//                 });
//             }

//             // Return translated article object
//             return {
//                 ...article.toObject(),
//                 title: translatedTitle,
//                 content: translatedContent,
//                 category: translatedCategory
//             };
//         }));

//         res.status(200).json({ success: true, data: translatedArticles });
//     } catch (error) {
//         console.error(`Error fetching or translating articles: ${error.message}`);
//         res.status(500).json({ success: false, error: error.message });
//     }
// };

// const translate = require('@vitalets/google-translate-api');

exports.getArticlesInArabic = async (req, res) => {
    try {
        const category = req.query.category;
        const articles = category ? await ArticleModel.find({ category }) : await ArticleModel.find();

        // Translate each article's title, content, and category to Arabic
        const translatedArticles = await Promise.all(articles.map(async (article) => {
            let translatedTitle = article.title;
            let translatedContent = article.content;
            let translatedCategory = article.category;

            // Check and translate title
            if (article.title) {
                translatedTitle = await translate(article.title, { to: 'ar' }).catch(error => {
                    console.error(`Error translating title: ${error.message}`);
                    return article.title; // Fallback to original title
                });
            }

            // Check and translate content
            if (article.content) {
                translatedContent = await translate(article.content, { to: 'ar' }).catch(error => {
                    console.error(`Error translating content: ${error.message}`);
                    return article.content; // Fallback to original content
                });
            }

            // Check and translate category
            if (article.category) {
                translatedCategory = await translate(article.category, { to: 'ar' }).catch(error => {
                    console.error(`Error translating category: ${error.message}`);
                    return article.category; // Fallback to original category
                });
            }

            // Return translated article object
            return {
                ...article.toObject(),
                title: translatedTitle,
                content: translatedContent,
                category: translatedCategory
            };
        }));

        res.status(200).json({ success: true, data: translatedArticles });
    } catch (error) {
        console.error(`Error fetching or translating articles: ${error.message}`);
        res.status(500).json({ success: false, error: error.message });
    }
};

exports.getArticlesInEnglish = async (req, res) => {
    try {
        console.log(req.query.category);
        const category = req.query.category;
        const articles = category ? await ArticleModel.find({ category }) : await ArticleModel.find();
        res.status(200).json({ success: true, data: articles });
    } catch (error) {
        console.error(`Error fetching articles: ${error.message}`);
        res.status(500).json({ success: false, error: error.message });
    }
};



// Get a single article by ID
exports.getArticleById = async (req, res) => {
    try {
        const article = await ArticleModel.findById(req.params.id);
        if (!article) {
            return res.status(404).json({ success: false, error: 'Article not found' });
        }
        res.status(200).json({ success: true, data: article });
    } catch (error) {
        res.status(400).json({ success: false, error: error.message });
    }
};

// Get articles by category
exports.getArticlesByCategory = async (req, res) => {
    try {
        const  category = req.params.category; 
        console.log(category);
        console.log(!category);
        if (!category) {
            return res.status(400).json({ success: false, error: 'Category is required' });
        }
        const articles = await ArticleModel.find({ category });
        res.status(200).json({ success: true, data: articles });
    } catch (error) {
        res.status(400).json({ success: false, error: error.message });
    }
};

// Update an article by ID
exports.updateArticle = async (req, res) => {
    try {
        const article = await ArticleModel.findByIdAndUpdate(req.params.id, req.body, {
            new: true,
            runValidators: true,
        });
        if (!article) {
            return res.status(404).json({ success: false, error: 'Article not found' });
        }
        res.status(200).json({ success: true, data: article });
    } catch (error) {
        res.status(400).json({ success: false, error: error.message });
    }
};

// Delete an article by ID
exports.deleteArticle = async (req, res) => {
    try {
        const article = await ArticleModel.findByIdAndDelete(req.params.id);
        if (!article) {
            return res.status(404).json({ success: false, error: 'Article not found' });
        }
        res.status(200).json({ success: true, data: {} });
    } catch (error) {
        res.status(400).json({ success: false, error: error.message });
    }
};
