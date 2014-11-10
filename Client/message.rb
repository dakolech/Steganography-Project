require 'oily_png'

class Message
    attr_accessor :text, :ip_dest

    def initialize(properties = {})
        filename = properties[:filename] || 'images/cat_small.png'

        @image = ChunkyPNG::Image.from_file(filename)
        @text  = properties[:text] || 'Some default text'
        @ip_dest = properties[:ip_dest]  || '127.0.0.1'

        @occupied_pixels = Set.new
    end

    def encode
        Random.srand 1410
        @text.each_char.with_index do |char, index|
            x, y = find_next_pixel
            encode_letter(x, y, char)
        end
        @occupied_pixels.clear
    end

    def decode
        str = ''
        Random.srand 1410
        @text.length.times do
            x, y = find_next_pixel
            str += decode_letter(x, y)
        end
        return str
    end

    def save
        @image.save('images/changed.png')
    end

    private

        def find_next_pixel
            x = y = 0
            loop do
                x = Random.rand(@image.width)
                y = Random.rand(@image.height)
                break if (x + y >= 5 &&
                          x + y <= @image.width + @image.height - 5 &&
                          !@occupied_pixels.include?([x, y]))
            end
            @occupied_pixels.add([x, y])
            return x, y
        end

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

msg = Message.new(text: 'To jednak byl zamach', ip_dest: '127.0.0.1', filename: 'images/cat_small.png')
msg.encode
puts msg.decode
