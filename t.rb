require 'twitter'

TW_CONSUMER_KEY        = " your consumer key "
TW_CONSUMER_SECRET     = " your consumer secret "
TW_ACCESS_TOKEN        = " your access token "
TW_ACCESS_TOKEN_SECRET = " your access token secret "

# login
client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = TW_CONSUMER_KEY
  config.consumer_secret     = TW_CONSUMER_SECRET
  config.access_token        = TW_ACCESS_TOKEN
  config.access_token_secret = TW_ACCESS_TOKEN_SECRET
end

client.user do |object|
  case object
  when Twitter::Tweet
    puts 'ぽすとがあったやで'
  end
end
