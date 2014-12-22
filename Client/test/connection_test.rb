require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/colorize'

require 'socket'        # Sockets are in standard library

require_relative '../class/sentence_encoder'
require_relative '../class/sentence_decoder'

describe 'login to server with id and pass' do

    before do
        @encoder = SentenceEncoder.new
        @decoder = SentenceDecoder.new
    end

    it 'should log in to server with proper data' do
        (1..100).each do |i|
            sock = TCPSocket.open('localhost', 1234)

            sock.puts @encoder.generate(id: '4567', key: 'BEZLITOSNY2', verb: :loves)
            sleep(0.1)
            sock.gets
            sock.puts @encoder.generate(id: '8961', key: 'BEZLITOSNY2', verb: :likes)
            sock.gets

            unless sock.close.nil?
                sock.close
            end
        end
    end

end
