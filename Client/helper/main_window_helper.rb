module MainWindowHelper
    def MainWindowHelper.load_friends
        list = File.readlines('../data/friends')
        list.map!  { |l| l.strip.split(';') }
    end
end
