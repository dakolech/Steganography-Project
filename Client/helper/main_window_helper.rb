require '../app'

module MainWindowHelper
    def MainWindowHelper.load_friends
        list = File.readlines('../data/friends')
        list.map!  { |l| l.strip.split(';') }
    end

    def MainWindowHelper.init
        @app = App.new   
    end

    def MainWindowHelper.send
        @app.send
    end

    def MainWindowHelper.logout
        @app.logout
    end
end
