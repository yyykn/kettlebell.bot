require 'bundler'
Bundler.require
Dotenv.load

puts 'begin'

config = {
  consumer_key:         ENV['TW_CONSUMER_KEY'],
  consumer_secret:      ENV['TW_CONSUMER_SECRET'],
  access_token:         ENV['TW_ACCESS_TOKEN'],
  access_token_secret:  ENV['TW_ACCESS_TOKEN_SECRET'],
}

client = Twitter::REST::Client.new(config)

Twitter::Streaming::Client.new(config).user do |object|
  case object
  when Twitter::Tweet
    p object.attrs
    client.update("@#{object.user.screen_name} 大丈夫？ターキッシュゲットアップしとく？", in_reply_to_status_id: object.id) if object.text.include?("つらい")
  end
end
