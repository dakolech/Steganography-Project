require 'socket'        # Sockets are in standard library

require_relative '../../class/sentence_encoder'
require_relative '../../class/sentence_decoder'

module ConnectionTestHelper
    def ConnectionTestHelper.log_in_as(id, pass, key)
        @encoder ||= SentenceEncoder.new

        @sock = TCPSocket.open('localhost', 1234)
        @sock.puts @encoder.generate(id: id, key: key, verb: :loves)
        sleep(0.1)
        @sock.gets
        @sock.puts @encoder.generate(id: pass, key: key, verb: :likes)
        @sock.gets

        @sock
    end
end
