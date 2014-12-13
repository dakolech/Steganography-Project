require '../app'

Shoes.app title: 'Steganography Project' do
    def login
        flow margin_left: 10, margin_right: 10, margin_top: 5 do
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
            @side_bar = stack width: '35%' do
                stack height: 400, scroll: true do
                    friends
                end
            end
            stack width: '100%', margin_top: 4, margin_left: 4, margin_right: 4 do
                @message_box = edit_box width: '100%', height: 60
                flow do
                    @actions = {on_send:            {name: 'Send', fun: lambda { @app.on_send }},
                                on_logout:          {name: 'Logout', fun: lambda { @app.on_logout}},
                                on_add_new_contact: {name: 'Add new contact', fun: lambda { add_new_contact }}
                    }
                    @actions.each do |key, value|
                        value[:button] = button value[:name], margin_top: 2, width: "#{100/@actions.length}%" do
                            value[:fun].call
                        end
                    end
                    every(5) do
                        @app.check_new_messages
                    end
                end
            end
            @app = App.new @messenger, @message_box
        end
    end

    def add_new_contact
        window width: 300, height: 150 do
            flow margin_left: 10, margin_right: 10, margin_top: 5 do
                stack width: '40%' do
                    para 'Friend\'s name:', size: 10
                    para 'ID:', size: 10
                end
                stack width: '60%' do
                    @contact_name_edit = edit_line width: '100%'
                    @contact_id_edit = edit_line width: '100%'

                    @contact_add_button = button 'Add', width: '100%', margin_top: 3 do
                        owner.friends
                        close
                    end
                    button 'Cancel', width: '100%', margin_top: 3 do
                        close
                    end
                end
            end
        end
    end

    def friends
        puts 'Reloaded'
        friends = MainWindowHelper::get_friends
        friends.each do |friend|
            flow margin_top: 2, margin_bottom: 2 do
                @friends_stack = stack width: '80%' do
                    leave do |f|
                        f.clear { inscription friend[0] }
                    end
                    hover do |f|
                        f.clear do
                            f.background rgb(180, 180, 180)
                            inscription friend[0]
                        end
                    end
                    inscription friend[0]
                end
                stack width: '20%' do
                    leave { |f| f.clear }
                    hover do |f|
                        f.clear do
                            inscription 'Del', underline: 'single'
                        end
                    end
                end
            end
        end
    end

    login
end
