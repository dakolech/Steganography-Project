require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/colorize'

require_relative '../class/message'

describe Message do

    describe 'encoding and decoding single letters' do

        it 'should properly decode strings after encoding' do
            # Generate 100 random, dummy 50-chars strings
            dummy_messages = []
            (1..100).each do |i|
                dummy_messages << {text:   (0..50).map { ('a'..'z').to_a[rand(26)] }.join,
                                   sender: (0..3).map  { ('0'..'9').to_a[rand(10)] }.join }
            end

            # Check 'em all!
            dummy_messages.each do |message|
                msg = Message.new(text: message[:text], sender: message[:sender], filename: 'images/cat_small.png')
                msg.encode
                msg.decode.must_equal message[:text]
                msg.from?.must_equal message[:sender]
            end
        end

    end

end
