require 'socket'        # Sockets are in standard library

hostname = 'localhost'
port = 1234

s = TCPSocket.open(hostname, port)
puts '---BEGIN OF CLIENT CONNECTION---'

begin
    s.puts "GAIL HATCHER LOVES GROVER BEST\0"
    sleep(0.1)
    s.puts "CONCETTA BOYER LIKES GROVER SNELL\0"
    answer = s.gets
    puts answer

    if answer.include?('IS')
        puts 'Login successful'
    else
        puts 'Login failed'
    end
rescue Errno::EPIPE
    puts 'Connection broken'
end

puts '---END OF CLIENT CONNECTION---'
s.close                 # Close the socket when done
