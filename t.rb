require 'bundler'
require 'yaml'
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
reply_words = YAML.load_file('./reply.yaml')
w1l = reply_words['w1'].length

def get_rep_text(words)
  l1 = words['w1'].length
  l2 = words['w2'].length
  words['w1'][rand l1] + words['w2'][rand l2]
end

Twitter::Streaming::Client.new(config).user do |object|
  case object
  when Twitter::Streaming::Event
    # イベントひろう
    p object
    # フォロー返す
    client.follow!(object.source.id) if object.name == :follow && object.source.id != client.user(SCREEN_NAME).id
  when Twitter::Tweet
    p object.attrs
    client.update("@#{object.user.screen_name} #{get_rep_text(reply_words)}", in_reply_to_status_id: object.id) if object.text.include?("しんどい") && !object.text.include?("RT")
    client.favorite!(object) if object.in_reply_to_screen_name == SCREEN_NAME
  end
end
