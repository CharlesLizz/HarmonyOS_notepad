interface registerCallBack {
  message: string
  token: string
  error: string
}

interface loginCallBack {
  message: string
  token: string
  error: string

}

interface putNote {
  message: string
  error: string
}

interface addNote {
  message: string
  error: string
  id: string
}

class getNote {
  id: string
  username: string
  title: string
  content: string
  created_at: string
  updated_at: string
  error?: string

  constructor(id: string, username: string, title: string, content: string, created_at: string, updated_at: string,
    error?: string) {
    this.id = id
    this.username = username
    this.title = title
    this.content = content
    this.created_at = created_at
    this.updated_at = updated_at
    this.error = error
  }
}


export { registerCallBack, loginCallBack, getNote, putNote, addNote }