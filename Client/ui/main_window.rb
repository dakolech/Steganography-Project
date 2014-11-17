require '../helper/main_window_helper'

class MainWindow < Shoes
    url '/main',    :show

    def show
        window height: 435, width: 600, resizable: false do
            stack width: '70%' do
                stack height: 400, scroll: true do
                    20.times { inscription 'This is a messenger' }

                end
                flow margin_top: 4 do
                    edit_line width: '80%'
                    button 'Send', width: '20%'
                end
            end
            stack width: '30%' do
                stack height: 400, scroll: true do
                    friends = MainWindowHelper::load_friends
                    friends.each do |friend|
                        flow margin_top: 2, margin_bottom: 2 do
                            stack width: '80%' do
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
                flow do
                    @actions = ['Add new...', 'Logout']
                    @actions.each do |action|
                        button action, margin_top: 4,
                                        width: "#{100/@actions.length}%" do
                            close
                        end
                    end
                end
            end
        end
    end
end
