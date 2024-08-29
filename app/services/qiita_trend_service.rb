class QiitaTrendService
  PER_PAGE = 5

  def self.fetch_trends
    items = QiitaApiClient.get('items', query: 'stocks:>20', per_page: PER_PAGE)
    format_trends(items)
  rescue QiitaApiClient::ApiError => e
    Rails.logger.error "Failed to fetch Qiita trend articles: #{e.message}"
    []
  end

  def self.format_trends(items)
    items.map do |item|
      {
        title: item['title'],
        url: item['url'],
        user: item['user']['id'], # 'user'は複雑なオブジェクトなので、'id'だけを取得
        likes: item['likes_count']
      }
    end
  end
end
