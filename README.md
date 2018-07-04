# Utility CameraModule
***

## 概要
***

- __アプリ内カメラ機能__

1. カメラ画面のレイアウトをカスタマイズできるよう、外部のカメラアプリを使用せずに自アプリ内でキャプチャを撮影する

1. カメラ機能を使用してViewに表示

1. 仮設置したボタンを押下で撮影

1. 撮影データはUIImageで返却

## 環境
***
- Xcode 9.2+
- Swift 4+
- iOS 11+

## 使用方法
***

- このmoduleをimportする。
~~~Swift
import CameraModule
~~~

- CameraModuleクラスのインスタンスを生成してください。initializerは無しです。

- viewToCaptureVideo(カメラの映像描写先),viewToDraw(写真の描写先)を設定する
UIViewをこのプロパティーに渡せば大丈夫です。

- setupDrawCaptureVideo()をするとviewToCaptureVideoのUIView上にカメラの映像が描写されます。
~~~Swift
setupDrawCaptureVideo()
~~~

- takePhotoメソッドでカメラ撮影ができます。

- 撮影後の写真の情報を取得に関する編集がしたいときはCameraModulePhotoCaptureDelegateのDrawPhotoCaptureメソッドを使ってください。第一引数は撮影した写真のデータ(JPEG),第二引数にviewToDrawプロパティーです。
~~~Swift
func DrawPhotoCapture(_ data: Data, _ viewToDraw: UIView) {
  let image = UIImage(data: data)
  let imageView = UIImageView(image: image)
  imageView.frame = viewToDraw.frame
  viewToDraw.addSubview(imageView)
}
~~~

- またUIViewクラスにGetImage()を定義しています。このメソッドは使用したUIView上のlayer上の情報をキャプチャーしてそのデータを画像データにしてUIImageとして返します。
しかし、このメソッドをつかってtakePhotoメソッドの代わりとしてしようするとうまくいきません。多分drawCaptureVideoメソッドと連携がうまく行っていないか、AVFoundationの仕様上仕方ないのか。。。

## 注意点
***

- 細かい設定を行いたい場合はAVFoundationを使ったほうが早いです。これは簡易的なライブラリーです。

- Sumilatorには対応していません。クラッシュはしないですがカメラの表示はされません・
