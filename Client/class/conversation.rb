class Conversation
    attr_reader :messages

    def initialize
        @messages = []
    end

    def add_message(fromWhom, message)
       @messages << { who: fromWhom, text: message }
    end
end
