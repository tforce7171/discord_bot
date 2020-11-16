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

  event.send_message("starting")

  url = "https://api.wotblitz.asia/wotb/tournaments/list/?application_id=eda85c3d6ddbb56920d3544319a4a788&fields=start_at%2Ctitle%2Ctournament_id"
  client = HTTPClient.new
  response = client.get(url)
  results = JSON.parse(response.body)

  event.send_message("api parsed")
  if resulta["data"]
    event.send_message("api retrieved")
  end
  
  results["data"].each do |result|
    today_unix = Date.today.to_time.to_i
    start_at_date_unix = result["start_at"]-72000
    tournament_id = result["tournament_id"]
    if today_unix == start_at_date_unix
      event.send_message("date match found")
      url = "https://api.wotblitz.asia/wotb/tournaments/stages/?application_id=eda85c3d6ddbb56920d3544319a4a788&tournament_id=#{tournament_id}"
      client = HTTPClient.new
      response = client.get(url)
      result = JSON.parse(response.body)
      if result["meta"]["total"]
        event.send_message(549143999814959124, "other", tts = false, embed = nil)
      else
        event.send_message(549143999814959124, "QT", tts = false, embed = nil)
      end
    end
  end
  event.send_message("#{today_unix}")
end

bot.run
