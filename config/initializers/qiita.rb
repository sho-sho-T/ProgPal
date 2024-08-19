require 'qiita'

# Qiita APIクライアントの設定
QIITA_CLIENT = Qiita::Client.new(access_token: ENV['QIITA_TOKEN'])

begin
  # 認証されたユーザーの情報を取得(APIが正常に機能しているかを確認するための簡単なテスト)
  user = QIITA_CLIENT.get_authenticated_user

  Rails.logger.info "Qiita API connection successful. Authenticated as: #{user.body["id"]}"
rescue Qiita::AbuseDetectedError, Qiita::ApiError => e
  Rails.logger.error "Failed to initialize Qiita API client: #{e.message}"
end