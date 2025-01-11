// src/models/Chat.js

const sql = require('mssql');

class Chat {
    constructor(chatId, chatName, isGroupChat, createdBy, createdAt) {
        this.chatId = chatId;
        this.chatName = chatName;
        this.isGroupChat = isGroupChat;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
    }

    static async create(pool, chatName, isGroupChat, createdBy) {
        const result = await pool.request()
            .input('chatName', sql.NVarChar, chatName)
            .input('isGroupChat', sql.Bit, isGroupChat)
            .input('createdBy', sql.Int, createdBy)
            .query(`
                INSERT INTO Chats (chatName, isGroupChat, createdBy)
                VALUES (@chatName, @isGroupChat, @createdBy);
                SELECT SCOPE_IDENTITY() AS chatId;
            `);

        const chatId = result.recordset[0].chatId;
        return new Chat(chatId, chatName, isGroupChat, createdBy, new Date());
    }

    static async addMembers(pool, chatId, userIds) {
        const queries = userIds.map(userId => {
            return pool.request()
                .input('chatId', sql.Int, chatId)
                .input('userId', sql.Int, userId)
                .query(`
                    INSERT INTO ChatMembers (chatId, userId)
                    VALUES (@chatId, @userId)
                `);
        });
        await Promise.all(queries);
    }

    static async isValidFriend(pool, creatorId, userIds) {
        const friendCheckResult = await pool.request()
            .input('creatorId', sql.Int, creatorId)
            .query(`
                SELECT friendUserId FROM Friends
                WHERE userId = @creatorId AND friendUserId IN (${userIds.join(',')})
            `);
        return friendCheckResult.recordset.length === userIds.length;
    }

    static async isMember(pool, chatId, userId) {
        const memberCheckResult = await pool.request()
            .input('chatId', sql.Int, chatId)
            .input('userId', sql.Int, userId)
            .query(`SELECT chatMemberId FROM ChatMembers WHERE chatId = @chatId AND userId = @userId`);
        return memberCheckResult.recordset.length > 0;
    }

    static async removeMember(pool, chatId, userId) {
        await pool.request()
            .input('chatId', sql.Int, chatId)
            .input('userId', sql.Int, userId)
            .query(`
                DELETE FROM ChatMembers WHERE chatId = @chatId AND userId = @userId
            `);
    }

    static async getChatsByUserId(pool, userId) {
        const result = await pool.request()
            .input('userId', sql.Int, userId)
            .query(`
                SELECT c.chatId, c.chatName, c.isGroupChat, c.createdAt
                FROM Chats c
                INNER JOIN ChatMembers cm ON c.chatId = cm.chatId
                WHERE cm.userId = @userId
                ORDER BY c.createdAt DESC
            `);

        return result.recordset;
    }

    // Retrieve the 20 most recent messages sent in a chat
    static async getRecentMessages(pool, chatId, limit = 20) {
        const result = await pool.request()
            .input('chatId', sql.Int, chatId)
            .input('limit', sql.Int, limit)
            .query(`
                SELECT m.messageId, m.userId, u.username, m.content, m.createdAt
                FROM Messages m
                INNER JOIN Users u ON m.userId = u.userId
                WHERE m.chatId = @chatId
                ORDER BY m.createdAt DESC
                OFFSET 0 ROWS FETCH NEXT @limit ROWS ONLY
            `);

        return result.recordset;
    }

    static async doesChatExist(pool, chatId) {
        const result = await pool.request()
            .input('chatId', sql.Int, chatId)
            .query(`
                SELECT chatId FROM Chats WHERE chatId = @chatId
            `);

        return result.recordset.length > 0;
    }
}

module.exports = Chat;