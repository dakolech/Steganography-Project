class App
    def initialize(messenger, message_box)
        @messenger = messenger
        @message_box = message_box
    end

    def on_send
        @messenger.app do
            @messenger.append { inscription @message_box.text } unless @message_box.text == ''
            @message_box.text = ''
            @messenger.scroll_top = @messenger.scroll_max
        end
    end

    def check_new_messages
        @messenger.app do
            @messenger.append { para 'Test metody every(5)' }
            @messenger.scroll_top = @messenger.scroll_max
        end
    end

    def on_logout
        exit
    end
end
