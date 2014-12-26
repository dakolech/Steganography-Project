require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/colorize'

require 'socket'        # Sockets are in standard library

describe 'sending and recieving file from server' do

    before do
        #@sock = ConnectionTestHelper.log_in_as '4567', '8961', 'BEZLITOSNY2'
        @sock = TCPSocket.open('localhost', 1234)
    end

    it 'should send&receive file from server' do
        file_to_send = 'images/changed.png'
        @sock.puts File.size(file_to_send)
        sleep(0.1)
        File.open(file_to_send) do |f|
            @sock.print f.read
        end

        received_file = 'images/received.png'
        received_file_size = @sock.gets.to_i
        puts 'Received file size: ' + received_file_size.to_s
        data = @sock.read(received_file_size)

        dest_file = File.open(received_file, 'wb')
        dest_file.print data
        dest_file.close
    end

    after do
        unless @sock.nil?
            @sock.close
        end
    end

end

