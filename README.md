## メモアプリ

Sinatraで作成したシンプルなメモ管理アプリ

## 必要環境

* Ruby（使用しているバージョン例：3.3.10）
* Bundler

## アプリの起動手順

1. リポジトリをクローン

    ```
    git clone https://github.com/Swarmz/sinatra-memo-app.git
    cd sinatra-memo-app
    git checkout initial-version
    ```

2. 依存関係をインストール

    ```
    bundle install
    ```

3. アプリを起動

    ```
    ruby memo_app.rb
    ```

    または、`rerun` を使用する場合：

    ```
    bundle exec rerun memo_app.rb
    ```

4. ブラウザからアクセス

    ```
    http://localhost:4567
    ```
