const Advice = require('../models/AdviceModel');
const translate = require('translate-google');

// Create a new advice
exports.createAdvice = async (req, res) => {
    try {
        const newAdvice = await Advice.create(req.body);
        res.status(201).json({
            status: 'success',
            data: newAdvice
        });
    } catch (err) {
        res.status(400).json({
            status: 'fail',
            message: err.message
        });
    }
};

// Get all advices
exports.getAllAdvice = async (req, res) => {
    try {
        const advice = await Advice.find();
        res.status(200).json({
            status: 'success',
            results: advice.length,
            data: advice
        });
    } catch (err) {
        res.status(400).json({
            status: 'fail',
            message: err.message
        });
    }
};

// Function to get advices in Arabic
// Node.js Server


exports.getAdvicesInArabic = async (req, res) => {
    const age = req.params.age; // Get the age from the request parameters
    try {
        // Fetch all advices (assuming stored in the original language)
        const advices = await Advice.find({ age: age }); // Filter by age

        // Translate each advice's title, content, and possibly category to Arabic
        const translatedAdvices = await Promise.all(advices.map(async (advice) => {
            let translatedTitle = advice.title;
            let translatedContent = advice.content;

            // Translate title
            if (advice.title) {
                translatedTitle = await translate(advice.title, { to: 'ar' }).catch(error => {
                    console.error(`Error translating title: ${error.message}`);
                    return advice.title; // Fallback to original title
                });
            }

            // Translate content
            if (advice.content) {
                translatedContent = await translate(advice.content, { to: 'ar' }).catch(error => {
                    console.error(`Error translating content: ${error.message}`);
                    return advice.content; // Fallback to original content
                });
            }

            // Return translated advice object
            return {
                ...advice.toObject(),
                title: translatedTitle,
                content: translatedContent
            };
        }));

        res.status(200).json({ success: true, data: translatedAdvices });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

exports.getAdvicesInEnglish = async (req, res) => {
    const age = req.params.age; // Get the age from the request parameters
    try {
        // Fetch all advices (assuming stored in Arabic)
        const advices = await Advice.find({ age: age }); // Filter by age

        // Translate each advice's title, content, and possibly category to English
        const translatedAdvices = await Promise.all(advices.map(async (advice) => {
            let translatedTitle = advice.title;
            let translatedContent = advice.content;

            // Translate title
            if (advice.title) {
                translatedTitle = await translate(advice.title, { to: 'en' }).catch(error => {
                    console.error(`Error translating title: ${error.message}`);
                    return advice.title; // Fallback to original title
                });
            }

            // Translate content
            if (advice.content) {
                translatedContent = await translate(advice.content, { to: 'en' }).catch(error => {
                    console.error(`Error translating content: ${error.message}`);
                    return advice.content; // Fallback to original content
                });
            }

            // Return translated advice object
            return {
                ...advice.toObject(),
                title: translatedTitle,
                content: translatedContent
            };
        }));

        res.status(200).json({ success: true, data: translatedAdvices });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};






// Get a single advice by ID
exports.getAdvice = async (req, res) => {
    try {
        const advice = await Advice.findById(req.params.id);
        if (!advice) {
            return res.status(404).json({
                status: 'fail',
                message: 'No advice found with that ID'
            });
        }
        res.status(200).json({
            status: 'success',
            data: advice
        });
    } catch (err) {
        res.status(400).json({
            status: 'fail',
            message: err.message
        });
    }
};

// Update an advice by ID
exports.updateAdvice = async (req, res) => {
    try {
        const advice = await Advice.findByIdAndUpdate(req.params.id, req.body, {
            new: true,
            runValidators: true
        });
        if (!advice) {
            return res.status(404).json({
                status: 'fail',
                message: 'No advice found with that ID'
            });
        }
        res.status(200).json({
            status: 'success',
            data: advice
        });
    } catch (err) {
        res.status(400).json({
            status: 'fail',
            message: err.message
        });
    }
};

// Delete an advice by ID
exports.deleteAdvice = async (req, res) => {
    try {
        const advice = await Advice.findByIdAndDelete(req.params.id);
        if (!advice) {
            return res.status(404).json({
                status: 'fail',
                message: 'No advice found with that ID'
            });
        }
        res.status(204).json({
            status: 'success',
            data: null
        });
    } catch (err) {
        res.status(400).json({
            status: 'fail',
            message: err.message
        });
    }
};

// Get advices by age
exports.getAdvicesByAge = async (req, res) => {
    try {
        const age = parseInt(req.params.age);
        if (isNaN(age)) {
            return res.status(400).json({ success: false, error: 'Invalid age parameter' });
        }
        const advices = await Advice.find({ age: age });
        res.status(200).json({ success: true, data: advices });
    } catch (error) {
        res.status(400).json({ success: false, error: error.message });
    }
};
