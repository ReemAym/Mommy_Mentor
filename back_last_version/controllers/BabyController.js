const Baby = require('../models/babyModel');
const asyncHandler = require('express-async-handler');
const ApiError = require('../utils/ApiError');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

exports.getAllBabies = asyncHandler(async (req, res, next) => {
    const limit = req.params.limit;
    const page = req.params.page;
    const skip = (page - 1) * limit;
    const babies = await Baby.find({}, {"__v": false, 'password': false}).limit(limit).skip(skip);
    if (!babies) {
        return next(new ApiError(`No Baby found`, 404));
    }
    res.status(200).json({
        status: 'success',
        data: babies
    });
});

exports.getSpecificBaby = asyncHandler(async (req, res, next) => {
    const baby = await Baby.findById(req.params.id);
    if (!baby) {
        return next(new ApiError(`No baby found with id ${req.params.id}`, 404));
    }
    res.status(200).json({
        success: true,
        data: baby
    });
});

exports.getBabyByEmail = asyncHandler(async (req, res, next) => {
    const { email } = req.body;
    if (!email) {
        return next(new ApiError('Email required query parameters', 400));
    }
    try {
        const baby = await Baby.findOne({ email });
        if (!baby) {
            return next(new ApiError(`No baby found with email ${email}`, 404));
        }
        res.status(200).json({
            success: true,
            data: baby
        });
    } catch (err) {
        return next(err);
    }
});

exports.register = asyncHandler(async (req, res, next) => {
    const { firstname, lastname, birthdate, gender, address, email, password } = req.body;
    const salt = await bcrypt.genSalt(7);
    const hashedPassword = await bcrypt.hash(password, salt);
    const baby = new Baby({ firstname, lastname, birthdate, gender, address, email, password: hashedPassword });
    const token = jwt.sign({ email: baby.email, id: baby._id }, process.env.JWT_SECRET);
    baby.token = token;

    await baby.save();
    res.status(201).json({
        status: 'success',
        data: baby
    });
});

exports.updateBaby = asyncHandler(async (req, res, next) => {
    const baby = await Baby.findByIdAndUpdate(req.params.id, req.body, {
        new: true,
        runValidators: true
    });
    if (!baby) {
        return next(new ApiError(`No baby found with id ${req.params.id}`, 404));
    }
    res.status(200).json({
        success: true,
        data: baby
    });
});

exports.updateBabyByEmail = asyncHandler(async (req, res, next) => {
    const { email } = req.body;
    const updateFields = req.body;
    if (!email) {
        return next(new ApiError('Email is required in the request body', 400));
    }
    try {
        const baby = await Baby.findOneAndUpdate({ email }, updateFields, {
            new: true,
            runValidators: true
        });
        if (!baby) {
            return next(new ApiError(`No baby found with email ${email}`, 404));
        }
        res.status(200).json({
            success: true,
            data: baby
        });
    } catch (err) {
        return next(err);
    }
});

exports.deleteBaby = asyncHandler(async (req, res, next) => {
    const baby = await Baby.findByIdAndDelete(req.params.id);
    if (!baby) {
        return next(new ApiError(`No baby found with id ${req.params.id}`, 404));
    }
    res.status(200).json({
        success: true,
        data: "Baby is deleted successfully"
    });
});

exports.deleteBabyByEmail = asyncHandler(async (req, res, next) => {
    const { email } = req.body;
    if (!email) {
        return next(new ApiError('Email is required in the request body', 400));
    }
    try {
        const baby = await Baby.findOneAndDelete({ email });
        if (!baby) {
            return next(new ApiError(`No baby found with email ${email}`, 404));
        }
        res.status(200).json({
            success: true,
            data: "Baby is deleted successfully"
        });
    } catch (err) {
        return next(err);
    }
});

exports.login = asyncHandler(async (req, res, next) => {
    const { email, password } = req.body;
    const baby = await Baby.findOne({ email });
    if (!baby) {
        return next(new ApiError(`Invalid email or password`, 401));
    }
    const isMatch = await bcrypt.compare(password, baby.password);
    if (!isMatch) {
        return next(new ApiError(`Invalid email or password`, 401));
    }
    const token = jwt.sign({ email: baby.email, id: baby._id }, process.env.JWT_SECRET);
    baby.token = token;
    await baby.save();

    res.status(200).json({
        status: 'success',
        data: baby
    });
});
exports.addMonthlyMeasurement = asyncHandler(async (req, res, next) => {
    const { id } = req.params;
    const { month, height, weight, headCircumference } = req.body;
    console.log( req.body);
    console.log(month, height, weight, headCircumference);

    if (!height || !weight || !headCircumference) {
        return next(new ApiError('Height, weight, and head circumference are required', 400));
    }
    if(month>=0)
    {
        const baby = await Baby.findById(id);
    if (!baby) {
        return next(new ApiError(`No baby found with id ${id}`, 404));
    }

    const newMeasurement = {
        month, // Convert month to integer
        height,
        weight,
        headCircumference
    };

    baby.measurements.push(newMeasurement);

    await baby.save();
    res.status(201).json({
        status: 'success',
        data: baby
    });
    }
    else{
        return next(new ApiError('Month is required', 400));
    }
   
    
});



exports.getAllMonthlyMeasurements = asyncHandler(async (req, res, next) => {
    const { id } = req.params;

    const baby = await Baby.findById(id);
    if (!baby) {
        return next(new ApiError(`No baby found with id ${id}`, 404));
    }

    res.status(200).json({
        status: 'success',
        data: baby.measurements
    });
});

exports.getMonthlyMeasurements = asyncHandler(async (req, res, next) => {
    const { id, month } = req.params;

    if (!/^\d{4}-\d{2}$/.test(month)) {
        return next(new ApiError('Invalid month format. Use YYYY-MM', 400));
    }

    const startOfMonth = new Date(`${month}-01T00:00:00.000Z`);
    const endOfMonth = new Date(`${month}-01T00:00:00.000Z`);
    endOfMonth.setMonth(endOfMonth.getMonth() + 1);

    const baby = await Baby.findById(id);
    if (!baby) {
        return next(new ApiError(`No baby found with id ${id}`, 404));
    }

    const measurements = baby.measurements.filter(m => {
        return m.month >= startOfMonth && m.month < endOfMonth;
    });

    res.status(200).json({
        success: true,
        data: measurements
    });
});
