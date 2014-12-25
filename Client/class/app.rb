require '../helper/friends_helper'
require '../helper/option_helper'
require_relative 'message'
require_relative 'conversation'
require_relative 'connection'

class App
    def initialize
        @conversations = {}
        @unreaded_messages = Set.new
    end

    def set_message_stuff(messenger, message_box)
        @messenger = messenger
        @message_box = message_box
    end

    def on_login(id, pass, login_status_stack)
        login_status_stack.app do
            login_status_stack.show
            login_status_stack.append { inscription 'Logging...' }
        end

        login_error = lambda do |message|
            login_status_stack.app do
                login_status_stack.clear do
                    inscription message, stroke: red
                end
            end
            false
        end

        begin
            @connection = Connection.new(OptionHelper::get_options[:server_ip].join('.'), 1234)
            @connection.log_in(id, pass)
        rescue ConnectionError => ce
            login_error.call ce.message
        rescue
            login_error.call "Server is unreacheable:\nDid you start it?"
        end
    end

    def on_send
        message = ''
        @messenger.app do
            message = @message_box.text
            status = @connection.send_message_to_server(message, FriendsHelper::get_friends[@active_friend])
            puts "Status wysylania wiadomosci " + status

            @messenger.append { inscription message }
            @message_box.text = ''
            @messenger.scroll_top = @messenger.scroll_max
        end
        @conversations[@active_friend].add_message :I, message
    end

    def check_new_messages
        new_messages = @connection.download_messages_from_server
        unless new_messages.nil?
            add_new_messages_to_conversation new_messages
            return true
        end
        false
    end

    def on_logout
        @connection.close unless @connection.nil?
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

    def have_unreaded(friend)
        @unreaded_messages.include?(friend)
    end

    private

        def add_new_messages_to_conversation(messages)
            friends = FriendsHelper::get_friends
            messages.each do |m|
                friend_name = friends.key(m[:from])
                @conversations[friend_name].add_message(:you, m[:text])
                @unreaded_messages << friend_name

                if friend_name == @active_friend
                    @messenger.app do
                        @messenger.append { inscription m[:text] }
                        @messenger.scroll_top = @messenger.scroll_max
                    end
                end
            end
        end

end
