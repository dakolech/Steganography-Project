require '../helper/main_window_helper'

class MainWindow < Shoes
    url '/main',    :show

    def show
        window height: 450, width: 600, resizable: false do
            stack width: '70%', height: 400, scroll: true do
                #border red, strokewidth: 1
                20.times { inscription 'This is a messenger' }
            end
            stack width: '30%' do
                #border red, strokewidth: 1
                friends = MainWindowHelper::load_friends
                friends.each do |friend|
                    flow margin_top: 2, margin_bottom: 2 do
                        flow width: '80%' do
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
                        flow width: '20%' do
                            leave { |f| f.clear }
                            hover do |f|
                                f.clear do
                                    #image '../data/delete_red.png'
                                    inscription 'Del', underline: 'single'
                                end
                            end
                        end
                    end
                end
            end
            flow width: '100%' do
                #border red, strokewidth: 1
                @actions = ['Send', 'Add new contact', 'Logout']
                @actions.each do |action|
                    stack width: "#{100/@actions.length}%", margin_left: 2, margin_right: 2 do
                        button action, width: '100%' do
                            close
                        end
                    end
                end
            end
        end
    end
end
