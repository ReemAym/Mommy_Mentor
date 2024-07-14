const Mother = require('../models/MotherModel');
const Baby = require('../models/babyModel');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
// Create a new mother
exports.createMother = async (req, res) => {
    try {
        const { name, email, password, address } = req.body;

        const salt = await bcrypt.genSalt(7);
        const hashedPassword = await bcrypt.hash(password, salt);

        const mother = new Mother({ name, email,address, currentIndex:0,password: hashedPassword});
        const token = jwt.sign({ email: mother.email, id: mother._id }, process.env.JWT_SECRET);
        mother.token = token;
        await mother.save();

        res.status(201).json({
            success: true,
            data: mother
        });
    } catch (err) {
        res.status(400).json({
            success: false,
            error: err.message
        });
    }
};
exports.editCurrentIndexForMother = async (req, res) => {
    try {
        // Destructure new currentIndex value from request body
        const { currentIndex } = req.body;

        // Find and update mother's currentIndex by ID
        const mother = await Mother.findByIdAndUpdate(
            req.params.motherId,
            { currentIndex },
            { new: true, runValidators: true }
        ).populate('babies');

        // Check if mother exists
        if (!mother) {
            return res.status(404).json({
                success: false,
                error: 'Mother not found'
            });
        }

        // Return success response
        res.status(200).json({
            success: true,
            data: mother
        });
    } catch (err) {
        // Handle error response
        res.status(400).json({
            success: false,
            error: err.message
        });
    }
};

// Get all mothers
exports.getAllMothers = async (req, res) => {
    try {
        const mothers = await Mother.find().populate('babies');

        res.status(200).json({
            success: true,
            data: mothers
        });
    } catch (err) {
        res.status(400).json({
            success: false,
            error: err.message
        });
    }
};

// Get a single mother by ID
exports.getMotherById = async (req, res) => {
    try {
        const mother = await Mother.findById(req.params.id).populate('babies');

        if (!mother) {
            return res.status(404).json({
                success: false,
                error: 'Mother not found'
            });
        }

        res.status(200).json({
            success: true,
            data: mother
        });
    } catch (err) {
        res.status(400).json({
            success: false,
            error: err.message
        });
    }
};

// Update a mother by ID
exports.updateMother = async (req, res) => {
    try {
        const { name, email, password ,address} = req.body;

        const mother = await Mother.findByIdAndUpdate(
            req.params.id,
            { name, email, password ,address},
            { new: true, runValidators: true }
        ).populate('babies');

        if (!mother) {
            return res.status(404).json({
                success: false,
                error: 'Mother not found'
            });
        }

        res.status(200).json({
            success: true,
            data: mother
        });
    } catch (err) {
        res.status(400).json({
            success: false,
            error: err.message
        });
    }
};

// Delete a mother by ID
exports.deleteMother = async (req, res) => {
    try {
        const mother = await Mother.findByIdAndDelete(req.params.id);

        if (!mother) {
            return res.status(404).json({
                success: false,
                error: 'Mother not found'
            });
        }

        res.status(200).json({
            success: true,
            data: {}
        });
    } catch (err) {
        res.status(400).json({
            success: false,
            error: err.message
        });
    }
};

// Add a baby to a mother
exports.addBabyToMother = async (req, res) => {
    try {
        const { firstname, lastname, birthdate, gender} = req.body;
        console.log(firstname, lastname, birthdate, gender);
        const motherId = req.params.motherId;
        
        const mother = await Mother.findById(motherId).populate('babies');
        

        if (!mother) {
            return res.status(404).json({
                success: false,
                error: 'Mother not found'
            });
        }
        
        const baby = new Baby({ firstname, lastname, birthdate, gender, mother: mother._id });
        
        await baby.save();

        mother.babies.push(baby._id);
        await mother.save();
        const newmother = await Mother.findById(motherId).populate('babies');
        console.log(newmother);
        res.status(201).json({
            success: true,
            data: newmother
        });
    } catch (err) {
        res.status(400).json({
            success: false,
            error: err.message
        });
    }
};

// Get a specific baby by ID
exports.getBabyById = async (req, res) => {
    try {
        const motherId = req.params.motherId;
        const babyId = req.params.babyId;

        const mother = await Mother.findById(motherId).populate({
            path: 'babies',
            match: { _id: babyId }
        });

        if (!mother) {
            return res.status(404).json({
                success: false,
                error: 'Mother not found'
            });
        }

        const baby = mother.babies.find(baby => baby._id.toString() === babyId);

        if (!baby) {
            return res.status(404).json({
                success: false,
                error: 'Baby not found'
            });
        }

        res.status(200).json({
            success: true,
            data: baby
        });
    } catch (err) {
        res.status(400).json({
            success: false,
            error: err.message
        });
    }
};

// Get all babies for a specific mother
exports.getAllBabiesForMother = async (req, res) => {
    try {
        const motherId = req.params.motherId;

        const mother = await Mother.findById(motherId).populate('babies');

        if (!mother) {
            return res.status(404).json({
                success: false,
                error: 'Mother not found'
            });
        }

        res.status(200).json({
            success: true,
            data: mother.babies
        });
    } catch (err) {
        res.status(400).json({
            success: false,
            error: err.message
        });
    }
};

// Delete a baby by ID for a specific mother
exports.deleteBabyByIdForMother = async (req, res) => {
    try {
        const motherId = req.params.motherId;
        const babyId = req.params.babyId;

        const mother = await Mother.findById(motherId);

        if (!mother) {
            return res.status(404).json({
                success: false,
                error: 'Mother not found'
            });
        }

        const baby = await Baby.findOneAndDelete({ _id: babyId, mother: motherId });

        if (!baby) {
            return res.status(404).json({
                success: false,
                error: 'Baby not found for this mother'
            });
        }

        // Remove baby from the mother's babies array
        mother.babies.pull(babyId);
        await mother.save();

        res.status(200).json({
            success: true,
            data: {}
        });
    } catch (err) {
        res.status(400).json({
            success: false,
            error: err.message
        });
    }
};

// Update mother's online status
exports.updateMotherStatus = async (req, res, next) => {
    const { motherId } = req.params; // Extract motherId from request parameters
    const { online } = req.body; // Extract onlineStatus from request body
    
    // Check if onlineStatus is provided
    if (online == undefined) {
        return next(new ApiError('onlineStatus is required in the request body', 400));
    }
    
    try {
        // Update the mother's online status based on motherId
        const updatedMother = await Mother.findByIdAndUpdate(motherId, { online: online }, { new: true });

        // If no mother found, return error
        if (!updatedMother) {
            return next(new ApiError(`No mother found with motherId ${motherId}`, 404));
        }

        // If updated successfully, return success message
        res.status(200).json({
            success: true,
            data: "Mother online status updated successfully",
            mother: updatedMother // Optionally return the updated mother data
        });

    } catch (err) {
        // If an error occurs, pass it to the error handler middleware
        return next(err);
    }
};

// Get all online mothers
exports.getOnlineMothers = async (req, res, next) => {
    try {
        const onlineMothers = await Mother.find({ online: true });
        res.status(200).json({
            success: true,
            data: onlineMothers
        });
    } catch (error) {
        next(new ApiError('Error fetching online mothers', 500, error));
    }
};