class Conversation
    def initialize(user)
        load(user)
    end

    private

        def load(user)
            @messages = {}
            lines = File.readlines('data/conversations')
            lines.each do |l|
                if l[0] != "\t" && l == user
                    active_user = User.find(name: l)
                else

                end
            end
        end
end

c = Conversation.new('asdf')
