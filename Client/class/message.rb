# -*- coding: utf-8 -*-
require 'oily_png'
require_relative 'exceptions'

class Message
    attr_accessor :image

    def initialize(properties = {})
        filename = properties[:filename] || '../images/cat_small.png'

        @text  = properties[:text]  || 'Some default text'
        @image = ChunkyPNG::Image.from_file(filename)
        raise ImageTooSmall.new unless @image.width*@image.height > Image::TIMES_LARGER*@text.length

        @sender = properties[:sender] || ''
        @occupied_pixels = Set.new
    end

    def encode
        @key = Random.srand.to_s.slice(0..8).to_i
        encode_key
        encode_sender
        encode_timestamp

        Random.srand @key
        @text.each_char.with_index do |char, index|
            x, y = find_next_pixel
            encode_letter(x, y, char)
        end
        x, y = find_next_pixel
        encode_letter(x, y, "\0")
        @occupied_pixels.clear
    end

    def decode
        @key = decode_key.to_i
        Random.srand @key

        str = ''
        loop do
            x, y = find_next_pixel
            letter = decode_letter(x, y)
            break if letter == "\0"
            str += letter
        end
        return str
    end

    def from?
        decode_sender
    end

    def timestamp
        decode_timestamp
    end

    def save
        @image.save('../images/to_send/to_send.png')
    end

    private
        module Image
            TIMES_LARGER = 50
            FREE_PIXELS = 5
            TIMESTAMP_FIELDS = [[ 3,  0], [ 4,  0], [ 3,  1], [ 0,  3], [ 1,  3], [ 0,  4],
                                [-1, -5], [-2, -4], [-1, -4], [-3, -3], [-2, -3], [-1, -3], [-4, -2]]
        end

        def find_next_pixel
            x = y = 0
            loop do
                x = Random.rand(@image.width)
                y = Random.rand(@image.height)
                break if (x + y >= Image::FREE_PIXELS &&
                          x + y <= @image.width + @image.height - Image::FREE_PIXELS &&
                          !@occupied_pixels.include?([x, y]))
            end
            @occupied_pixels.add([x, y])
            return x, y
        end

        def encode_key
            @key.to_s.each_char.with_index do |char, i|
                encode_letter(i/3, i%3, char)
            end
        end

        def decode_key
            str = ''
            (0..2).each do |i|
                (0..2).each do |j|
                    str += decode_letter(i, j)
                end
            end
            return str
        end

        def encode_sender
            @sender.each_char.with_index do |char, i|
                encode_letter(@image.width - i%2 - 1, @image.height - i/2 - 1, char)
            end
        end

        def decode_sender
            str = ''
            (0..1).each do |i|
                (0..1).each do |j|
                    str += decode_letter(@image.width - j - 1, @image.height - i - 1)
                end
            end
            return str
        end

        def encode_timestamp
            timestamp = Time.now.to_f.to_s.sub('.', '')[0..12]
            timestamp.each_char.with_index do |char, i|
                field_x, field_y = get_image_field(Image::TIMESTAMP_FIELDS[i])
                encode_letter(field_x, field_y, char)
            end
        end

        def decode_timestamp
            str = ''
            Image::TIMESTAMP_FIELDS.each do |coord|
                field_x, field_y = get_image_field(coord)
                str += decode_letter(field_x, field_y)
            end
            return str
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

        def get_image_field(field)
            arr = []
            arr[0] = field[0] < 0 ? @image.width  + field[0] : field[0]
            arr[1] = field[1] < 0 ? @image.height + field[1] : field[1]
            arr
        end
end

#~ begin
    #~ msg = Message.new(text: 'Pierwsza wiadomosc', sender: '0123', filename: '../images/cat_small.png')
    #~ msg.encode
    #~ puts "Odkodowano wiadomosc: " + msg.decode
    #~ puts "Odkodowano nadawce: " + msg.from?
    #~ puts "Znacznik czasowy: " + msg.timestamp
#~
    #~ msg.save
#~ rescue ImageTooSmall => e
    #~ puts e.message
#~ end
