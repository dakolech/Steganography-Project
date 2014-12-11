class App
    def initialize
        @counter = 0
    end

    def send
       @counter += 1
       "Counter: #{@counter}"
    end

    def add_new_contact
        puts 'Test add method'
    end

    def logout
        'Test logout method'
    end
end
