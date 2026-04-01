const db = require('../config/database');

class Note {
    static createTable() {
        const createTableSQL = `
            CREATE TABLE IF NOT EXISTS notes (
                id INT PRIMARY KEY AUTO_INCREMENT,
                user_id INT NOT NULL,
                title VARCHAR(100) NOT NULL,
                content TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES users(id)
            )
        `;
        
        return new Promise((resolve, reject) => {
            db.query(createTableSQL, (err, results) => {
                if (err) reject(err);
                else resolve(results);
            });
        });
    }

    static create(userId, title, content) {
        return new Promise((resolve, reject) => {
            db.query(
                'INSERT INTO notes (user_id, title, content) VALUES (?, ?, ?)',
                [userId, title, content],
                (err, results) => {
                    if (err) reject(err);
                    else resolve(results);
                }
            );
        });
    }

    static getAll(userId) {
        return new Promise((resolve, reject) => {
            db.query(
                'SELECT * FROM notes WHERE user_id = ? ORDER BY updated_at DESC',
                [userId],
                (err, results) => {
                    if (err) reject(err);
                    else resolve(results);
                }
            );
        });
    }

    static getById(id, userId) {
        return new Promise((resolve, reject) => {
            db.query(
                'SELECT * FROM notes WHERE id = ? AND user_id = ?',
                [id, userId],
                (err, results) => {
                    if (err) reject(err);
                    else resolve(results[0]);
                }
            );
        });
    }

    static update(id, userId, title, content) {
        return new Promise((resolve, reject) => {
            db.query(
                'UPDATE notes SET title = ?, content = ? WHERE id = ? AND user_id = ?',
                [title, content, id, userId],
                (err, results) => {
                    if (err) reject(err);
                    else resolve(results);
                }
            );
        });
    }

    static delete(id, userId) {
        return new Promise((resolve, reject) => {
            db.query(
                'DELETE FROM notes WHERE id = ? AND user_id = ?',
                [id, userId],
                (err, results) => {
                    if (err) reject(err);
                    else resolve(results);
                }
            );
        });
    }
}

module.exports = Note; 