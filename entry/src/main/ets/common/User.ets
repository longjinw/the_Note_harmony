// 笔记类型定义
export interface Note {
  id: string;           // 笔记ID
  title: string;        // 笔记标题
  content: string;      // 笔记内容
  createTime: string;   // 创建时间
  updateTime: string;   // 更新时间
}

// 用户类
export class User {
  private username: string;      // 用户账号
  private password: string;      // 用户密码
  private notes: Note[];        // 笔记数组

  constructor(username: string, password: string) {
    this.username = username;
    this.password = password;
    this.notes = [];
  }

  // 获取用户账号
  getUsername(): string {
    return this.username;
  }

  // 获取用户密码
  getPassword(): string {
    return this.password;
  }

  // 获取所有笔记
  getNotes(): Note[] {
    return this.notes;
  }

  // 添加笔记
  addNote(note: Note): void {
    this.notes.push(note);
  }

  // 删除笔记
  deleteNote(noteId: string): void {
    this.notes = this.notes.filter(note => note.id !== noteId);
  }

  // 更新笔记
  updateNote(noteId: string, updatedNote: Note): void {
    const index = this.notes.findIndex(note => note.id === noteId);
    if (index !== -1) {
      this.notes[index] = updatedNote;
    }
  }

  // 获取指定笔记
  getNote(noteId: string): Note | undefined {
    return this.notes.find(note => note.id === noteId);
  }
} 