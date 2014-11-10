require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/colorize'

require_relative '../message'

describe Message do

    describe 'encoding and decoding single letters' do

        it 'should properly decode letter after encoding' do
            msg = Message.new()
            [*('a'..'z'), *('A'..'Z')].each do |c|
                msg.encode_letter(0, 0, c)
                msg.decode_letter(0, 0).must_equal c
            end
        end

    end

end
