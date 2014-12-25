require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/colorize'

require_relative '../class/connection'

describe Connection do

    it 'should log in to server and receive images' do
        test_connection = Connection.new('localhost', 1234)
        test_connection.log_in('4567', '8961').must_equal true
        test_connection.download_messages_from_server

        sleep(1)
        test_connection.close
    end

end
