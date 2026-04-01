# 记事本产品数据库设计

## 1. 用户表 (users)
| 字段名 | 类型 | 说明 | 约束 |
|--------|------|------|------|
| id | BIGINT | 用户ID | PRIMARY KEY, AUTO_INCREMENT |
| username | VARCHAR(50) | 用户名 | NOT NULL, UNIQUE |
| password | VARCHAR(255) | 密码（加密存储） | NOT NULL |
| email | VARCHAR(100) | 邮箱 | NOT NULL, UNIQUE |
| created_at | TIMESTAMP | 创建时间 | DEFAULT CURRENT_TIMESTAMP |
| updated_at | TIMESTAMP | 更新时间 | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |

## 2. 笔记表 (notes)
| 字段名 | 类型 | 说明 | 约束 |
|--------|------|------|------|
| id | BIGINT | 笔记ID | PRIMARY KEY, AUTO_INCREMENT |
| user_id | BIGINT | 用户ID | FOREIGN KEY REFERENCES users(id) |
| title | VARCHAR(100) | 笔记标题 | NOT NULL |
| content | TEXT | 笔记内容 | |
| is_deleted | TINYINT | 是否删除 | DEFAULT 0 |
| created_at | TIMESTAMP | 创建时间 | DEFAULT CURRENT_TIMESTAMP |
| updated_at | TIMESTAMP | 更新时间 | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |

## 3. 标签表 (tags)
| 字段名 | 类型 | 说明 | 约束 |
|--------|------|------|------|
| id | BIGINT | 标签ID | PRIMARY KEY, AUTO_INCREMENT |
| user_id | BIGINT | 用户ID | FOREIGN KEY REFERENCES users(id) |
| name | VARCHAR(50) | 标签名称 | NOT NULL |
| color | VARCHAR(20) | 标签颜色 | |
| created_at | TIMESTAMP | 创建时间 | DEFAULT CURRENT_TIMESTAMP |

## 4. 笔记-标签关联表 (note_tags)
| 字段名 | 类型 | 说明 | 约束 |
|--------|------|------|------|
| id | BIGINT | 关联ID | PRIMARY KEY, AUTO_INCREMENT |
| note_id | BIGINT | 笔记ID | FOREIGN KEY REFERENCES notes(id) |
| tag_id | BIGINT | 标签ID | FOREIGN KEY REFERENCES tags(id) |
| created_at | TIMESTAMP | 创建时间 | DEFAULT CURRENT_TIMESTAMP |

## 5. 笔记历史记录表 (note_history)
| 字段名 | 类型 | 说明 | 约束 |
|--------|------|------|------|
| id | BIGINT | 历史记录ID | PRIMARY KEY, AUTO_INCREMENT |
| note_id | BIGINT | 笔记ID | FOREIGN KEY REFERENCES notes(id) |
| content | TEXT | 历史内容 | |
| created_at | TIMESTAMP | 创建时间 | DEFAULT CURRENT_TIMESTAMP |

## 索引设计
1. users表：
   - 在username和email字段上创建唯一索引
   - 在email字段上创建普通索引

2. notes表：
   - 在user_id字段上创建索引
   - 在created_at字段上创建索引
   - 在is_deleted字段上创建索引

3. tags表：
   - 在user_id字段上创建索引
   - 在name字段上创建索引

4. note_tags表：
   - 在note_id和tag_id字段上创建联合索引
   - 在tag_id字段上创建索引

5. note_history表：
   - 在note_id字段上创建索引
   - 在created_at字段上创建索引

## 数据库关系说明
1. 一个用户可以创建多篇笔记（一对多）
2. 一篇笔记可以关联多个标签（多对多）
3. 一个标签可以关联多篇笔记（多对多）
4. 一篇笔记可以有多个历史版本（一对多） 