require_relative "line/reply_service"
require_relative "line/message_presenter"

class LineBotService
  def initialize(client)
    @client = client
  end

  def handle_event(event)
    case event
    when Line::Bot::Event::Message
      handle_message(event)
    end
  end

  private

  def handle_message(event)
    message = event.message["text"]
    reply = ReplyService.new(message).generate_reply
    response = MessagePresenter.format_text_message(reply)
    @client.reply_message(event["replyToken"], response)
  end
end
