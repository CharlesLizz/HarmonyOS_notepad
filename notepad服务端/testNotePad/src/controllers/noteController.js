const Note = require('../models/note');

class NoteController {
    static async createNote(req, res) {
        try {
            const { title, content } = req.body;
            const userId = req.user.id;

            if (!title || !content) {
                return res.status(400).json({ error: '标题和内容不能为空' });
            }

            const result = await Note.create(userId, title, content);
            res.status(201).json({ 
                message: '笔记创建成功', 
                id: String(result.insertId) 
            });
        } catch (error) {
            console.error('创建笔记失败：', error);
            res.status(500).json({ error: '服务器错误' });
        }
    }

    static async getAllNotes(req, res) {
        try {
            const userId = req.user.id;
            const notes = await Note.getAll(userId);
            const formattedNotes = notes.map(note => ({
                ...note,
                id: String(note.id),
                user_id: String(note.user_id)
            }));
            res.json(formattedNotes);
        } catch (error) {
            console.error('获取笔记列表失败：', error);
            res.status(500).json({ error: '服务器错误' });
        }
    }

    static async getNoteById(req, res) {
        try {
            const { id } = req.params;
            const userId = req.user.id;

            const note = await Note.getById(id, userId);
            if (!note) {
                return res.status(404).json({ error: '笔记不存在' });
            }

            const formattedNote = {
                ...note,
                id: String(note.id),
                user_id: String(note.user_id)
            };
            res.json(formattedNote);
        } catch (error) {
            console.error('获取笔记失败：', error);
            res.status(500).json({ error: '服务器错误' });
        }
    }

    static async updateNote(req, res) {
        try {
            const { id } = req.params;
            const { title, content } = req.body;
            const userId = req.user.id;

            if (!title || !content) {
                return res.status(400).json({ error: '标题和内容不能为空' });
            }

            const result = await Note.update(id, userId, title, content);
            if (result.affectedRows === 0) {
                return res.status(404).json({ error: '笔记不存在' });
            }

            res.json({ message: '笔记更新成功' });
        } catch (error) {
            console.error('更新笔记失败：', error);
            res.status(500).json({ error: '服务器错误' });
        }
    }

    static async deleteNote(req, res) {
        try {
            const { id } = req.params;
            const userId = req.user.id;

            const result = await Note.delete(id, userId);
            if (result.affectedRows === 0) {
                return res.status(404).json({ error: '笔记不存在' });
            }

            res.json({ message: '笔记删除成功' });
        } catch (error) {
            console.error('删除笔记失败：', error);
            res.status(500).json({ error: '服务器错误' });
        }
    }
}

module.exports = NoteController; 