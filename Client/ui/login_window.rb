require 'main_window'

class LoginWindow < Shoes
    url '/',        :show

    def show
        flow margin: 10 do
            stack width: '30%' do
                para 'Your ID:', size: 10
                para 'Password:', size: 10
            end
            stack width: '-30%' do
                @id_edit = edit_line
                @pass_edit = edit_line secret: true

                @login_button = button 'Login'
                @login_button.click do
                    visit '/main'
                    close
                end
                @login_button.style margin_top: 10
            end
        end
    end
end

Shoes.app width: 300, height: 120
