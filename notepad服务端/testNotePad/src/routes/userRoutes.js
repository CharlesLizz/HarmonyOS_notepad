const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const db = require('../config/database');

// 用户注册
router.post('/register', async (req, res) => {
    try {
        const { username, password } = req.body;
        
        if (!username || !password) {
            return res.status(400).json({ error: '用户名和密码不能为空' });
        }

        // 检查用户名是否已存在
        const [existingUser] = await new Promise((resolve, reject) => {
            db.query('SELECT * FROM users WHERE username = ?', [username], (err, results) => {
                if (err) reject(err);
                else resolve(results);
            });
        });

        if (existingUser) {
            return res.status(400).json({ error: '用户名已存在' });
        }

        // 加密密码
        const hashedPassword = await bcrypt.hash(password, 10);

        // 创建用户
        const result = await new Promise((resolve, reject) => {
            db.query('INSERT INTO users (username, password) VALUES (?, ?)', 
                [username, hashedPassword], 
                (err, results) => {
                    if (err) reject(err);
                    else resolve(results);
                }
            );
        });

        // 生成JWT令牌
        const token = jwt.sign(
            { id: result.insertId, username },
            process.env.JWT_SECRET || 'your-secret-key',
            { expiresIn: '24h' }
        );

        res.status(201).json({
            message: '注册成功',
            token
        });
    } catch (error) {
        console.error('注册失败：', error);
        res.status(500).json({ error: '服务器错误' });
    }
});

// 用户登录
router.post('/login', async (req, res) => {
    try {
        const { username, password } = req.body;
        
        if (!username || !password) {
            return res.status(400).json({ error: '用户名和密码不能为空' });
        }

        // 查找用户
        const [user] = await new Promise((resolve, reject) => {
            db.query('SELECT * FROM users WHERE username = ?', [username], (err, results) => {
                if (err) reject(err);
                else resolve(results);
            });
        });

        if (!user) {
            return res.status(401).json({ error: '用户名或密码错误' });
        }

        // 验证密码
        const isValidPassword = await bcrypt.compare(password, user.password);
        if (!isValidPassword) {
            return res.status(401).json({ error: '用户名或密码错误' });
        }

        // 生成JWT令牌
        const token = jwt.sign(
            { id: user.id, username: user.username },
            process.env.JWT_SECRET || 'your-secret-key',
            { expiresIn: '24h' }
        );

        res.json({
            message: '登录成功',
            token
        });
    } catch (error) {
        console.error('登录失败：', error);
        res.status(500).json({ error: '服务器错误' });
    }
});

module.exports = router; 