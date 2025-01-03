// src/models/User.js

class User {
    constructor(id, username, email, password) {
        this.id = id; // Unique identifier
        this.username = username;
        this.email = email;
        this.password = password; // Hashed password
    }
}

module.exports = User;
