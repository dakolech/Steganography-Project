require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/colorize'

require 'socket'        # Sockets are in standard library

describe 'login to server with id and pass' do

    it 'should log in to server with proper data' do
        (1..100).each do |i|
            hostname = 'localhost'
            port = 1234

            sock = TCPSocket.open(hostname, port)

            sock.puts "GAIL HATCHER LOVES GROVER BEST"
            sleep(0.1)
            sock.puts "CONCETTA BOYER LIKES GROVER SNELL"

            answer = sock.gets
            answer.must_include('IS')

            sleep(0.5)
            sock.close
        end
    end

end
