# sinatra-notes

`sinatra-notes`は Sinatra を使って作成したメモアプリです。

## Install

1. ご自身の作業 PC の任意ディレクトリで git clone してください。

```
$ git clone https://github.com/Kimmy-2ka/sinatra-notes.git
$ cd sinatra-notes
```

2. 必要な Gem をインストールしてください。

```
$ bundle install
```

## Open app

1. ターミナルからアプリを起動してください。

```
$ bundle exec ruby notes.rb -p 4567
```

2. ブラウザで以下を開いてください。
   
   http://localhost:4567
   (/notes にリダイレクトされます。)

## How to use

- 新規投稿
  - トップページの「新規投稿」ボタンを押し、題名と本文を入力後「保存」ボタンを押します。
- メモを見る
  - トップページに表示されたメモの題名をクリックすると、メモの詳細が表示されます。
- メモを編集する
  - 詳細画面の「編集」ボタンを押すと編集画面に切り替わります。編集後、「保存」ボタンを押します。
- メモを削除する
  - 詳細画面の「削除」ボタンを押すと、該当メモがトップページのメモ一覧から削除されます。

## 仕様

- データは`notes.json`に保存されます。
- メモは`{id:, note_title:, content:, delete:false}`のハッシュ形式で配列に追加されます。
- 削除した際はハッシュは削除されずに、`delete`フラグが`true`になります。
