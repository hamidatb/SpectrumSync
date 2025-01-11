# Spectrum Sync API Documentation

## Table of Contents

1. [Introduction](#introduction)
2. [Authentication](#authentication)
3. [API Endpoints](#api-endpoints)
    - [User Authentication](#user-authentication)
        - [Register User](#register-user)
        - [Login User](#login-user)
    - [Event Management](#event-management)
        - [Create Event](#create-event)
        - [Get Events](#get-events)
        - [Share Event](#share-event)
        - [Unshare Event](#unshare-event)
        - [RSVP to Event](#rsvp-to-event)
        - [Update RSVP Status](#update-rsvp-status)
        - [Get Invitations](#get-invitations)
4. [Error Handling](#error-handling)
5. [Glossary](#glossary)
6. [Quick Start](#quick-start)
7. [Additional Resources](#additional-resources)

---

## Introduction

The **Spectrum Sync API** is a RESTful service built with **Node.js** and **Express.js**, integrated with **Azure SQL Database**. It facilitates user authentication, event creation and management, event sharing, and RSVP functionalities for the Spectrum Sync iOS application.

### Technologies Used

- **Backend:** Node.js, Express.js
- **Database:** Azure SQL Database
- **Authentication:** JWT (JSON Web Tokens)
- **Deployment:** Azure App Service

---

## Authentication

All API endpoints, except for user registration and login, require authentication via JWT tokens. Clients must include the token in the `Authorization` header of their HTTP requests.

### Authentication Header

```http
Authorization: Bearer <your-jwt-token>
```

---

## API Endpoints

### User Authentication

#### Register User

- **URL:** `/api/auth/register`
- **Method:** `POST`
- **Description:** Registers a new user.

##### Request

- **Headers:**
    - `Content-Type: application/json`

- **Body:**

    ```json
    {
        "username": "john_doe",
        "email": "john@example.com",
        "password": "Password123!"
    }
    ```

##### Responses

- **Success (201 Created):**

    ```json
    {
        "token": "jwt_token_here",
        "user": {
            "id": 1,
            "username": "john_doe",
            "email": "john@example.com"
        }
    }
    ```

- **Error (400 Bad Request):** User already exists or validation fails.

    ```json
    {
        "message": "User already exists"
    }
    ```

- **Error (500 Internal Server Error):**

    ```json
    {
        "message": "Server error"
    }
    ```

---

#### Login User

- **URL:** `/api/auth/login`
- **Method:** `POST`
- **Description:** Authenticates a user and returns a JWT token.

##### Request

- **Headers:**
    - `Content-Type: application/json`

- **Body:**

    ```json
    {
        "email": "john@example.com",
        "password": "Password123!"
    }
    ```

##### Responses

- **Success (200 OK):**

    ```json
    {
        "token": "jwt_token_here",
        "user": {
            "id": 1,
            "username": "john_doe",
            "email": "john@example.com"
        }
    }
    ```

- **Error (400 Bad Request):** Invalid credentials.

    ```json
    {
        "message": "Invalid credentials"
    }
    ```

- **Error (500 Internal Server Error):**

    ```json
    {
        "message": "Server error"
    }
    ```

---

### Event Management

#### Create Event

- **URL:** `/api/events`
- **Method:** `POST`
- **Description:** Creates a new event.

##### Request

- **Headers:**
    - `Content-Type: application/json`
    - `Authorization: Bearer <jwt_token>`

- **Body:**

    ```json
    {
        "title": "Team Meeting",
        "description": "Discuss project goals",
        "date": "2025-01-15T10:00:00Z",
        "location": "Zoom"
    }
    ```

##### Responses

- **Success (201 Created):**

    ```json
    {
        "message": "Event created successfully",
        "event": {
            "eventId": 1,
            "title": "Team Meeting",
            "description": "Discuss project goals",
            "date": "2025-01-15T10:00:00Z",
            "location": "Zoom",
            "userId": 42,
            "createdAt": "2025-01-01T12:00:00Z"
        }
    }
    ```

- **Error (400 Bad Request):** Missing required fields.

    ```json
    {
        "message": "Please enter all required fields"
    }
    ```

- **Error (401 Unauthorized):** Missing or invalid JWT token.

    ```json
    {
        "message": "No token, authorization denied"
    }
    ```

- **Error (500 Internal Server Error):**

    ```json
    {
        "message": "Server error"
    }
    ```

---

#### Get Events

- **URL:** `/api/events`
- **Method:** `GET`
- **Description:** Retrieves all events created by the authenticated user.

##### Request

- **Headers:**
    - `Authorization: Bearer <jwt_token>`

##### Responses

- **Success (200 OK):**

    ```json
    [
        {
            "eventId": 1,
            "title": "Team Meeting",
            "description": "Discuss project goals",
            "date": "2025-01-15T10:00:00Z",
            "location": "Zoom",
            "userId": 42,
            "createdAt": "2025-01-01T12:00:00Z"
        },
        {
            "eventId": 2,
            "title": "Birthday Party",
            "description": "Celebrate John's 30th",
            "date": "2025-02-10T18:00:00Z",
            "location": "John's House",
            "userId": 42,
            "createdAt": "2025-01-05T09:30:00Z"
        }
    ]
    ```

- **Error (401 Unauthorized):**

    ```json
    {
        "message": "No token, authorization denied"
    }
    ```

- **Error (500 Internal Server Error):**

    ```json
    {
        "message": "Server error"
    }
    ```

---

#### Share Event

- **URL:** `/api/events/:eventId/share`
- **Method:** `POST`
- **Description:** Shares an event with another user by email.

##### Request

- **Headers:**
    - `Content-Type: application/json`
    - `Authorization: Bearer <jwt_token>`

- **Parameters:**
    - `eventId` (path parameter): ID of the event to share.

- **Body:**

    ```json
    {
        "email": "jane@example.com"
    }
    ```

##### Responses

- **Success (200 OK):**

    ```json
    {
        "message": "Event shared successfully."
    }
    ```

- **Error (400 Bad Request):** User is already an attendee or invalid email.

    ```json
    {
        "message": "Event already shared with this user."
    }
    ```

- **Error (404 Not Found):** Event or user not found.

    ```json
    {
        "message": "Event not found."
    }
    ```

- **Error (401 Unauthorized):**

    ```json
    {
        "message": "No token, authorization denied"
    }
    ```

- **Error (500 Internal Server Error):**

    ```json
    {
        "message": "Server error"
    }
    ```

---

#### Unshare Event
(TODO)

- **URL:** `/api/events/:eventId/unshare`
- **Method:** `POST`
- **Description:** Removes a shared user from an event.

##### Request

- **Headers:**
    - `Content-Type: application/json`
    - `Authorization: Bearer <jwt_token>`

- **Parameters:**
    - `eventId` (path parameter): ID of the event to unshare.

- **Body:**

    ```json
    {
        "email": "jane@example.com"
    }
    ```

##### Responses

- **Success (200 OK):**

    ```json
    {
        "message": "Event unshared successfully."
    }
    ```

- **Error (400 Bad Request):** Event is not shared with the user.

    ```json
    {
        "message": "Event is not shared with this user."
    }
    ```

- **Error (404 Not Found):** Event or user not found.

    ```json
    {
        "message": "User to unshare with not found."
    }
    ```

- **Error (401 Unauthorized):**

    ```json
    {
        "message": "No token, authorization denied"
    }
    ```

- **Error (500 Internal Server Error):**

    ```json
    {
        "message": "Server error"
    }
    ```

---

#### RSVP to Event

- **URL:** `/api/events/:eventId/rsvp`
- **Method:** `POST`
- **Description:** RSVPs to a shared event.

##### Request

- **Headers:**
    - `Content-Type: application/json`
    - `Authorization: Bearer <jwt_token>`

- **Parameters:**
    - `eventId` (path parameter): ID of the event to RSVP.

- **Body:**

    ```json
    {
        "status": "Attending" // Allowed values: "Attending", "Not Attending"
    }
    ```

##### Responses

- **Success (200 OK):**

    ```json
    {
        "message": "RSVP updated to \"Attending\"."
    }
    ```

- **Error (400 Bad Request):** Invalid status or user is not an attendee.

    ```json
    {
        "message": "You are not an attendee of this event."
    }
    ```

    or

    ```json
    {
        "message": "Invalid RSVP status. Allowed values are \"Attending\" and \"Not Attending\"."
    }
    ```

- **Error (404 Not Found):** Event not found.

    ```json
    {
        "message": "Event not found."
    }
    ```

- **Error (401 Unauthorized):**

    ```json
    {
        "message": "No token, authorization denied"
    }
    ```

- **Error (500 Internal Server Error):**

    ```json
    {
        "message": "Server error"
    }
    ```

---

#### Update RSVP Status
(TODO)

- **URL:** `/api/events/:eventId/rsvp`
- **Method:** `PUT`
- **Description:** Updates the RSVP status for a shared event.

##### Request

- **Headers:**
    - `Content-Type: application/json`
    - `Authorization: Bearer <jwt_token>`

- **Parameters:**
    - `eventId` (path parameter): ID of the event to update RSVP.

- **Body:**

    ```json
    {
        "status": "Not Attending" // Allowed values: "Attending", "Not Attending"
    }
    ```

##### Responses

- **Success (200 OK):**

    ```json
    {
        "message": "RSVP updated to \"Not Attending\"."
    }
    ```

- **Error (400 Bad Request):** Invalid status or user is not an attendee.

    ```json
    {
        "message": "You are not an attendee of this event."
    }
    ```

    or

    ```json
    {
        "message": "Invalid RSVP status. Allowed values are \"Attending\" and \"Not Attending\"."
    }
    ```

- **Error (404 Not Found):** Event not found.

    ```json
    {
        "message": "Event not found."
    }
    ```

- **Error (401 Unauthorized):**

    ```json
    {
        "message": "No token, authorization denied"
    }
    ```

- **Error (500 Internal Server Error):**

    ```json
    {
        "message": "Server error"
    }
    ```

---

#### Get Invitations

- **URL:** `/api/invitations`
- **Method:** `GET`
- **Description:** Retrieves all pending event invitations for the authenticated user.

##### Request

- **Headers:**
    - `Authorization: Bearer <jwt_token>`

##### Responses

- **Success (200 OK):**

    ```json
    {
        "invitations": [
            {
                "eventId": 2,
                "title": "Birthday Party",
                "description": "Celebrate John's 30th",
                "date": "2025-02-10T18:00:00Z",
                "location": "John's House",
                "sharedBy": {
                    "userId": 42,
                    "username": "john_doe",
                    "email": "john@example.com"
                },
                "status": "Pending"
            },
            // More invitations...
        ]
    }
    ```

- **Error (401 Unauthorized):**

    ```json
    {
        "message": "No token, authorization denied"
    }
    ```

- **Error (500 Internal Server Error):**

    ```json
    {
        "message": "Server error"
    }
    ```

---

## Error Handling

The API uses standard HTTP status codes to indicate the success or failure of API requests. Error responses include a `message` field that provides more details about the error.

### Common Error Responses

- **400 Bad Request:** The request was invalid or cannot be served. The exact error should be explained in the error message.
  
- **401 Unauthorized:** Authentication failed or user does not have permissions for the desired action.
  
- **404 Not Found:** The requested resource could not be found.
  
- **500 Internal Server Error:** An error occurred on the server. This could be due to unexpected conditions or failures.

### Example Error Response

```json
{
    "message": "User already exists"
}
```

---

## Glossary

- **User:** An individual who can register, log in, and interact with events.
  
- **Event:** A scheduled activity with details like title, description, date, and location.
  
- **EventAttendees:** A mapping between users and events, tracking RSVP statuses.
  
- **RSVP:** A response indicating a user's intention to attend or not attend an event.
  
- **JWT (JSON Web Token):** A compact, URL-safe means of representing claims to be transferred between two parties.
  
- **Azure SQL Database:** A fully managed relational cloud database service provided by Microsoft Azure.
  
- **Azure App Service:** A fully managed platform for building, deploying, and scaling web apps.

---

## Quick Start

### Prerequisites

- **Backend:**
    - Node.js installed
    - Azure SQL Database and App Service setup
    - Git installed

- **Frontend:**
    - iOS Development environment (Xcode)
  
### Setting Up the Backend Locally

1. **Clone the Repository:**

    ```bash
    git clone https://github.com/yourusername/spectrum-sync.git
    cd spectrum-sync/backend
    ```

2. **Install Dependencies:**

    ```bash
    npm install
    ```

3. **Configure Environment Variables:**

    - Rename `.env.example` to `.env` and fill in your Azure SQL credentials.

    ```env
    PORT=3000
    JWT_SECRET_AUTH=jwt_auth_secret_key
    JWT_SECRET_INVITE=jwt_invite_secret_key
    BASE_URL=theazurebaseURL
    DB_USER=adminuser
    DB_PASSWORD=your_sql_password
    DB_SERVER=spectrum-sync-sql.database.windows.net
    DB_DATABASE=SpectrumSyncDB
    DB_PORT=1433
    ```

4. **Run the Server:**

    ```bash
    node src/index.js
    ```

    The server should now be running on `http://localhost:3000`.

### Testing Endpoints with Postman

1. **Register a New User:**

    - **Method:** POST
    - **URL:** `http://localhost:3000/api/auth/register`
    - **Body:**

        ```json
        {
            "username": "john_doe",
            "email": "john@example.com",
            "password": "Password123!"
        }
        ```

2. **Login User:**

    - **Method:** POST
    - **URL:** `http://localhost:3000/api/auth/login`
    - **Body:**

        ```json
        {
            "email": "john@example.com",
            "password": "Password123!"
        }
        ```

    - **Response:** Copy the `token` from the response for authenticated requests.

3. **Create an Event:**

    - **Method:** POST
    - **URL:** `http://localhost:3000/api/events`
    - **Headers:**
        - `Authorization: Bearer <your-jwt-token>`
    - **Body:**

        ```json
        {
            "title": "Team Meeting",
            "description": "Discuss project goals",
            "date": "2025-01-15T10:00:00Z",
            "location": "Zoom"
        }
        ```

4. **Share an Event:**

    - **Method:** POST
    - **URL:** `http://localhost:3000/api/events/1/share`
    - **Headers:**
        - `Authorization: Bearer <your-jwt-token>`
    - **Body:**

        ```json
        {
            "email": "jane@example.com"
        }
        ```

---