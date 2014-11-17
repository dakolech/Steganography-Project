require '../helper/main_window_helper'

class MainWindow < Shoes
    url '/main',    :show

    def show
        window height: 500 do
            flow width: '100%' do
                border red, strokewidth: 1
                @actions = ['Logout', 'Add new contact']
                @actions.each do |action|
                    stack width: "#{100/@actions.length}%", margin_left: 2, margin_right: 2 do
                        leave { |f| f.clear { para action, size: 10 } }
                        hover do |f|
                            f.clear do
                                @hover_bg = f.background rgb(180, 180, 180)
                                para action, size: 10
                            end
                        end
                        click { |f| close }
                        para action, size: 10
                    end
                end
            end
            stack width: '70%' do
                border red, strokewidth: 1
                para 'This is a messenger'
            end
            stack width: '30%' do
                border red, strokewidth: 1
                friends = MainWindowHelper::load_friends
                friends.each do |friend|
                    flow margin_top: 2, margin_bottom: 2 do
                        leave do |f|
                            f.clear { para friend[0], size: 10 }
                        end
                        hover do |f|
                            f.clear do
                                @hover_bg = f.background rgb(180, 180, 180)
                                para friend[0], size: 10
                                para 'Del', size: 10
                            end
                        end
                        para friend[0], size: 10
                    end
                end
            end
        end
    end
end
