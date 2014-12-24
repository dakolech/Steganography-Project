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
        @id = id
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

    def download_messages_from_server
        #receive_sentence = @sentence_encoder.generate(key: 'BEZLITOSNY2', verb: :was)
        #@socket.puts receive_sentence

        i = 0
        loop do
            answer = @socket.gets
            unless @sentence_decoder.validate(answer, :has_messages)
                puts "Wadliwa odpowiedz: " + answer
                raise ConnectionError.new 'Bad anser from server when asking if user has messages'
            end

            break unless @sentence_decoder.has_messages?(answer)
            download_message(i)
            i += 1
        end
    end

    def close
        @socket.close
    end

    private

        def download_message(number)
            received_file = "images/#{@id}_#{number.to_s}.png"
            received_file_size = @socket.gets.to_i
            puts 'Received file size: ' + received_file_size.to_s
            data = @socket.read(received_file_size)

            dest_file = File.open(received_file, 'w+b')
            dest_file.print data
            dest_file.close
        end
end
