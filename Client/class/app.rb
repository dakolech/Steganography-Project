require '../helper/friends_helper'
require '../helper/option_helper'
require_relative 'message'
require_relative 'conversation'
#require_relative 'connection'

class App
    def initialize(messenger, message_box)
        @messenger = messenger
        @message_box = message_box

        @conversations = {}
    end

    def on_login
        #@connection = Connection.new
    end

    def on_send
        message = ''
        @messenger.app do
            message = @message_box.text
            @msg = Message.new(text: message, ip_dest: OptionHelper::get_options[:server_ip])
            @msg.encode

            @messenger.append { inscription @msg.decode } unless message == ''
            @message_box.text = ''
            @messenger.scroll_top = @messenger.scroll_max
        end
        @conversations[@active_friend].add_message :I, message
    end

    def check_new_messages
        message = 'Test metody every(5)'
        @messenger.app do
            @messenger.append { inscription message }
            @messenger.scroll_top = @messenger.scroll_max
        end
        @conversations[@active_friend].add_message :you, message
    end

    def on_logout
        FriendsHelper::save_friends
        OptionHelper::save_options
        exit
    end

    def begin_conversation(friend)
        @conversations[friend] ||= Conversation.new
        @active_friend = friend

        messages = @conversations[@active_friend].messages
        @messenger.app do
            @messenger.clear
            messages.each do |m|
                @messenger.append { inscription m[:text] }
            end
        end
    end

end
