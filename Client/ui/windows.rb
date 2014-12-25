require '../class/app'
require '../helper/button_helper'
require '../helper/friends_helper'
require '../helper/option_helper'

Shoes.setup do
    gem 'oily_png'
end

Shoes.app title: 'Steganography Project', resizable: false do
    def login
        flow margin: 10 do
            stack width: '100%', height: '60%' do
                subtitle 'Sign in is required!', align: 'center', margin_top: '60%'
            end
            stack width: '20%'
            stack width: '20%', height: 80 do
                para 'Your ID:', size: 10
                para 'Password:', size: 10
            end
            stack width: '40%', height: 140 do
                @id_edit = edit_line width: '100%'
                @pass_edit = edit_line width: '100%', secret: true

                @app = App.new
                @login_button = button 'Login', width: '100%', margin_top: 3 do
                    if @app.on_login(@id_edit.text, @pass_edit.text, @login_status)
                        main
                    end
                end
                @login_status = stack width: '100%', hidden: true
            end
            stack width: '20%'
        end
    end

    def main
        clear
        flow do
            stack width: '65%' do
                @conversation_with = stack width: '30%', height: 30
                @messenger = stack width: '100%', height: 370, scroll: true
            end
            @side_bar = stack width: '35%', height: 400, scroll: true
            friends
            stack width: '100%', margin: 4 do
                @message_box = edit_box width: '100%', height: 60 do |mb|
                    mb.text = '' if mb.text == "\n"
                    @messenger.scroll_top = @messenger.scroll_max
                end
                flow do
                    @actions = {on_options:         {name: 'Options', fun: lambda { options }},
                                on_logout:          {name: 'Logout', fun: lambda { @app.on_logout }},
                                on_add_new_contact: {name: 'Add new contact', fun: lambda { contact_action action: :new }},
                    }
                    @actions.each do |key, value|
                        value[:button] = button value[:name], margin_top: 2, width: "#{100/@actions.length}%" do
                            value[:fun].call
                        end
                    end
                    every(5) do
                        if @app.check_new_messages
                            friends
                        end
                    end
                    keypress do |k|
                        @app.on_send if k == "\n"
                    end
                end
            end
            @app.set_message_stuff @messenger, @message_box
            set_active_friend FriendsHelper::get_friends.keys[0]
        end
    end

    def contact_action(mode = {})
        if mode[:action] == :edit
            user_name = mode[:user]
            user_id = mode[:id]
        end

        window width: 300, height: 155, title: 'Add new contact' do
            flow margin: [10, 0, 10, 0] do
                stack width: '40%' do
                    para 'Friend\'s name:', size: 10
                    para 'ID:', size: 10
                end
                stack width: '60%' do
                    @contact_name_edit = edit_line user_name, width: '100%'
                    @contact_id_edit = edit_line user_id, width: '100%'

                    button 'Apply', width: '100%', margin_top: 3 do
                        begin
                            if user_name.nil?
                                FriendsHelper::add_friend @contact_name_edit.text, @contact_id_edit.text
                            else
                                FriendsHelper::edit_friend @contact_name_edit.text, @contact_id_edit.text, user_name
                            end
                            owner.friends
                            close
                        rescue AddNewContactError => e
                            @exception_message.text = e.message
                            @exception_message.show
                        end
                    end
                    button 'Cancel', width: '100%', margin_top: 3 do
                        close
                    end
                    @exception_message = inscription stroke: red, hidden: true
                end
            end
        end
    end

    def options
        window width: 300, height: 160, title: 'Options' do
            options = OptionHelper::get_options
            stack do
                inscription 'Server IP: '
                flow margin_left: 50 do
                    check_number = lambda { |e| e.text = '' unless e.text =~ /^\d{1,3}$/ }
                    @server_ip = []
                    (0..3).each do |i|
                        @server_ip << (edit_line options[:server_ip][i], width: 40 do |e| check_number.call(e) end)
                        inscription '.' unless i == 3
                    end
                end
                flow do
                    inscription "Folder with images:\n"
                    @folder_name = inscription "#{options[:folder_with_images]}"
                    button 'Browse...', right: 5 do
                        dir = ask_open_folder
                        dir.slice!('/home/bartosz/Documents/Politechnika/Semestr_V/SK2/Steganography-Project/')
                        @folder_name.text = "\t" + dir
                    end
                end
            end
            flow margin: [5, 5, 5, 0] do
                button 'Apply', width: '50%' do
                    OptionHelper::change_options @server_ip, @folder_name
                    close
                end
                button 'Cancel', width: '50%' do
                    close
                end
            end
        end
    end

    def friends
        @side_bar.clear do
            friends_list = FriendsHelper::get_friends
            friends_list.each do |friend, id|
                flow margin: [0, 0, 0, 4] do
                    @friends_stack = stack width: '70%' do
                        color = @app.have_unreaded(friend) ? red : black

                        ButtonHelper::get_name_button friend, self, color do
                            set_active_friend friend
                        end
                    end
                    @edit_stack = stack width: '15%' do
                        ButtonHelper::get_control_button 'Edit', self do
                            contact_action action: :edit, user: friend, id: id
                            puts "Edit friend #{friend}"
                        end
                    end
                    @del_stack = stack width: '15%' do
                        ButtonHelper::get_control_button 'Del', self do
                            if confirm "Really delete friend #{friend} from contacts?"
                                FriendsHelper::delete_friend(friend)
                                friends
                            end
                        end
                    end
                end
            end
        end
    end

    def set_active_friend(friend)
        @conversation_with.clear do
            background "#B4B4B4"
            para strong(friend), stroke: darkslategray
        end
        @app.begin_conversation friend
    end

    login
end
