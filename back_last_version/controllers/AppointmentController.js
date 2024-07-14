const express = require('express');
const mongoose = require('mongoose');
const Appointment = require('../models/AppointmentModel'); // Adjust the path as necessary
const Doctor = require('../models/DoctorModel'); // Adjust the path as necessary

const addAppointment = async (req, res) => {
    try {
        const { address, fee, date, token, doctor } = req.body;
        const appointment = new Appointment({ address, fee, date, token, doctor });
        await appointment.save();
        res.status(201).json(appointment);
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
};

const updateAppointment = async (req, res) => {
    try {
        const { id } = req.params;
        const updates = req.body;
        const appointment = await Appointment.findByIdAndUpdate(id, updates, { new: true, runValidators: true });
        if (!appointment) {
            return res.status(404).json({ error: 'Appointment not found' });
        }
        res.status(200).json(appointment);
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
};

const deleteAppointment = async (req, res) => {
    try {
        const { id } = req.params;
        const appointment = await Appointment.findByIdAndDelete(id);
        if (!appointment) {
            return res.status(404).json({ error: 'Appointment not found' });
        }
        res.status(200).json({ message: 'Appointment deleted successfully' });
    } catch (err) {
        res.status(400).json({ error: err.message });
    }
};

const getAllAppointments = async (req, res) => {
    try {
        const appointments = await Appointment.find().populate('doctor');
        res.status(200).json({ success: true, data: appointments });
    } catch (err) {
        res.status(500).json({ success: false, error: err.message });
    }
};

const getAppointments = async (req, res) => {
    try {
        const { doctorName, address, fee } = req.body;
        let query = {};

        // Check if doctorName is provided
        if (doctorName) {
            // Find the doctor whose name matches the provided name
            const doctor = await Doctor.findOne({ firstName: doctorName });

            if (doctor) {
                // If doctor found, filter appointments by doctor ID
                query.doctor = doctor._id;
            } else {
                // If doctor not found, return empty result
                return res.status(200).json({ success: true, data: [] });
            }
        }

        // Check if address is provided
        if (address) {
            query.address = { $regex: address, $options: 'i' };
        }

        // Check if fee is provided
        if (fee) {
            // Parse fee value
            const feeValue = parseInt(fee);

            // Check if fee is a valid number
            if (!isNaN(feeValue)) {
                // Update query to find appointments with fee less than or equal to the specified value
                query.fee = { $lte: feeValue };
            } else {
                return res.status(400).json({ success: false, error: 'Invalid fee value' });
            }
        }

        // Find appointments matching the query and populate the doctor information
        const appointments = await Appointment.find(query).populate('doctor');
        res.status(200).json({ success: true, data: appointments });
    } catch (err) {
        res.status(500).json({ success: false, error: err.message });
    }
};


module.exports = {
    addAppointment,
    updateAppointment,
    deleteAppointment,
    getAppointments,
    getAllAppointments,
};
