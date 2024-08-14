class LineBotController < ApplicationController
  protect_from_forgery except: [ :callback ]

  def callback
    body = request.body.read
    signature = request.env["HTTP_X_LINE_SIGNATURE"]
    unless client.validate_signature(body, signature)
      head :bad_request
      nil
    end

    events = client.parse_events_from(body)

    events.each do |event|
     line_bot_service.handle_event(event)
    end
  end

  private

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    end
  end

  def line_bot_service
    @line_bot_service ||= LineBotService.new(client)
  end
end
