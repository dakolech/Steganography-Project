require 'oily_png'

class Message
    attr_accessor :text, :ip_dest

    def initialize(properties = {})
        filename = properties[:filename] || 'images/cat_small.png'

        @image = ChunkyPNG::Image.from_file(filename)
        @text  = properties[:text] || 'Some default text'
        @ip_dest = properties[:ip_dest]  || '127.0.0.1'
    end

    def save
        @image.save('images/changed.png')
    end

    private

        def encode_letter(x, y, letter)
            byte = letter.bytes.first
            magic  = (byte & 0xE0) << 19
            magic |= (byte & 0x18) << 13
            magic |= (byte & 0x07) << 8
            @image[x, y] &= 0xF8FCF8FF
            @image[x, y] |= magic
        end

        def decode_letter(x, y)
            red   = (@image[x, y] & 0x07000000) >> 19
            green = (@image[x, y] & 0x00030000) >> 13
            blue  = (@image[x, y] & 0x00000700) >> 8
            (red | green | blue).chr
        end
end

msg = Message.new(text: 'Some random text', ip_dest: '127.0.0.1', filename: 'images/cat_small.png')
msg.encode_letter(0, 0, 'A')
puts msg.decode_letter(0, 0)
msg.save
