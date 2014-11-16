require '../helper/main_window_helper'

class MainWindow < Shoes
    url '/main',    :show

    def show
        window height: 500 do
            stack width: '100%' do
                border red, strokewidth: 1
                para 'Header'
            end
            stack width: '20%' do
                border red, strokewidth: 1
                button 'Logout' do
                    close
                end
            end
            stack width: '50%' do
                border red, strokewidth: 1
                para 'This is a messenger'
            end
            stack width: '30%' do
                border red, strokewidth: 1
                friends = MainWindowHelper::load_friends
                friends.each do |friend|
                    stack do
                        hover { |f| @hover_bg = f.background blue }
                        leave { |f| @hover_bg.remove }
                        para friend[0]
                    end
                end
            end
        end
    end
end
