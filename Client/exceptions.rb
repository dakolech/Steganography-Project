class ImageTooSmall < StandardError
    attr_reader :message
    def initialize
        @message = 'You have to choose larger image to encrypt message'
    end
end
