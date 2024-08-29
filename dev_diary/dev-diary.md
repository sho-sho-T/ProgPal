# 開発日記

## 2024-8-18

### 初めてちゃんと Rails の initializers ディレクトリについて知った。

#### 学んだこと

アプリケーションの起動時に実行される初期化コードを格納する場所として特別な意味を持ってるらしい。

initializers の使用例は以下のような感じ

- データベース接続
- ログフォーマット
- 外部 API クライアントの設定（今回の Qiita クライアント設定がそれ）
- アプリケーション全体で使用する定数の定義
- ミドルウェアの設定

Qiita API の設定ファイルを `config/initializers` に置くことで、アプリケーションの起動時に確実に設定ができて、アプリケーション全体で一貫した API クライアントの使用が可能

---

## 2024-8-21

### TDD（テスト駆動開発）でアプリ作ってみようと試みる

#### 学んだこと

TDD のアプローチは以下のような感じ

- 先にテストを書く：新機能を実装する前に、その機能のテストを書く。
- テストを失敗させる：新しいテストは最初は失敗するはず。
- 最小限の実装：テストが通る最小限のコードを書く。
- テストを通す：実装したコードでテストが通ることを確認。
- リファクタリング：コードの品質を改善しつつ、テストが通り続けることを確認。

一旦これに沿って開発進めてみる。
まず、`qiita_trend_service.rb`の spec を書くことから始める。

---

### QiitaTrendService の RSpec 書くよ

#### TDD とは

TDD のアプローチは以下のような感じ

- 先にテストを書く：新機能を実装する前に、その機能のテストを書く。
- テストを失敗させる：新しいテストは最初は失敗するはず。
- 最小限の実装：テストが通る最小限のコードを書く。
- テストを通す：実装したコードでテストが通ることを確認。
- リファクタリング：コードの品質を改善しつつ、テストが通り続けることを確認。

一旦これに沿って開発進めてみる。
まず、`qiita_trend_service.rb`の spec を書くことから始める。

---

## 2024-8-28

別のことやっててめっちゃ時間空いてる

### faraday、faraday-middleware で HTTP 通信をしてみた。

#### faraday

HTTP クライアントライブラリで以下の特徴がある。

- シンプルで柔軟
- 様々な HTTP アダプタ
- ミドルウェアの概念を使用して、リクエスト、レスポンスをカスタマイズ

#### faraday-middleware

Faraday のための追加ミドルウェアを提供する。

- JSON や XML の自動パース
- OAuth 認証（安全にサードパーティーアプリケーションにユーザーの情報へのアクセス権を与えるための標準的な認証プロトコル）
- キャッシング
- リトライ処理

```ruby

# 使用例
    def connection
      @connection ||= Faraday.new(url: BASE_URL) do |faraday|
        faraday.headers['Authorization'] = "Bearer #{ENV['QIITA_TOKEN']}"
        faraday.headers['Content-Type'] = 'application/json'
        faraday.use FaradayMiddleware::FollowRedirects, limit: 3
        faraday.adapter Faraday.default_adapter
      end
    end
```

---
