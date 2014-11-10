require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/colorize'

require_relative '../message'

describe Message do

    describe 'encoding and decoding single letters' do

        it 'should properly decode strings after encoding' do
            ['', '', ''].each do |message|
                msg = Message.new(text: message)
                msg.encode
                msg.decode.must_equal message
            end
        end

    end

end
