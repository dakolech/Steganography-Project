require 'oily_png'

class Message
    attr_accessor :text, :ip_dest

    def initialize(properties = {})
        filename = properties[:filename] || 'images/cat_small.png'

        @image = ChunkyPNG::Image.from_file(filename)
        @text  = properties[:text] || 'Some default text' 
        @ip_dest = properties[:ip_dest]  || '127.0.0.1'
    end

    def encode
        for i in (0..@image.width - 1)
            for j in (0..@image.height - 1)
                @image[i, j] &= 0xF8FCF8FF
            end
        end
    end

    def save
        @image.save('images/changed.png')
    end
end

msg = Message.new(text: 'Some random text', ip_dest: '127.0.0.1', filename: 'images/cat_small.png')
msg.encode
msg.save

puts msg.text
puts msg.ip_dest

#image[0, 0] = ChunkyPNG::Color.rgba(255, 0, 0, 128)
#image.line(1, 1, 10, 1, ChunkyPNG::Color.from_hex('#aa007f'))
#image.save('images/cat_big_changed.png')
