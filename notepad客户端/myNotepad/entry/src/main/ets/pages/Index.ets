import { getNote } from '../common/class';
import { SendReqGet, SendReqPost } from '../common/utils';
import PreferenceModel from '../common/preferences'
import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State message: string = 'notepad';
  @State notes: getNote[] = [];
  @State msg: string = '暂无便签'
  @State token: string = ''

  onPageShow() {

    PreferenceModel.getToken().then((res) => {
      this.token = res.toString()
    })

    setTimeout(() => {
      SendReqGet("notes", this.token, (data: getNote[]) => {
        let obj = data
        this.notes = [];
        for (let i = 0; i < obj.length; i++) {
          let item = obj[i];
          let note = new getNote(
            item.id,
            item.username,
            item.title,
            item.content,
            item.created_at,
            item.updated_at
          );
          this.notes.push(note);
        }
      })
    }, 1000)
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Text(this.message)
          .fontSize("24fp")
          .fontWeight(FontWeight.Bold)
          .fontColor("#182431")

        Image($rawfile('add.png'))
          .width("24vp")
          .height("24vp")
          .onClick(() => {
            router.pushUrl({
              url: 'pages/addPage'
            });
          })
      }
      .width('90%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: "16vp", bottom: "8vp" })

      // 笔记列表
      if (this.notes.length > 0) {
        List({ space: 10 }) {
          ForEach(this.notes, (item: getNote, index: number) => {
            ListItem() {
              Column() {
                Text(item.title)
                  .fontSize("18fp")
                  .fontWeight(FontWeight.Bold)
                  .fontColor("#182431")
                  .width("100%")
                  .textAlign(TextAlign.Start)

                Text(item.content)
                  .fontSize("14fp")
                  .fontColor("#5A6370")
                  .width("100%")
                  .textAlign(TextAlign.Start)
                  .margin({ top: "4vp" })
              }
              .padding({
                left: "16vp",
                right: "16vp",
                top: "12vp",
                bottom: "12vp"
              })
              .borderRadius(12)
              .backgroundColor("#FFFFFF")
              .shadow({ color: "#17202a33", radius: 8 }) // 卡片阴影
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/notePage',
                  params: {
                    note: JSON.stringify(item) // 将当前笔记对象序列化为字符串传递
                  }
                });
              })

            }
          })
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: "16vp", right: "16vp", top: "16vp" })
      } else {
        Text(this.msg)
          .fontSize("16fp")
          .fontWeight(FontWeight.Medium)
          .fontColor("#888888")
          .margin({ top: "32vp" })
      }

    }
    .width("100%")
    .height("100%")
    .padding({
      top: "16vp",
      bottom: "16vp",
      left: "8vp",
      right: "8vp"
    })
    .backgroundColor("#F8F9FA") // 背景色提升整体质感
  }
}