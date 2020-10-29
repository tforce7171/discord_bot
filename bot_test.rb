require 'discordrb'

bot = Discordrb::Commands::CommandBot.new(
token: 'NzcwNjU0NDU2MjMxNDkzNjMz.X5gt5A.eYp3BqIu-vfVcOPk7isxhphEnC4',
client_id:770654456231493633,
prefix:'/',
)

bot.command :hello do |event|
 event.send_message("hallo,world.#{event.user.name}")
end

bot.run
