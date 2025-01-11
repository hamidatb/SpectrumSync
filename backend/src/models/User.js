// src/models/User.js 

class User {
    constructor(id, username, email, password, created_at) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.password = password;
        this.created_at = created_at;
    }
}

module.exports = User;