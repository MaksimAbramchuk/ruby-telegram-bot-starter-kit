require './models/user'
require './lib/message_sender'

class MessageResponder
  attr_reader :message
  attr_reader :bot
  attr_reader :user

  def initialize(options)
    @bot = options[:bot]
    @message = options[:message]
    @user = User.find_or_create_by(uid: message.from.id)
  end

  def respond
    case message.text
    when '/start'
      answer_with_greeting_message
    when '/stop'
      answer_with_farewell_message
    end
  end

  private

  def answer_with_greeting_message
    text = I18n.t('greeting_message')

    MessageSender.new(bot: bot, chat: message.chat, text: text).send
  end

  def answer_with_farewell_message
    text = I18n.t('farewell_message')

    MessageSender.new(bot: bot, chat: message.chat, text: text).send
  end
end
