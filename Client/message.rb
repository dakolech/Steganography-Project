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
        i = 0
        @text.each_byte do |byte|
            @image[0, i] = @image[0, i] & 0xFFFF00FF
            i += 1
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

a = [[0, 1], [2, 3]]
a.each_index { |i| puts "a[#{i}] = #{a[i]}" }

#image[0, 0] = ChunkyPNG::Color.rgba(255, 0, 0, 128)
#image.line(1, 1, 10, 1, ChunkyPNG::Color.from_hex('#aa007f'))
#image.save('images/cat_big_changed.png')
