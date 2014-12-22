require '../class/exceptions'

module FriendsHelper
    def FriendsHelper.get_friends
        @list ||= load_friends_from_file
    end

    def FriendsHelper.load_friends_from_file
        list = File.readlines('../data/friends')
        list.map! { |l| l.strip.split(';') }
        list = list.to_h
        list.sort.to_h
    end

    def FriendsHelper.add_friend(name, id)
        raise InvalidID.new unless /\A\d{4}\z/ === id
        @list.each { |n, i| raise DuplicateName.new unless n != name }
        @list.each { |n, i| raise DuplicateID.new   unless i != id   }

        @list[name] = id
    end

    def FriendsHelper.edit_friend(name, id, old_name)
        delete_friend(old_name)
        add_friend(name, id)
    end

    def FriendsHelper.delete_friend(name)
        @list.delete(name)
    end

    def FriendsHelper.save_friends
        @list = @list.to_a
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
