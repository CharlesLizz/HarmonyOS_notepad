const express = require('express');
const router = express.Router();
const NoteController = require('../controllers/noteController');
const authMiddleware = require('../middleware/auth');

// 所有笔记路由都需要认证
router.use(authMiddleware);

// 创建新笔记
router.post('/', NoteController.createNote);

// 获取所有笔记
router.get('/', NoteController.getAllNotes);

// 获取单个笔记
router.get('/:id', NoteController.getNoteById);

// 更新笔记
router.put('/:id', NoteController.updateNote);

// 删除笔记
router.delete('/:id', NoteController.deleteNote);

module.exports = router; 