require 'discordrb'
require 'httpclient'
require 'json'

bot = Discordrb::Commands::CommandBot.new(
token: ENV['TOKEN'],
client_id: ENV['CLIENT_ID'],
prefix:'/',
)

bot.command :ola do |event|
  url = "https://api.wotblitz.asia/wotb/account/achievements"
  client = HTTPClient.new
  query = {
    'application_id' => ENV['APPLICATION_ID'],
    'account_id' => '2010886246'
  }
  response = client.get(url, query)
  result = JSON.parse(response.body)

  if result["data"]
    medalHalonen = result["data"]["2010886246"]["achievements"]["medalHalonen"]
  end
  event.send_message("#{medalHalonen}")
end

bot.run
