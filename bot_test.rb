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
assign_time_hour = 16
assign_time_min = 00
exec_count = 0
application_id = ENV['APPLICATION_ID']

bot.heartbeat do |event|
  # bot.send_message(764701181783572500, "tick")
  now_hour = Time.now.hour
  now_min = Time.now.min

  if assign_time_hour == now_hour && assign_time_min <= now_min && exec_count == 0

    # bot.send_message(764701181783572500,"starting")

    url = "https://api.wotblitz.asia/wotb/tournaments/list/?application_id=#{application_id}&fields=start_at%2Ctitle%2Ctournament_id"
    client = HTTPClient.new
    response = client.get(url)
    results = JSON.parse(response.body)
    qt_count = 0

    # bot.send_message(764701181783572500,"api parsed")
    # if results["data"]
    #   bot.send_message(764701181783572500,"api retrieved")
    # end

    results["data"].each do |result|
      today_unix = Date.today.to_time.to_i
      start_at_date_unix = Time.at(result["start_at"]).to_date.to_time.to_i
      tournament_id = result["tournament_id"]

      # bot.send_message(764701181783572500,"#{today_unix};#{start_at_date_unix};#{tournament_id}")

      if today_unix == start_at_date_unix

        # bot.send_message(764701181783572500,"date match found")

        url = "https://api.wotblitz.asia/wotb/tournaments/stages/?application_id=#{application_id}&tournament_id=#{tournament_id}"
        client = HTTPClient.new
        response = client.get(url)
        result = JSON.parse(response.body)

        if result["meta"]["total"]
          title = result["data"]["title"]
          bot.send_message(764701181783572500, %Q[/poll "#{title}" "19:00" "19:30" "19:55" "未定" "参加不可"])
        elsif qt_count == 0
          bot.send_message(764701181783572500, "?qt8")
          qt_count = 1
        end
      end
    end

    exec_count = 1
    # bot.send_message(764701181783572500,"over")
  end

  if assign_time_hour < now_hour && exec_count == 1
    exec_count = 0
    # bot.send_message(764701181783572500,"exec_count reset")
  end
end
bot.run
