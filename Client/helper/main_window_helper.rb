module MainWindowHelper
    def MainWindowHelper.get_friends
        @list ||= load_friends_from_file
    end

    def MainWindowHelper.load_friends_from_file
        list = File.readlines('../data/friends')
        list.map!  { |l| l.strip.split(';') }
    end
end
