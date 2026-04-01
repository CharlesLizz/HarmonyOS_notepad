const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const noteRoutes = require('./routes/noteRoutes');
const userRoutes = require('./routes/userRoutes');
const db = require('./config/database');
const path = require('path');
const app = express();

// 中间件
app.use(cors());
app.use(bodyParser.json());

// 配置静态文件服务
app.use(express.static(path.join(__dirname, '../public'))); // 只提供 public 目录中的静态文件

// 路由
app.use('/api/notes', noteRoutes);
app.use('/api/users', userRoutes);

// 初始化数据库表
async function initializeDatabase() {
    try {
        // 创建数据库（如果不存在）
        await new Promise((resolve, reject) => {
            db.query('CREATE DATABASE IF NOT EXISTS notepad', (err) => {
                if (err) reject(err);
                else resolve();
            });
        });

        // 使用数据库
        await new Promise((resolve, reject) => {
            db.query('USE notepad', (err) => {
                if (err) reject(err);
                else resolve();
            });
        });

        // 创建用户表
        await new Promise((resolve, reject) => {
            const createUsersTableSQL = `
                CREATE TABLE IF NOT EXISTS users (
                    id INT PRIMARY KEY AUTO_INCREMENT,
                    username VARCHAR(50) UNIQUE NOT NULL,
                    password VARCHAR(255) NOT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            `;
            db.query(createUsersTableSQL, (err) => {
                if (err) reject(err);
                else resolve();
            });
        });

        // 创建笔记表
        await new Promise((resolve, reject) => {
            const createNotesTableSQL = `
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
            db.query(createNotesTableSQL, (err) => {
                if (err) reject(err);
                else resolve();
            });
        });

        console.log('数据库表初始化成功');
    } catch (error) {
        console.error('数据库表初始化失败：', error);
        process.exit(1); // 如果数据库初始化失败，退出程序
    }
}

// 启动服务器
const PORT = process.env.PORT || 8082;
app.listen(PORT, async () => {
    console.log(`服务器已启动，监听端口 ${PORT}`);
    await initializeDatabase();
}); 