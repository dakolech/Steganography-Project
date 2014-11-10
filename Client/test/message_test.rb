require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/colorize'

require_relative '../message'

describe Message do

    describe 'encoding and decoding single letters' do

        it 'should properly decode strings after encoding' do
            ['Sample text in length about 50 characters',
             'Th!s_m@y__be  mqre PROBLEMATIC',
             '($*%#@&*$^&(@^(*&*$&@))) hardcore'].each do |message|
                msg = Message.new(text: message)
                msg.encode
                msg.decode.must_equal message
            end
        end

    end

end
