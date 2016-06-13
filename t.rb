require 'bundler'
Bundler.require
Dotenv.load

SCREEN_NAME = 'ktlbl_bot'.freeze

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
  when Twitter::Streaming::Event
    # イベントひろう
    p object
    # フォロー返す
    client.follow!(object.source.id) if object.name == :follow && object.source.id != client.user(SCREEN_NAME).id
  when Twitter::Tweet
    p object.attrs
    client.update("@#{object.user.screen_name} 大丈夫？鉄塊揉む？", in_reply_to_status_id: object.id) if object.text.include?("しんどい")
    client.favorite!(object) if object.in_reply_to_screen_name == SCREEN_NAME
  end
end
