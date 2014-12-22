require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/colorize'

require 'socket'        # Sockets are in standard library

require_relative '../class/sentence_encoder'
require_relative '../class/sentence_decoder'

describe 'sending and recieving file from server' do

    before do
        @sock = TCPSocket.open('localhost', 1234)
        @encoder = SentenceEncoder.new
        @decoder = SentenceDecoder.new
    end

    it 'should send file to server' do
        #@sock.puts @encoder.generate(id: '4567', key: 'BEZLITOSNY2', verb: :loves)
        #@sock.gets
        #@sock.puts @encoder.generate(id: '8961', key: 'BEZLITOSNY2', verb: :likes)
        #@sock.gets

        file_to_send = '../images/changed.png'
    end

    after do
        unless sock.close.nil?
            @sock.close
        end
    end

end

