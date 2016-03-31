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
    on /^\/start/ do
      answer_with_greeting_message
    end

    on /^\/stop/ do
      answer_with_farewell_message
    end
  end

  private

  def on regex, &block
    regex =~ message.text

    if $~
      case block.arity
      when 0
        yield
      when 1
        yield $1
      when 2
        yield $1, $2
      end
    end

  end

  def answer_with_greeting_message
    text = I18n.t('greeting_message')

    MessageSender.new(bot: bot, chat: message.chat, text: text).send
  end

  def answer_with_farewell_message
    text = I18n.t('farewell_message')

    MessageSender.new(bot: bot, chat: message.chat, text: text).send
  end
end
