require 'socket'        # Sockets are in standard library

hostname = 'localhost'
port = 1234

def receive_file
    s = TCPSocket.open(hostname, port)
    f = File.new('received.txt', 'w+')
    while line = s.gets                # Read lines from the socket
        f.write(line)
    end

    f.close
    s.close               # Close the socket when done
end

