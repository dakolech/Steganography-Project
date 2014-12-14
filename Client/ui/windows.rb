require '../class/app'
require '../helper/button_helper'
require '../helper/main_window_helper'
require '../helper/option_helper'

Shoes.setup do
    gem 'oily_png'
end

Shoes.app title: 'Steganography Project' do
    def login
        flow margin: 10 do
            stack width: '100%', height: '65%' do
                subtitle 'Sign in is required!', align: 'center', margin_top: '60%'
            end
            stack width: '20%'
            stack width: '20%', height: 100 do
                para 'Your ID:', size: 10
                para 'Password:', size: 10
            end
            stack width: '40%', height: 100 do
                @id_edit = edit_line width: '100%'
                @pass_edit = edit_line width: '100%', secret: true

                @login_button = button 'Login', width: '100%', margin_top: 3
                @login_button.click do
                    main
                end
            end
            stack width: '20%'
        end
    end

    def main
        clear
        flow do
            @messenger = stack width: '65%', height: 400, scroll: true
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
                                on_add_new_contact: {name: 'Add new contact', fun: lambda { add_new_contact }},
                    }
                    @actions.each do |key, value|
                        value[:button] = button value[:name], margin_top: 2, width: "#{100/@actions.length}%" do
                            value[:fun].call
                        end
                    end
                    #every(5) do
                    #    @app.check_new_messages
                    #end
                    keypress do |k|
                        @app.on_send if k == "\n"
                    end
                end
            end
            @app = App.new @messenger, @message_box
        end
    end

    def add_new_contact
        window width: 300, height: 155, title: 'Add new contact' do
            flow margin: [10, 0, 10, 0] do
                stack width: '40%' do
                    para 'Friend\'s name:', size: 10
                    para 'ID:', size: 10
                end
                stack width: '60%' do
                    @contact_name_edit = edit_line width: '100%'
                    @contact_id_edit = edit_line width: '100%'

                    @contact_add_button = button 'Add', width: '100%', margin_top: 3 do
                        begin
                            MainWindowHelper::add_friend @contact_name_edit.text, @contact_id_edit.text
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
            friends = MainWindowHelper::get_friends
            friends.each do |friend|
                flow margin: [0, 2, 0, 2] do
                    @friends_stack = stack width: '70%' do
                        ButtonHelper::get_name_button friend[0], self do
                            puts "New conversation with #{friend[0]}"
                        end
                    end
                    @edit_stack = stack width: '15%' do
                        ButtonHelper::get_control_button 'Edit', self do
                            puts "Edit friend #{friend[0]}"
                        end
                    end
                    @del_stack = stack width: '15%' do
                        ButtonHelper::get_control_button 'Del', self do
                            puts "Really delete friend #{friend[0]} from list?"
                        end
                    end
                end
            end
        end
    end

    login
end
