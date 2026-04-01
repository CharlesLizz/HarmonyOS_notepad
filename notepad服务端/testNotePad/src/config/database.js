const mysql = require('mysql');

// 首先创建一个不指定数据库的连接
const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',  // XAMPP默认root密码为空
    port: 3316     // 明确指定端口
});

// 尝试连接并创建数据库
connection.connect((err) => {
    if (err) {
        console.error('数据库连接失败：', err);
        return;
    }
    
    // 创建数据库
    connection.query('CREATE DATABASE IF NOT EXISTS notepad', (err) => {
        if (err) {
            console.error('创建数据库失败：', err);
            return;
        }
        console.log('数据库 notepad 创建成功或已存在');
        
        // 切换到新创建的数据库
        connection.query('USE notepad', (err) => {
            if (err) {
                console.error('切换数据库失败：', err);
                return;
            }
            console.log('已切换到数据库 notepad');
        });
    });
});

module.exports = connection; 