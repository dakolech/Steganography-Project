require '../class/exceptions'

module MainWindowHelper
    def MainWindowHelper.get_friends
        @list ||= load_friends_from_file
    end

    def MainWindowHelper.load_friends_from_file
        list = File.readlines('../data/friends')
        list.map! { |l| l.strip.split(';') }
    end

    def MainWindowHelper.add_friend(name, id)
        raise InvalidID.new unless /\A\d{4}\z/ === id
        @list.each { |el| raise DuplicateName.new unless el[0] != name }

        @list << [name, id]
    end

    def MainWindowHelper.save_friends
        @list.collect! do |el|
            el.join(';')
        end

        File.open('../data/friends', 'w') do |f|
            @list.each do |el|
                f.puts el
            end
        end
    end
end
