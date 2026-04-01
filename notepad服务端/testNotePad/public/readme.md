# 记事本应用 API 文档

这是一个基于 Node.js + Express + MySQL 实现的记事本应用后端API服务。

## 技术栈

- Node.js
- Express.js
- MySQL
- JWT认证
- CORS支持



1. 配置数据库连接
在 `src/config/database.js` 文件中修改数据库连接配置：
```javascript
const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '1234'
});
```

2. 启动服务器
```bash
npm start
```

服务器启动时会自动：
- 创建数据库（如果不存在）
- 创建用户表（如果不存在）
- 创建笔记表（如果不存在）

服务器将在 http://localhost:8082 启动

## API 接口文档

### 1. 用户认证

#### 1.1 用户注册
- **URL**: `/api/users/register`
- **方法**: `POST`
- **Content-Type**: `application/json`
- **请求体**:
  ```json
  {
    "username": "用户名",
    "password": "密码"
  }
  ```
- **成功响应**:
  ```json
  {
    "message": "注册成功",
    "token": "JWT令牌"
  }
  ```
- **错误响应**:
  ```json
  {
    "error": "错误信息"
  }
  ```

#### 1.2 用户登录
- **URL**: `/api/users/login`
- **方法**: `POST`
- **Content-Type**: `application/json`
- **请求体**:
  ```json
  {
    "username": "用户名",
    "password": "密码"
  }
  ```
- **成功响应**:
  ```json
  {
    "message": "登录成功",
    "token": "JWT令牌"
  }
  ```
- **错误响应**:
  ```json
  {
    "error": "错误信息"
  }
  ```

### 2. 笔记管理

所有笔记相关的API都需要在请求头中添加认证令牌：
```
Authorization: Bearer <JWT令牌>
```

#### 2.1 创建笔记
- **URL**: `/api/notes`
- **方法**: `POST`
- **Content-Type**: `application/json`
- **请求体**:
  ```json
  {
    "title": "笔记标题",
    "content": "笔记内容"
  }
  ```
- **成功响应**:
  ```json
  {
    "message": "笔记创建成功",
    "id": 1
  }
  ```

#### 2.2 获取所有笔记
- **URL**: `/api/notes`
- **方法**: `GET`
- **成功响应**:
  ```json
  [
    {
      "id": 1,
      "title": "笔记标题",
      "content": "笔记内容",
      "created_at": "2024-04-30T10:00:00Z",
      "updated_at": "2024-04-30T10:00:00Z"
    }
  ]
  ```

#### 2.3 获取单个笔记
- **URL**: `/api/notes/:id`
- **方法**: `GET`
- **成功响应**:
  ```json
  {
    "id": 1,
    "title": "笔记标题",
    "content": "笔记内容",
    "created_at": "2024-04-30T10:00:00Z",
    "updated_at": "2024-04-30T10:00:00Z"
  }
  ```

#### 2.4 更新笔记
- **URL**: `/api/notes/:id`
- **方法**: `PUT`
- **Content-Type**: `application/json`
- **请求体**:
  ```json
  {
    "title": "新标题",
    "content": "新内容"
  }
  ```
- **成功响应**:
  ```json
  {
    "message": "笔记更新成功"
  }
  ```

#### 2.5 删除笔记
- **URL**: `/api/notes/:id`
- **方法**: `DELETE`
- **成功响应**:
  ```json
  {
    "message": "笔记删除成功"
  }
  ```


## 错误处理

所有API在发生错误时都会返回以下格式的响应：
```json
{
  "error": "错误信息"
}
```

常见错误状态码：
- 400: 请求参数错误
- 401: 未授权或认证失败
- 404: 资源不存在
- 500: 服务器内部错误

## 注意事项

1. 所有笔记相关的API都需要在请求头中添加JWT令牌
2. 建议在前端使用localStorage或sessionStorage存储JWT令牌
3. 密码在传输前应该进行加密处理
4. 生产环境中应该使用HTTPS协议
5. 建议实现自动刷新令牌机制

## 开发建议

1. 前端开发时建议使用axios等HTTP客户端库
2. 实现请求拦截器统一处理认证令牌
3. 实现响应拦截器统一处理错误
4. 建议使用TypeScript进行开发
5. 实现全局loading状态管理

## 环境要求
- Node.js >= 14.0.0
- MySQL >= 5.7

## 开发团队
- 后端开发：[刘家轩]