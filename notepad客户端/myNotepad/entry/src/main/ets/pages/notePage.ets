import router from '@ohos.router';
import { getNote, putNote } from '../common/class';
import { LengthMetrics, promptAction } from '@kit.ArkUI';
import { SendReqDelete, SendReqPut } from '../common/utils';
import PreferenceModel from '../common/preferences'

interface NotePageParams {
  note?: string;
}

@Entry
@Component
struct NotePage {
  @State note: getNote = new getNote('', '', '', '', '', '');
  @State title: string = ''
  @State content: string = ''
  @State token: string = ''

  onPageShow() {

    PreferenceModel.getToken().then((res) => {
      this.token = res.toString()
    })

    let params = router.getParams() as NotePageParams;
    if (params && params.note) {
      this.note = JSON.parse(params.note);
      this.title = this.note.title;
    }
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Image($r('app.media.back'))
          .width("24vp")
          .height("24vp")
          .onClick(() => {
            this.showSaveConfirmDialog();
          })

        Text(this.title)
          .fontSize("20fp")
          .fontWeight(FontWeight.Bold)
          .fontColor("#182431")
          .width("90%")
          .textAlign(TextAlign.Center)

        // 占位符保持对齐
        Blank()

        Image($r('app.media.delete'))
          .width("24vp")
          .height("24vp")
          .onClick(() => {
            this.showDeleteConfirmDialog();
          })
      }
      .padding({ left: "16vp", right: "16vp" })
      .margin({ top: "16vp", bottom: "16vp" })
      .width("100%")

      // 标题输入框
      TextInput({ placeholder: '请输入标题', text: this.note.title })
        .onChange((value: string) => {
          this.title = value;
          this.note.title = value;
        })
        .fontSize("18fp")
        .fontWeight(FontWeight.Bold)
        .fontColor("#182431")
        .width("95%")
        .padding({
          top: "12vp",
          bottom: "12vp",
          left: "16vp",
          right: "16vp"
        })
        .border({
          width: 1,
          color: "#D9D9D9",
          radius: 8
        })
        .shadow({ color: "#17202a11", radius: 4 })
        .backgroundColor("#FFFFFF")
        .margin({ bottom: "16vp" })

      // 在标题输入框与内容输入框之间插入以下代码
      Row() {
        Column() {
          Text('创建时间：' + this.note.created_at)
            .fontSize("14fp")
            .fontColor("#5A6370")
            .margin({ top: "8vp", bottom: "4vp" })

          Text('最后修改时间：' + this.note.updated_at)
            .fontSize("14fp")
            .fontColor("#5A6370")
            .margin({ top: "4vp", bottom: "8vp" })
        }
        .width("95%")
        .padding({ left: "16vp", right: "16vp" })
        .backgroundColor("#FFFFFF")
        .border({
          width: 1,
          color: "#D9D9D9",
          radius: 8
        })
        .shadow({ color: "#17202a11", radius: 4 })
        .margin({ bottom: "16vp" })
      }


      // 内容输入框
      TextArea({ placeholder: '请输入笔记内容...', text: this.note.content })
        .onChange((value: string) => {
          this.note.content = value;
        })
        .fontSize("16fp")
        .fontColor("#333333")
        .width("95%")
        .lineSpacing(LengthMetrics.vp(6))
        .padding({
          top: "16vp",
          bottom: "16vp",
          left: "16vp",
          right: "16vp"
        })
        .border({
          width: 1,
          color: "#D9D9D9",
          radius: 8
        })
        .shadow({ color: "#17202a11", radius: 4 })
        .backgroundColor("#FFFFFF")
        .layoutWeight(1)
    }
    .width("100%")
    .height("100%")
    .padding({
      top: "0vp",
      bottom: "0vp",
      left: "0vp",
      right: "0vp"
    })
    .backgroundColor("#F8F9FA")
  }

  showSaveConfirmDialog() {
    AlertDialog.show({
      title: '提示',
      message: '是否保存当前笔记？',
      primaryButton: {
        value: '保存',
        action: () => {
          this.saveNote();
        }
      },
      secondaryButton: {
        value: '不保存',
        action: () => {
          router.back();
        }
      },
      cancel: () => {
        console.info('取消操作');
      }
    });
  }

  showDeleteConfirmDialog() {
    AlertDialog.show({
      title: '提示',
      message: '是否删除当前笔记？',
      primaryButton: {
        value: '删除',
        action: () => {
          this.deleteNote();
        }
      },
      secondaryButton: {
        value: '取消',
        action: () => {
          console.info('用户选择不删除');
        }
      },
      cancel: () => {
        console.info('取消删除');
      }
    });
  }

  saveNote() {
    if (!this.title.trim()) {
      this.title = this.note.content.substring(0, 5);
      this.note.title = this.title;
    }
    SendReqPut("notes/" + this.note.id, this.token, new Object({
      title: this.note.title,
      content: this.note.content
    }), (data: putNote) => {
      const obj = data as putNote
      console.info('返回数据为：' + JSON.stringify(obj))
      if (obj.error) {
        promptAction.showToast({
          message: obj.error,
          duration: 2000,
        })
      } else if (obj.message == "笔记更新成功") {
        promptAction.showToast({
          message: obj.message,
          duration: 2000,
        })
        router.back()
      }
    })
  }

  deleteNote() {
    SendReqDelete("notes/" + this.note.id, this.token, (data: putNote) => {
      const obj = data as putNote
      if (obj.error) {
        promptAction.showToast({
          message: obj.error,
          duration: 2000,
        })
      } else if (obj.message == "笔记删除成功") {
        promptAction.showToast({
          message: obj.message,
          duration: 2000,
        })
        router.back()
      }

    })

  }
}
