require 'add_new_contact_window'
require '../helper/main_window_helper'

class MainWindow < Shoes
    url '/main',    :show

    def show
        MainWindowHelper::init
        window height: 500, width: 600, resizable: false do
            @messenger = stack width: '65%', height: 400, scroll: true
            @side_bar = stack width: '35%' do
                stack height: 400, scroll: true do
                    friends = MainWindowHelper::load_friends
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
            end
            stack width: '100%', margin_top: 4, margin_left: 4, margin_right: 4 do
                @message_box = edit_box width: '100%', height: 60
                flow do
                    @actions = {send:
                                    {name: 'Send',
                                     fun: lambda do
                                         MainWindowHelper::send
                                         @messenger.append { inscription @message_box.text } unless @message_box.text == ''
                                         @message_box.text = ''
                                         @messenger.scroll_top = @messenger.scroll_max
                                     end
                                    }, 
                                logout: 
                                    {name: 'Logout',
                                     fun: lambda do
                                         exit
                                     end
                                    },
                                add:
                                    {name: 'Add new contact',
                                     fun: lambda do
                                        puts 'Visiting add_contact'
                                        visit '/add_contact'
                                        close
                                     end
                                    }
                    }
                    @actions.each_value do |value|
                        value[:button] = button value[:name], margin_top: 2, width: "#{100/@actions.length}%" do
                            value[:fun].call
                        end
                    end
                    #every(5) do
                    #    @messenger.append { para MainWindowHelper::logout }
                    #    @messenger.scroll_top = @messenger.scroll_max 
                    #end
                end
            end
        end
    end

end
