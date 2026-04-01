import router from '@ohos.router';
import { registerCallBack } from '../common/class';
import { SendReqPost } from '../common/utils';

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
          // Title component
          LoginTitle()
          // Bottom component
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
      Text("注册")
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
  @State surePassword: string = '';
  @State text: string = '';

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
        TextInput({ placeholder: "请确认密码" })
          .maxLength(8)
          .type(InputType.Password)
          .inputStyle()
          .onChange((value: string) => {
            this.surePassword = value;
          })
      }
      .backgroundColor(Color.White)
      .borderRadius("24vp")

      Text(this.text)
        .fontColor("#ffff112c")
        .fontSize("12fp")
        .fontWeight(FontWeight.Medium)
        .margin({ top: "24vp" })

      Text("已有账号？点击前往登录")
        .fontColor("#007DFF")
        .fontSize("14fp")
        .fontWeight(FontWeight.Medium)
        .margin({ top: "24vp" })
        .onClick(() => {
          router.replaceUrl({
            url: 'pages/login'
          })
        })

      Button("注册")
        .id("registerButtonId")
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
          if (this.password !== this.surePassword) {
            this.text = "两次密码不一致！"
          } else {
            this.text = ""

            SendReqPost("users/register",'', new Object({
              username: this.account,
              password: this.password
            }), (data: registerCallBack) => {
              const obj = data as registerCallBack
              if (obj.error) {
                console.log(obj.error)
                this.text = obj.error
              } else if (obj.message == "注册成功") {
                router.replaceUrl({
                  url: 'pages/login'
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

