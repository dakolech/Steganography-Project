require '../app'

module MainWindowHelper
    def MainWindowHelper.load_friends
        list = File.readlines('../data/friends')
        list.map!  { |l| l.strip.split(';') }
    end
    
    def MainWindowHelper.add
        puts 'Add method'
    end

    def MainWindowHelper.logout
        puts 'Logout method'
    end
    
    def MainWindowHelper.test(proc)
		app = App.new
		app.test_proc = proc
		app.run
    end
end
