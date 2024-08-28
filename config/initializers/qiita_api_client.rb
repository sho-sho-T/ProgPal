require 'faraday'
require 'faraday_middleware'
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
        faraday.headers['Authorization'] = "Bearer #{ENV['QIITA_TOKEN']}"
        faraday.headers['Content-Type'] = 'application/json'
        faraday.use FaradayMiddleware::FollowRedirects, limit: 3
        faraday.adapter Faraday.default_adapter
      end
    end

    def handle_response(response)
      case response.status
      when 200..299
        JSON.parse(response.body)
      when 401
        raise ApiError.new("Unauthorized: Check your access token")
      when 403
        raise ApiError.new("Forbidden: You don't have permission to access this resource")
      when 404
        raise ApiError.new("Not Found: The requested resource does not exist")
      when 429
        raise ApiError.new("Too Many Requests: You have exceeded the API rate limit")
      else
        raise ApiError.new("API request failed with status #{response.status}: #{response.body}")
      end
    end
  end

  class ApiError < StandardError; end
end

# 接続テスト
begin
  user = QiitaApiClient.get('authenticated_user')
  Rails.logger.info "Qiita API connection successful. Authenticated as: #{user['id']}"
rescue QiitaApiClient::ApiError => e
  Rails.logger.error "Failed to initialize Qiita API client: #{e.message}"
end