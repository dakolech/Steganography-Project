require 'socket'

require_relative 'exceptions'
require_relative 'sentence_encoder'
require_relative 'sentence_decoder'

class Connection
    attr_reader :host, :port

    def initialize(host, port)
        @host = host
        @port = port
        @socket = TCPSocket.open(host, 1234)

        @sentence_encoder = SentenceEncoder.new
        @sentence_decoder = SentenceDecoder.new
    end

    def log_in(id, pass)
        id_sentence   = @sentence_encoder.generate(id: id,   key: 'BEZLITOSNY2', verb: :loves)
        pass_sentence = @sentence_encoder.generate(id: pass, key: 'BEZLITOSNY2', verb: :likes)

        @socket.puts id_sentence
        answer = @socket.gets
        raise ConnectionError.new 'Bad ID' unless @sentence_decoder.validate(answer, :id_answer)

        @socket.puts pass_sentence
        answer = @socket.gets
        raise ConnectionError.new 'Bad password' unless @sentence_decoder.validate(answer, :pass_answer)

        return true
    end

    def close
        @socket.close
    end
end
