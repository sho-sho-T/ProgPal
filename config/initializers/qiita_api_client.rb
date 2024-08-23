require 'faraday'
require 'json'

module QiitaApiClient
  class << self
    BASE_URL = 'https://qiita.com/api/v2'

    def get(path, params = {})
      response = connection.get(path, params)
      handle_response(response)
    end

    def post(path, body = {})
      response = connection.post(path, body.to_json)
      handle_response(response)
    end

    private

    def connection
      @connection ||= Faraday.new(url: BASE_URL) do |faraday|
        faraday.headers['Authorization'] = "Bearer #{ENV['QIITA_ACCESS_TOKEN']}"
        faraday.headers['Content-Type'] = 'application/json'
        faraday.adapter Faraday.default_adapter
      end
    end

    def handle_response(response)
      if response.success?
        JSON.parse(response.body)
      else
        raise ApiError.new("API request failed with status #{response.status}: #{response.body}")
      end
    end
  end

  class ApiError < StandardError; end
end

# 接続テスト
begin
  user = QiitaApiClient.get('/authenticated_user')
  Rails.logger.info "Qiita API connection successful. Authenticated as: #{user['id']}"
rescue QiitaApiClient::ApiError => e
  Rails.logger.error "Failed to initialize Qiita API client: #{e.message}"
end