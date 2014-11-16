Shoes.app(width: 300, height: 120) {
    stack do
        flow margin: 10 do
            stack width: '30%' do
                para 'Your ID'
                para 'Password'
            end
            stack width: '50%' do
                @id_edit = edit_line
                @pass_edit = edit_line secret: true

                @login_button = button 'Login'
                @login_button.click { exit }
                @login_button.style margin_top: 10
            end
        end
    end
}
