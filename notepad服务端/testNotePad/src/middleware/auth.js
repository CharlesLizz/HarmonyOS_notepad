const jwt = require('jsonwebtoken');
const db = require('../config/database');

const authMiddleware = async (req, res, next) => {
    try {
        const token = req.headers.authorization?.split(' ')[1];
        
        if (!token) {
            return res.status(401).json({ error: '未提供认证令牌' });
        }

        const decoded = jwt.verify(token, process.env.JWT_SECRET || 'your-secret-key');
        
        // 验证用户是否存在
        const [user] = await new Promise((resolve, reject) => {
            db.query('SELECT * FROM users WHERE id = ?', [decoded.id], (err, results) => {
                if (err) reject(err);
                else resolve(results);
            });
        });

        if (!user) {
            return res.status(401).json({ error: '用户不存在' });
        }

        // 将用户信息添加到请求对象中
        req.user = user;
        next();
    } catch (error) {
        console.error('认证失败：', error);
        res.status(401).json({ error: '无效的认证令牌' });
    }
};

module.exports = authMiddleware; 