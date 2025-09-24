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

## Set up database

1. PostgreSQLにログインし、ユーザとデータベースを作成してください。
   - ユーザ名とデータベース名はデフォルトで設定してありますが、変更可能です。

```
$ CREATE USER note_app_owner WITH PASSWORD 'my_password';
$ CREATE DATABASE note_app OWNER note_app_owner;
$ \c note_app note_app_owner
```
2. テーブルを作成してください。
```
$ CREATE TABLE notes (
    id  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title  TEXT,
    content  TEXT
  );
```

## Prepare for connecting to database

1. `example.env`をコピーして`.env`ファイルを作成し、データベース設定を行ってください。
```
HOST=localhost
DBNAME=note_app
DBUSER=note_app_owner
PASSWORD=my_password
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

## Specifications

- データはPostgreSQLの`notes`テーブルに保存されます。
- テーブルは以下の構造です。
   - `id`: 自動採番される整数のプライマリーキー(INTEGER)
   - `title`:メモのタイトル(TEXT)
   - `content`:メモの本文(TEXT)
- メモを削除した場合、物理的に削除されます。
