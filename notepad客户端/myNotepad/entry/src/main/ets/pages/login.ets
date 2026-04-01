import router from '@ohos.router';
import { getNote, loginCallBack } from '../common/class';
import { SendReqGet, SendReqPost } from '../common/utils';
import PreferenceModel from '../common/preferences'

@Entry
@Component
struct Login {
  @StorageProp('currentDeviceSize') currentDeviceSize: string = 'sm';

  build() {
    GridRow({
      columns: {
        sm: 4,
        md: 8,
        lg: 12
      },
      gutter: {
        x: 12
      }
    }) {
      GridCol({
        span: {
          sm: 4,
          md: 6,
          lg: 8
        }, offset: {
          md: 1,
          lg: 2
        }
      }) {
        Column() {
          LoginTitle()
          LoginBottom()
        }
      }
    }
    .backgroundColor("#F1F3F5")
  }
}

@Preview
@Component
struct LoginTitle {
  build() {
    Column() {
      Image($r('app.media.startIcon'))
        .width("78vp")
        .height("78vp")
        .margin({ bottom: "8vp" })
      Text("登录")
        .fontSize("24fp")
        .fontWeight(FontWeight.Medium)
        .fontColor("#182431")

    }
    .backgroundColor("#F1F3F5")
    .justifyContent(FlexAlign.Center)
    .width("100%")
    .height("40%")
  }
}

@Preview
@Component
struct LoginBottom {
  @State account: string = '';
  @State password: string = '';
  @State text: string = '';
  @State notes: getNote[] = [];
  @State token: string = ''

  build() {
    Column() {
      Column() {
        TextInput({ placeholder: "请输入账号" })
          .maxLength(11)
          .inputStyle()
          .onChange((value: string) => {
            this.account = value;
          })

        Line()
          .width("100%")
          .height("0.5vp")
          .margin({
            left: "12vp",
            right: "12vp"
          })
          .backgroundColor("#0D182431")

        TextInput({ placeholder: "请输入密码" })
          .maxLength(8)
          .type(InputType.Password)
          .inputStyle()
          .onChange((value: string) => {
            this.password = value;
          })
      }
      .backgroundColor(Color.White)
      .borderRadius("24vp")

      Text(this.text)
        .fontColor("#ffff112c")
        .fontSize("12fp")
        .fontWeight(FontWeight.Medium)
        .margin({ top: "24vp" })

      Text("还没有账号？点击前往注册")
        .fontColor("#007DFF")
        .fontSize("14fp")
        .fontWeight(FontWeight.Medium)
        .margin({ top: "24vp" })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/register'
          })
        })

      Button("登录")
        .id("loginButtonId")
        .width("100%")
        .height("40vp")
        .fontSize("16fp")
        .fontWeight(FontWeight.Medium)
        .backgroundColor("#007DFF")
        .margin({
          top: "48vp",
          bottom: "12vp"
        })
        .onClick(() => {
          if (!this.account) {
            this.text = "账号不能为空！"
            console.log("账号不能为空！")
          } else if (!this.password) {
            this.text = "密码不能为空！"
          } else {
            this.text = ""

            SendReqPost("users/login", '', new Object({
              username: this.account,
              password: this.password
            }), (data: loginCallBack) => {
              const obj = data as loginCallBack
              if (obj.error) {
                console.log(obj.error)
                this.text = obj.error
              } else if (obj.message == "登录成功") {
                PreferenceModel.deletePreferences()
                PreferenceModel.writeData(obj.token.toString())
                // tokenMap.set('token', obj.token)

                // PreferenceModel.getToken().then((res: string) => {
                //
                //   console.info('token ' + res.toString())
                // })

                // console.info('token ' + JSON.stringify(PreferenceModel.getToken()))
                router.replaceUrl({
                  url: 'pages/Index'
                })


              }
            })
          }


        })
    }
    .padding({
      left: "12vp",
      right: "12vp",
    })
    .backgroundColor("#F1F3F5")
    .height("60%")
  }
}

@Extend(TextInput)
function inputStyle() {
  .placeholderColor("#99182431")
  .height("48vp")
  .fontSize("16fp")
  .backgroundColor(Color.White)
  .margin({ top: "4vp" })
  .padding({ left: 12 })
}

