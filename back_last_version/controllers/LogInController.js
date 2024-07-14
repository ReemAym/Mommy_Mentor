const Mother = require('../models/MotherModel');
const Doctor = require('../models/DoctorModel');
const asyncHandler = require('express-async-handler');
const ApiError = require('../utils/ApiError');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');


exports.login = asyncHandler(async (req, res, next) => {
    const {email, password} = req.body;
    const mother = await Mother.findOne({email: email}).populate('babies');
    const doctor = await Doctor.findOne({email: email});
    var isMatch ;
    if(mother)
        {
         isMatch = await bcrypt.compare(password, mother.password);
         if (!isMatch) {
            return next(new ApiError("Invalid password", 401));
        }
        const token = jwt.sign({email: mother.email, id :mother._id}, process.env.JWT_SECRET);
        mother.token = token;
        await mother.save();
        console.log(mother);
        res.status(200).json({
            status: 'success',
            data: mother,
            type: "mother"
        });
        
    }
    else if(doctor)
    {
        console.log(doctor);
        isMatch = await bcrypt.compare(password, doctor.password);
        console.log(isMatch);
        if (!isMatch) {
            return next(new ApiError("Invalid password", 401));
        }
        const token = jwt.sign({email: doctor.email, id :doctor._id}, process.env.JWT_SECRET);
        doctor.token = token;
        await doctor.save();
    
        res.status(200).json({
            status: 'success',
            data: doctor,
            type: "doctor"
        });

    }
    else {
        return next(new ApiError("Invalid email", 401));
    }


   
    
});
// exports.login = asyncHandler(async (req, res, next) => {
//     const { email, password } = req.body;
//     let user;

//     // Find the user in both collections
//     const baby = await Baby.findOne({ email: email });
//     const doctor = await Doctor.findOne({ email: email });

//     // Check if user exists in either collection
//     if (baby) {
//         user = baby;
//     } else if (doctor) {
//         console.log(doctor);
//         user = doctor;
//     } else {
//         return next(new ApiError(`Invalid email or password`, 401));
//     }

//     // Compare provided password with stored hashed password
//     console.log(password);
//     console.log(user.password);
 
//     bcrypt.hash(password, 10, (err, hash) => {
//     if (err) {
//         console.error('Error hashing password:', err);
//     } else {
//         console.log('Manually hashed password:', hash);
//         bcrypt.compare(hash, user.password, (err, isMatch) => {
//             if (err) {
//                 console.error('Error comparing passwords:', err);
//             } else {
//                 console.log('Passwords match:', isMatch);
//             }
//         });
//     }
// });

//     const isMatch = await bcrypt.compare(password, user.password);
//     if (!isMatch) {
//         return next(new ApiError(`Invalid email or password`, 401));
//     }

//     // Generate JWT token
//     const token = jwt.sign({ email: user.email, id: user._id }, process.env.JWT_SECRET);
//     user.token = token;
//     await user.save();

//     // Respond with user data
//     res.status(200).json({
//         status: 'success',
//         data: user
//     });
// });
