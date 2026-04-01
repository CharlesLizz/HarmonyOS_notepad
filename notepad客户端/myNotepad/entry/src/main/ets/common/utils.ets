import http from '@ohos.net.http'
import PreferenceModel from '../common/preferences'

const host = '10.0.2.2:8082/api/'


function SendReqGet(path: string, token?: string, callBack?: Function) {
  const httpRequest = http.createHttp()
  httpRequest.request(host + path, {
    method: http.RequestMethod.GET,
    expectDataType: http.HttpDataType.OBJECT,
    header: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    }
  }, (err, data) => {
    if (err) {
      console.log('SendReqGet err: ' + err.message)
      return
    }
    let msg = data.result
    console.log('SendReqGet data: ' + msg)
    if (callBack) {
      callBack(msg)
      console.info('token ' + PreferenceModel.testToken)
    }
  })
}

function SendReqPost(path: string, token?: string, extraData?: string | Object | ArrayBuffer, callBack?: Function) {
  const httpRequest = http.createHttp()
  httpRequest.request(host + path, {
    method: http.RequestMethod.POST,
    extraData: extraData,
    expectDataType: http.HttpDataType.OBJECT,
    header: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    }
  }, (err, data) => {
    if (err) {
      console.log('SendReqPost err: ' + err.message)
      return
    }
    let msg = data.result
    console.log('SendReqPost data: ' + msg)
    if (callBack) {
      callBack(msg)
      // console.info('token ' + PreferenceModel.testToken)
    }
  })
}

function SendReqPut(path: string, token?: string, extraData?: string | Object | ArrayBuffer, callBack?: Function) {
  const httpRequest = http.createHttp()
  httpRequest.request(host + path, {
    method: http.RequestMethod.PUT,
    extraData: extraData,
    expectDataType: http.HttpDataType.OBJECT,
    header: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    }
  }, (err, data) => {
    if (err) {
      console.log('SendReqPut err: ' + err.message)
      return
    }
    let msg = data.result
    console.log('SendReqPut data: ' + msg)
    if (callBack) {
      callBack(msg)
      console.info('token ' + PreferenceModel.testToken)
    }
  })
}

function SendReqDelete(path: string, token?: string, callBack?: Function) {
  const httpRequest = http.createHttp()
  httpRequest.request(host + path, {
    method: http.RequestMethod.DELETE,
    expectDataType: http.HttpDataType.OBJECT,
    header: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    }
  }, (err, data) => {
    if (err) {
      console.log('SendReqDelete err: ' + err.message)
      return
    }
    let msg = data.result
    console.log('SendReqDelete data: ' + msg)
    if (callBack) {
      callBack(msg)
      console.info('token ' + PreferenceModel.testToken)
    }
  })
}

export { SendReqGet, SendReqPost, SendReqPut, SendReqDelete }