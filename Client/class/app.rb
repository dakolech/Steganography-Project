require '../helper/main_window_helper'
require '../helper/option_helper'
require_relative 'message'

class App
    def initialize(messenger, message_box)
        @messenger = messenger
        @message_box = message_box
    end

    def on_send
        @messenger.app do
            @msg = Message.new(text: @message_box.text, ip_dest: '127.0.0.1')
            @msg.encode

            @messenger.append { inscription @msg.decode } unless @message_box.text == ''
            @message_box.text = ''
            @messenger.scroll_top = @messenger.scroll_max
        end
    end

    def check_new_messages
        @messenger.app do
            @messenger.append { inscription 'Test metody every(5)' }
            @messenger.scroll_top = @messenger.scroll_max
        end
    end

    def on_logout
        MainWindowHelper::save_friends
        OptionHelper::save_options
        exit
    end
end
