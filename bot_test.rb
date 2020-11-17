require 'discordrb'
require 'httpclient'
require 'json'
require 'date'
require 'time'

bot = Discordrb::Commands::CommandBot.new(
token: ENV['TOKEN'],
client_id: ENV['CLIENT_ID'],
prefix:'/',
)
assign_time_hour = 12
assign_time_min = 00
exec_count = 0

bot.heartbeat do |event|
  bot.send_message(549143999814959124, "tick")
  now_hour = Time.now.hour
  now_min = Time.now.min

  if assign_time_hour == now_hour && assign_time_min < now_min && exec_count == 0

    bot.send_message(549145858105540609,"starting")

    url = "https://api.wotblitz.asia/wotb/tournaments/list/?application_id=eda85c3d6ddbb56920d3544319a4a788&fields=start_at%2Ctitle%2Ctournament_id"
    client = HTTPClient.new
    response = client.get(url)
    results = JSON.parse(response.body)
    qt_count = 0

    bot.send_message(549145858105540609,"api parsed")
    if results["data"]
      bot.send_message(549145858105540609,"api retrieved")
    end

    results["data"].each do |result|
      today_unix = Date.today.to_time.to_i
      start_at_date_unix = result["start_at"]-72000
      tournament_id = result["tournament_id"]

      bot.send_message(549145858105540609,"#{today_unix};#{start_at_date_unix};#{tournament_id}")

      if today_unix == start_at_date_unix

        bot.send_message(549145858105540609,"date match found")

        url = "https://api.wotblitz.asia/wotb/tournaments/stages/?application_id=eda85c3d6ddbb56920d3544319a4a788&tournament_id=#{tournament_id}"
        client = HTTPClient.new
        response = client.get(url)
        result = JSON.parse(response.body)

        if result["meta"]["total"]
          bot.send_message(549143999814959124, "other")
        elsif qt_count == 0
          bot.send_message(549143999814959124, %Q[/poll "クイック出場可能時間" "20:00" "20:30" "21:00" "Tier8希望" "Tier10希望" "未定" "参加不可"])
          qt_count = 1
        end
      end
    end

    exec_count = 1
    bot.send_message(549145858105540609,"over")
  end

  if assign_time_hour < now_hour && exec_count == 1
    exec_count = 0
    bot.send_message(549145858105540609,"exec_count reset")
  end
end
bot.run
