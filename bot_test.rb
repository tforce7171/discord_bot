require 'discordrb'

bot = Discordrb::Commands::CommandBot.new(
token: ENV['TOKEN'],
client_id: ENV['CLIENT_ID'],
prefix:'/',
)

bot.command :ola do |event|
 event.send_message("hallo,world.#{event.user.name}")
end

bot.run
