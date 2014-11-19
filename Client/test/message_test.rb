require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/colorize'

require_relative '../message'

describe Message do

    describe 'encoding and decoding single letters' do

        it 'should properly decode strings after encoding' do
            # Generate 100 random, dummy 50-chars strings
            dummy_text = []
            (1..100).each do |i|
                dummy_text << (0...50).map { ('a'..'z').to_a[rand(26)] }.join
            end

            # Check 'em all!
            dummy_text.each do |message|
                msg = Message.new(text: message)
                msg.encode
                msg.decode.must_equal message
            end
        end

    end

end
