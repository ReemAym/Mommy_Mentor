const jwt = require('jsonwebtoken');

const verifyToken = (req, res, next) => {
    const bearerHeader = req.headers['authorization'];
    
    if (typeof bearerHeader !== 'undefined') {
        const bearer = bearerHeader.split(' ');
        const token = bearer[1];

        jwt.verify(token, process.env.JWT_SECRET, (err, authData) => {
            if (err) {
                return res.status(403).json({ message: 'Forbidden' });
            }
            // If verification succeeds, attach authData to request object
            req.authData = authData;
            req.token = token; // Attach token to request object if needed
            
            // Call next() after successful verification
            next();
        });
    } else {
        return res.status(403).json({ message: 'Forbidden' });
    }
};

module.exports = verifyToken;