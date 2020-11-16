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

  url = "https://api.wotblitz.asia/wotb/tournaments/list/?application_id=eda85c3d6ddbb56920d3544319a4a788&fields=start_at%2Ctitle%2Ctournament_id"
  client = HTTPClient.new
  response = client.get(url)
  results = JSON.parse(response.body)

  results["data"].each do |result|
    today_unix = Date.today.to_time.to_i-32400
    start_at_date_unix = result["start_at"]-72000
    tournament_id = result["tournament_id"]

    if today_unix == start_at_date_unix
      qt_count = 0
      url = "https://api.wotblitz.asia/wotb/tournaments/stages/?application_id=eda85c3d6ddbb56920d3544319a4a788&tournament_id=#{tournament_id}"
      client = HTTPClient.new
      response = client.get(url)
      result = JSON.parse(response.body)
      if result["meta"]["total"]
        bot.send_message(549143999814959124, "other", tts = false, embed = nil)
      elsif qt_count == 0
        bot.send_message(549143999814959124, "/poll "クイック出場可能時間" "20:00" "20:30" "21:00" "Tier8希望" "Tier10希望" "未定" "参加不可"", tts = false, embed = nil)
        qt_count = 1
      end
    end
  end
end

bot.run
