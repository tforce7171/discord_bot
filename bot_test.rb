require 'discordrb'
require 'httpclient'
require 'json'
require 'date'

bot = Discordrb::Commands::CommandBot.new(
token: ENV['TOKEN'],
client_id: ENV['CLIENT_ID'],
prefix:'/',
)

bot.command :ola do |event|
  url = "https://api.wotblitz.asia/wotb/tournaments/list/?application_id=#{ENV['APPLICATION_ID']}&fields=start_at%2Ctitle%2Ctournament_id"
  client = HTTPClient.new
  # query = {
  #   'application_id' => #{APPLICATION_ID},
  #   'account_id' => '2010886246'
  # }
  response = client.get(url)
  results = JSON.parse(response.body)

  results["data"].each do |result|
    today_unix = Date.today.to_time.to_i
    start_at_date_unix = result["start_at"]-72000
    tournament_id = result["tournament_id"]
    if today_unix == start_at_date_unix
      url = "https://api.wotblitz.asia/wotb/tournaments/stages/?application_id=eda85c3d6ddbb56920d3544319a4a788&tournament_id=#{tournament_id}"
      client = HTTPClient.new
      response = client.get(url)
      result = JSON.parse(response.body)
      if result["meta"]["total"]
        bot.send_message(549143999814959124, "other", tts = false, embed = nil)
      else
        bot.send_message(549143999814959124, "QT", tts = false, embed = nil)
      end
    end
    # start_at_unix = result["start_at"]
    # start_at = Time.at(start_at_unix)
    # title = result["title"]
    # tournament_id = result["tournament_id"]
    # event.send_message("種類：#{title}\n時間：#{start_at}\nID：#{tournament_id}hoge")
  end
  event.send_message("over")
  # if results["data"]
  #   results["data"].each do |result|
  #     start_at_unix = result["start_at"]
  #     start_at = Time.at(start_at_unix)
  #     title = result["title"]
  #     tournament_id = result["tournament_id"]
  #     event.send_message("種類：#{title}\n時間：#{start_at}\nID：#{tournament_id}hoge")
  #   end
  # else
  # event.send_message("something went wrong3")
end

bot.run
