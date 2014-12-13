class ImageTooSmall < StandardError
    attr_reader :message
    def initialize
        @message = 'You have to choose larger image to encrypt message'
    end
end

class AddNewContactError < StandardError
end

class InvalidID < AddNewContactError
    attr_reader :message
    def initialize
        @message = 'Given ID is not a number'
    end
end

class DuplicateName < AddNewContactError
    attr_reader :message
    def initialize
        @message = 'Duplicate friend name'
    end
end
