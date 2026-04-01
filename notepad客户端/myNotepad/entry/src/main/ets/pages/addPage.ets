import router from '@ohos.router';
import { addNote, getNote, putNote } from '../common/class';
import { LengthMetrics, promptAction } from '@kit.ArkUI';
import { SendReqDelete, SendReqPost, SendReqPut } from '../common/utils';
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

  aboutToAppear() {

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

  saveNote() {
    if (!this.title.trim()) {
      this.title = this.note.content.substring(0, 5);
      this.note.title = this.title;
    }
    SendReqPost("notes", this.token, new Object({
      title: this.note.title,
      content: this.note.content
    }), (data: addNote) => {
      const obj = data as addNote
      console.info('添加返回数据为：' + obj.message)
      if (obj.error) {
        promptAction.showToast({
          message: obj.error,
          duration: 2000,
        })
      } else if (obj.message == "笔记创建成功") {
        promptAction.showToast({
          message: obj.message,
          duration: 2000,
        })
        router.back()
      }
    })
  }
}
