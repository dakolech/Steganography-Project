require 'socket'
require 'find'

require_relative 'exceptions'
require_relative 'sentence_encoder'
require_relative 'sentence_decoder'
require_relative 'message'

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
        receive_sentence = @sentence_encoder.generate(key: 'BEZLITOSNY2', verb: :was)
        @socket.puts receive_sentence

        i = 0
        loop do
            answer = @socket.gets
            unless @sentence_decoder.validate(answer, :has_messages)
                puts "Wadliwa odpowiedz: " + answer
                raise ConnectionError.new 'Bad answer from server when asking if user has messages'
            end

            break unless @sentence_decoder.has_messages?(answer)
            download_message(i)
            i += 1
        end
        decode_images
    end

    def send_message_to_server(message, dest_id)
        begin
            return false unless prepare_server_for_sending_image(dest_id)
            prepare_message(message, '../images/cat_small.png')

            @socket.puts File.size('../images/to_send.png')
            sleep(0.1)
            File.open('../images/to_send.png') do |f|
                @sock.print f.read
            end
        rescue ConnectionError => ce
            puts ce.message
            return false
        end
    end

    def close
        logout_sentence = @sentence_encoder.generate(key: 'BEZLITOSNY2', verb: :belongs)
        @socket.puts logout_sentence

        @socket.close
    end

    private

        def download_message(number)
            received_file = "../images/#{@id}_#{number.to_s}.png"
            received_file_size = @socket.gets.to_i
            puts 'Received file size: ' + received_file_size.to_s
            data = @socket.read(received_file_size)

            dest_file = File.open(received_file, 'w+b')
            dest_file.print data
            dest_file.close
        end

        def decode_images
            new_messages = []
            find_my_images.each do |image|
                msg = Message.new(filename: image)
                puts 'Decoding image: ' + image
                new_messages << {from: msg.from?, text: msg.decode}
                File.delete(image)
            end
            new_messages
        end

        def find_my_images
            image_file_paths = []
            Find.find('../images/') do |path|
                image_file_paths << path if path =~ /\.{2}\/images\/#{@id}.*\.png$/
            end
            image_file_paths.sort!
            image_file_paths
        end

        def prepare_server_for_sending_image(dest_id)
            send_sentence = @sentence_encoder.generate(key: 'BEZLITOSNY2', verb: :were)
            @socket.puts send_sentence

            sleep(0.1)
            dest_sentence = @sentence_encoder.generate(key: 'BEZLITOSNY2', id: dest_id, verb: :hates)
            @socket.puts dest_sentence

            answer = @socket.gets
            unless @sentence_decoder.validate(answer, :dest_answer)
                puts "Wadliwa odpowiedz: " + answer
                raise ConnectionError.new 'Bad answer from server when trying to send dest id'
            end

            return false unless @sentence_decoder.proper_destination?(answer)
            true
        end

        def prepare_message(message, file)
            msg = Message.new(text: message, sender: @id, filename: file)
            msg.encode
            msg.save
        end
end
