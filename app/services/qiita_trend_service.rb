class QiitaTrendService
  def self.fetch_trends(per_page: 5)
    QIITA_CLIENT.list_items(params: { query: 'stocks:>20', per_page: })
  rescue Qiita::AbuseDetectedError, Qiita::ApiError => e
    Rails.logger.error "Failed to fetch trend articles: #{e.message}"
    []
  end

  def self.format_trends(items)
    items.map do |item|
      {
        title: item.title,
        url: item.url,
        user: item.user.id,
        likes: item.likes_count
      }
    end
  end
end
