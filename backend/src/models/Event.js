// src/models/Event.js

class Event {
    constructor(id, title, description, date, location, userId, created_at) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.date = date;
        this.location = location;
        this.userId = userId;
        this.created_at = created_at;
    }
}

module.exports = Event;