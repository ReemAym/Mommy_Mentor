// Import required modules
const NormalGrowth = require('../models/normalGrowthModel');
const asyncHandler = require('express-async-handler');
const ApiError = require('../utils/ApiError');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

exports.getAllNormalGrowthByGenderAndAge = asyncHandler(async (req, res, next) => {
    const { gender} = req.query;

    if (!gender ) {
        return next(new ApiError('Gender  is required query parameters', 400));
    }

    try {
        const normalGrowthData = await NormalGrowth.find({
            gender,
        });

        if (!normalGrowthData.length) {
            return next(new ApiError('No normal growth data found for the provided criteria', 404));
        }

        res.status(200).json({
            success: true,
            data: normalGrowthData
        });
    } catch (err) {
        console.error('Error fetching normal growth data:', err);
        return next(err);
    }
});



// Controller function to insert a new object
exports.createNormalGrowth = asyncHandler(async (req, res, next) => {
    // Extract data from request body
    const { gender, month, fromNormalHeight, toNormalHeight, fromNormalWeight, toNormalWeight, fromNormalHeadCircumference, toNormalHeadCircumference } = req.body;

    try {
        // Create a new NormalGrowth object
        const normalGrowth = new NormalGrowth({
            gender,
            month,
            fromNormalHeight,
            toNormalHeight,
            fromNormalWeight,
            toNormalWeight,
            fromNormalHeadCircumference,
            toNormalHeadCircumference
        });

        // Save the object to the database
        await normalGrowth.save();

        // Return success response
        res.status(201).json({
            success: true,
            data: normalGrowth
        });
    } catch (err) {
        // If an error occurs, pass it to the error handler middleware
        return next(err);
    }
});
// Controller function to check if growth parameters are in normal range
exports.checkNormalGrowth = asyncHandler(async (req, res, next) => {
    // Extract data from request body
    const { gender, ageInMonths, weight, height, headCircumference } = req.body;
    console.log(gender, ageInMonths, weight, height, headCircumference);
    console.log(typeof gender);

    try {
        // Find the normal growth data for the given gender and age (month)
        const normalGrowthData = await NormalGrowth.findOne({
            gender,
            month: ageInMonths.toString()  // Assuming month is stored as string in the schema
        });

        if (!normalGrowthData) {
            return next(new ApiError('Normal growth data not found for the provided criteria', 404));
        }

        // Check if weight is within normal range
        let weightStatus = "Weight is in normal range";
        let weightNormal = true;
        if (weight < normalGrowthData.fromNormalWeight || weight > normalGrowthData.toNormalWeight) {
            weightStatus = "Weight is not in normal range";
            weightNormal=false;
        }

        // Check if height is within normal range
        let heightStatus = "Height is in normal range";
        let heightNormal = true;
        if (height < normalGrowthData.fromNormalHeight || height > normalGrowthData.toNormalHeight) {
            heightStatus = "Height is not in normal range";
            heightNormal = false;
        }

        // Check if head circumference is within normal range
        let headCircumferenceStatus = "Head Circumference is in normal range";
        let headCircumferenceNormal = true;
        if (headCircumference < normalGrowthData.fromNormalHeadCircumference || headCircumference > normalGrowthData.toNormalHeadCircumference) {
            headCircumferenceStatus = "Head Circumference is not in normal range";
            headCircumferenceNormal = false;
        }

        // Return the result
        res.status(200).json({
            success: true,
            data: {
                weight: weightStatus,
                weightNormal:weightNormal,
                height: heightStatus,
                heightNormal:heightNormal,
                headCircumference: headCircumferenceStatus,
                headCircumferenceNormal:headCircumferenceNormal

            }
        });

    } catch (err) {
        // If an error occurs, pass it to the error handler middleware
        return next(err);
    }
});


