## メモアプリ

Sinatraで作成したシンプルなメモ管理アプリ

## 必要環境

* Ruby（3.4.7）
* Bundler
* PostgreSQL

## セットアップ手順

### 1. リポジトリをクローン

```
git clone https://github.com/Swarmz/sinatra-memo-app.git
cd sinatra-memo-app
```

### 2. 依存関係をインストール

```
bundle install
```

### 3. PostgreSQL のインストールと起動
#### macOS（Homebrew）
```
brew install postgresql
brew services start postgresql
```

#### Linux
```
sudo apt update
sudo apt install postgresql
sudo systemctl start postgresql
```

### 4. データベースユーザーの作成
PostgreSQL には、アプリで使用するユーザー（role）が必要です。
```
sudo -i -u postgres
psql
```
以下を実行して、ユーザーを作成します。
```
CREATE ROLE memo_user WITH LOGIN CREATEDB;
```
終了します。
```
\q
exit
```
### 5. データベースの作成
```
createdb memo_app -U memo_user
```

### 6. 環境変数の設定（任意）
通常のローカル環境では、特別な設定をしなくてもアプリは動作します。  
必要に応じて、以下の環境変数を設定してください。
```
export MEMO_APP_DB_NAME=memo_app
export MEMO_APP_DB_USER=memo_user
# export MEMO_APP_DB_PASSWORD=your_password
```
※ MEMO_APP_DB_PASSWORD は、
PostgreSQL がパスワード認証を要求する場合のみ設定してください。  
設定しない場合は、デフォルト値が使用されます。

### 7. アプリの起動
```
ruby memo_app.rb
```

### 8. ブラウザからアクセス
```
http://localhost:4567
```
