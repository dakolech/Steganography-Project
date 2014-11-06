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
            magic = (byte << 24) & 0xE0FFFFFF
            magic = magic | ((byte << 16) & 0xFF18FFFF)
            magic = magic | ((byte <<  8) & 0xFFFF03FF)
            @image[0, i] &= 0xF8FCF8FF
            @image[0, i] |= magic
            i += 1
        end
        #0.upto(@image.width - 1) do |i|
        #    0.upto(@image.height - 1) do |j|
        #        @image[i, j] &= 0xF8FCF8FF
        #    end
        #end
    end

    def decode
        result = ''
        @text.length.times do |n|

        end
    end

    def save
        @image.save('images/changed.png')
    end
end

msg = Message.new(text: 'Some random text', ip_dest: '127.0.0.1', filename: 'images/cat_small.png')
msg.encode
msg.save

#image[0, 0] = ChunkyPNG::Color.rgba(255, 0, 0, 128)
#image.line(1, 1, 10, 1, ChunkyPNG::Color.from_hex('#aa007f'))
#image.save('images/cat_big_changed.png')
