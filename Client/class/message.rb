# -*- coding: utf-8 -*-
require 'oily_png'
require_relative 'exceptions'

class Message
    attr_accessor :image

    def initialize(properties = {})
        filename = properties[:filename] || '../images/cat_small.png'

        @text  = properties[:text]  || 'Some default text'
        @image = properties[:image] || ChunkyPNG::Image.from_file(filename)
        raise ImageTooSmall.new unless @image.width*@image.height > Image::TIMES_LARGER*@text.length

        @ip_dest = properties[:ip_dest]  || '127.0.0.1'
        @key = 0
        @occupied_pixels = Set.new
    end

    def encode
        @key = Random.srand.to_s.slice(0..8).to_i
        encode_key

        Random.srand @key
        @text.each_char.with_index do |char, index|
            x, y = find_next_pixel
            encode_letter(x, y, char)
        end
        @occupied_pixels.clear
    end

    def decode
        decode_key
        Random.srand @key

        str = ''
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
        module Image
            TIMES_LARGER = 50
            FREE_PIXELS = 5
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

#~ begin
    #~ msg = Message.new(text: 'Tajna wiadomosc', ip_dest: '127.0.0.1', filename: '../images/cat_small.png')
    #~ msg.encode
    #~ puts msg.decode
#~
    #~ 'Zażółć'.each_byte do |byte|
        #~ puts byte
    #~ end
#~
    #~ #msg.save
#~ rescue ImageTooSmall => e
    #~ puts e.message
#~ end