require 'main_window'

class LoginWindow < Shoes
    url '/',        :show

    def show
        flow margin_left: 10, margin_right: 10, margin_top: 5 do
            stack width: '30%' do
                para 'Your ID:', size: 10
                para 'Password:', size: 10
            end
            stack width: '70%' do
                @id_edit = edit_line width: '100%'
                @pass_edit = edit_line width: '100%', secret: true

                @login_button = button 'Login', width: '100%', margin_top: 3
                @login_button.click do
                    visit '/main'
                    close
                end
            end
        end
    end
end

Shoes.app width: 300, height: 100, title: 'Steganography Project'
