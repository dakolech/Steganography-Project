require 'main_window'

class AddNewContactWindow < Shoes
    url '/add_contact',        :show

    def show
        window height: 100, width: 200, resizable: false do
            flow margin_left: 10, margin_right: 10, margin_top: 5 do
                stack width: '30%' do
                    para 'Friend\'s name:', size: 10
                    para 'ID:', size: 10
                end
                stack width: '70%' do
                    @contact_name_edit = edit_line width: '100%'
                    @contact_id_edit = edit_line width: '100%'

                    @contact_add_button = button 'Login', width: '100%', margin_top: 3 do
                    end
                    button 'Cancel', width: '100%', margin_top: 3 do
                    end
                end
            end
        end
    end
end
