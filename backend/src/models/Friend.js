// src/models/Friend.js

const sql = require('mssql');

/**
 * Friend Model
 * Encapsulates all friend-related database operations.
 */
class Friend {
    /**
     * Adds a friendship between two users.
     * @param {sql.ConnectionPool} pool - The database connection pool.
     * @param {number} userId - The ID of the user initiating the friendship.
     * @param {number} friendUserId - The ID of the user to be added as a friend.
     * @returns {Promise<void>}
     */
    static async addFriend(pool, userId, friendUserId) {
        await pool.request()
            .input('userId', sql.Int, userId)
            .input('friendUserId', sql.Int, friendUserId)
            .query(`
                INSERT INTO Friends (userId, friendUserId)
                VALUES (@userId, @friendUserId)
            `);
    }

    /**
     * Removes a friendship between two users.
     * @param {sql.ConnectionPool} pool - The database connection pool.
     * @param {number} userId - The ID of the user initiating the removal.
     * @param {number} friendUserId - The ID of the friend to be removed.
     * @returns {Promise<void>}
     */
    static async removeFriend(pool, userId, friendUserId) {
        await pool.request()
            .input('userId', sql.Int, userId)
            .input('friendUserId', sql.Int, friendUserId)
            .query(`
                DELETE FROM Friends 
                WHERE userId = @userId AND friendUserId = @friendUserId
            `);
    }

    /**
     * Checks if a friendship exists between two users.
     * @param {sql.ConnectionPool} pool - The database connection pool.
     * @param {number} userId - The ID of the first user.
     * @param {number} friendUserId - The ID of the second user.
     * @returns {Promise<boolean>} - Returns true if the friendship exists, else false.
     */
    static async isFriend(pool, userId, friendUserId) {
        const result = await pool.request()
            .input('userId', sql.Int, userId)
            .input('friendUserId', sql.Int, friendUserId)
            .query(`
                SELECT * FROM Friends 
                WHERE userId = @userId AND friendUserId = @friendUserId
            `);
        return result.recordset.length > 0;
    }

    /**
     * Retrieves the list of friends for a given user.
     * @param {sql.ConnectionPool} pool - The database connection pool.
     * @param {number} userId - The ID of the user.
     * @returns {Promise<Array>} - Returns an array of friend user IDs.
     */
    static async getFriendsList(pool, userId) {
        const result = await pool.request()
            .input('userId', sql.Int, userId)
            .query(`
                SELECT friendUserId FROM Friends 
                WHERE userId = @userId
            `);
        return result.recordset.map(record => record.friendUserId);
    }
}

module.exports = Friend;