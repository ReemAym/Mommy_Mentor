const Doctor = require('../models/DoctorModel');
const asyncHandler = require('express-async-handler')
const ApiError = require('../utils/ApiError');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

exports.getAllDoctors = asyncHandler(async (req, res, next) => {
    const limit = req.params.limit
    const page = req.params.page
    const skip = (page - 1) * limit
    const doctor = await Doctor.find({},{"__v":false,'password':false}).limit(limit).skip(skip);
    if (!doctor) {
        return next(new ApiError(`No doctor found`, 404));
    }
    res.status(200).json({
        status: 'success',
        data: doctor
    });
});

exports.getSpecificDoctor = asyncHandler(async (req, res, next) => {
    const doctor = await Doctor.findById(req.params.id);
    if (!doctor) {
        return next(new ApiError(`No doctor found with id ${req.params.id}`, 404));
    }
    res.status(200).json({
        status: 'success',
        data: doctor
    });
});

// Controller function to get a specific doctor by email
exports.getDoctorByEmail = asyncHandler(async (req, res, next) => {
    const { email } = req.body; // Access email from request body
    
    // Check if email is provided
    if (!email) {
        return next(new ApiError('Email required query parameters', 400));
    }
    try {
        // Find the doctor with the provided email
        const doctor = await Doctor.findOne({ email });

        // If no docotr found, return error
        if (!doctor) {
            return next(new ApiError(`No doctor found with email ${email}`, 404));
        }

        // If found, return the doctor object
        res.status(200).json({
            success: true,
            data: doctor
        });

    } catch (err) {
        // If an error occurs, pass it to the error handler middleware
        return next(err);
    }
});

exports.register = asyncHandler(async (req, res, next) => {
    const {firstName, lastName, phone, specialization, degree, workPlace, description, email, password} = req.body;
    console.log(password);
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);
    // var hashedPassword;
    // bcrypt.hash(password, 10, (err, hash) => {
    //     if (err) {
    //         console.error('Error hashing password:', err);
    //     } else {
    //         console.log('Manually hashed password:', hash);
    //         hashedPassword=hash;
            
    //     }
    // });
    
    
    const doctor = new Doctor({firstName, lastName, phone, specialization, degree, workPlace, description, email, password: hashedPassword});
    const token = jwt.sign({email: doctor.email, id: doctor._id}, process.env.JWT_SECRET);
    doctor.token = token;

    await doctor.save();
    res.status(201).json({
        status: 'success',
        data: doctor
    });
});

exports.updateDoctor = asyncHandler(async (req, res, next) => {
    const doctor = await Doctor.findByIdAndUpdate(req.params.id, req.body, {
        new: true,
        runValidators: true
    });
    if (!doctor) {
        return next(new ApiError(`No doctor found with id ${req.params.id}`, 404));
    }
    res.status(200).json({
        success: true,
        data: doctor
    });
});

exports.updateDoctorByEmail = asyncHandler(async (req, res, next) => {
    const { email } = req.body; // Assuming email is passed as a parameter in the request body
    const updateFields = req.body; // Fields to update, including possibly 'password'

    // Check if email is provided
    if (!email) {
        return next(new ApiError('Email is required in the request body', 400));
    }

    try {
        // Find the doctor with the provided email
        let doctor = await Doctor.findOne({ email });

        // If no doctor found, return error
        if (!doctor) {
            return next(new ApiError(`No doctor found with email ${email}`, 404));
        }

        // Check if there's a new password to update
        if (updateFields.password) {
            // Hash the new password using bcrypt
            const salt = await bcrypt.genSalt(10);
            const hashedPassword = await bcrypt.hash(updateFields.password, salt);
            
            // Update the doctor object with the hashed password
            updateFields.password = hashedPassword;
            console.log("Password updated",updateFields.password    )
        }

        // Update the doctor with the new fields
        doctor.set(updateFields); // Apply the updated fields to the doctor object
        await doctor.save(); // Save the updated doctor object

        // If updated successfully, return the updated doctor object
        res.status(200).json({
            success: true,
            data: doctor
        });

    } catch (err) {
        // If an error occurs, pass it to the error handler middleware
        return next(err);
    }
});

exports.deleteDoctor = asyncHandler(async (req, res, next) => {
    const doctor = await Doctor.findByIdAndDelete(req.params.id);
    if (!doctor) {
        return next(new ApiError(`No doctor found with id ${req.params.id}`, 404));
    }
    res.status(200).json({
        status: 'success',
        data: "Doctor is deleted successfully"
    });
});

exports.deleteDoctorByEmail = asyncHandler(async (req, res, next) => {
    const { email } = req.body; // Assuming email is passed as a parameter in the request body
    
    // Check if email is provided
    if (!email) {
        return next(new ApiError('Email is required in the request body', 400));
    }
    
    try {
        // Find the doctor with the provided email and delete it
        const doctor = await Baby.findOneAndDelete({ email });

        // If no doctor found, return error
        if (!doctor) {
            return next(new ApiError(`No doctor found with email ${email}`, 404));
        }

        // If deleted successfully, return success message
        res.status(200).json({
            success: true,
            data: "Doctor is deleted successfully"
        });

    } catch (err) {
        // If an error occurs, pass it to the error handler middleware
        return next(err);
    }
});

exports.login = asyncHandler(async (req, res, next) => {
    const {email, password} = req.body;
    const doctor = await Doctor.findOne({email: email});
    console.log(doctor.email);
    if (!doctor) {
        return next(new ApiError('Invalid email or password!', 401));
    }
    const isMatch = await bcrypt.compare(password, doctor.password);
    if (!isMatch) {
        return next(new ApiError('Invalid email or password!', 401));
    }
    const token = jwt.sign({email: doctor.email, id: doctor._id}, process.env.JWT_SECRET);
    doctor.token = token;
    await doctor.save();

    res.status(200).json({
        status: 'success',
        data: doctor
    });
});

// update doctor's online status
exports.updateDoctorStatus = asyncHandler(async (req, res, next) => {
    const doctorId = req.params.id; // Assuming id is passed as a route parameter
    
    // Check if doctorId is provided
    if (!doctorId) {
        return next(new ApiError('Doctor ID is required in the route parameters', 400));
    }
    
    const { online } = req.body; // Assuming onlineStatus is passed in the request body
    
    // Check if onlineStatus is provided
    if (online == undefined) {
        return next(new ApiError('Online status is required in the request body', 400));
    }
    
    try {
        // Update the doctor's online status based on doctorId
        const updatedDoctor = await Doctor.findByIdAndUpdate(doctorId, { online: online }, { new: true });

        // If no doctor found, return error
        if (!updatedDoctor) {
            return next(new ApiError(`No doctor found with ID ${doctorId}`, 404));
        }

        // If updated successfully, return success message
        res.status(200).json({
            success: true,
            data: "Doctor online status updated successfully",
            doctor: updatedDoctor // Optionally return the updated doctor data
        });

    } catch (err) {
        // If an error occurs, pass it to the error handler middleware
        return next(err);
    }
});

// Get all online doctors
exports.getOnlineDoctors = asyncHandler(async (req, res, next) => {
    try {
        const onlineDoctors = await Doctor.find({ online: true });
        res.status(200).json({
            success: true,
            data: onlineDoctors
        });
    } catch (error) {
        next(new ApiError('Error fetching online doctors', 500, error));
    }
});
