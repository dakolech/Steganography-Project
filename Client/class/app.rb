require '../helper/friends_helper'
require '../helper/option_helper'
require_relative 'message'
require_relative 'conversation'

class App
    def initialize(messenger, message_box)
        @messenger = messenger
        @message_box = message_box

        @conversations = {}
    end

    def on_send
        @messenger.app do
            @msg = Message.new(text: @message_box.text, ip_dest: '127.0.0.1')
            @msg.encode
            @conversations[@active_friend].add_message :I, @message_box.text

            @messenger.append { inscription @msg.decode } unless @message_box.text == ''
            @message_box.text = ''
            @messenger.scroll_top = @messenger.scroll_max
        end
    end

    def check_new_messages
        message = 'Test metody every(5)'
        @messenger.app do
            @messenger.append { inscription message }
            @messenger.scroll_top = @messenger.scroll_max
            @conversations[@active_friend].add_message :you, message
        end
    end

    def on_logout
        p @conversations

        FriendsHelper::save_friends
        OptionHelper::save_options
        exit
    end

    def begin_conversation(friend)
        @conversations[friend] ||= Conversation.new
        @active_friend = friend

        messages = @conversations[@active_friend].messages
        p messages

        @messenger.app do
            @messenger.clear

            messages.each do |m|
                @messenger.append { inscription 'Success' }
            end
        end
    end

end
