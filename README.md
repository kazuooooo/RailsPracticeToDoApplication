# RailsPracticeToDoApplication
### 登録
* emailaddressとpassを設定してUserの登録を行う

### ログイン
* email(とpassword)でログイン出来る
  * emailにはemailの形になっているかバリデーションをつける
* facebookでログイン出来る
* ログインに失敗した場合は再度同じ画面にリダイレクトさせる

### ユーザごとにTODOを管理
* TODOの内容
  * タイトル(String) : nullはエラー
  * 詳細(String) :nullはエラー
  * いつまでに終わらせるか(Date) 
  * いつ終わったか(Date)
* 一覧
  * ログアウトボタンを付けてログアウト出来るようにする
* 詳細
  * 編集ボタンと削除ボタン
* 作成
  * 作成に失敗した場合はリダイレクト
* 編集
  * 編集に失敗した場合はリダイレクト
* 削除
  * 確認ダイアログを表示

### その他
* Bootstrapを入れていい感じにしたい

