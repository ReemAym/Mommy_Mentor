const mongoose = require('mongoose');

const DBConnection = () => {
    mongoose.connect(process.env.DB_URL)
        .then(() => console.log(`DB connection successful!`))
        .catch(err => console.error('DB connection error:', err));
}

module.exports = DBConnection;
