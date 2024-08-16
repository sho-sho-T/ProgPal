class ReplyService
  def initialize(message)
    @message = message
  end

  # 今後拡張予定
  def generate_reply
    case @message
    when /こんにちは/
      'こんにちは！お元気ですか？'
    when /こんばんは/
      'こんばんは！夜ご飯は食べましたか？'
    else
      '申し訳ありません。よく分かりませんでした。'
    end
  end
end
