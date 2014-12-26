module ButtonHelper
    def ButtonHelper.get_name_button(label, edit_stack, color=black)
        edit_stack.app do
            leave do |f|
                f.clear { inscription label, stroke: color }
            end
            hover do |f|
                f.clear do
                    f.background rgb(180, 180, 180)
                    inscription label, stroke: color
                end
            end
            click do
                yield
            end
            inscription label, stroke: color
        end
    end

    def ButtonHelper.get_control_button(label, edit_stack)
        edit_stack.app do
            leave do |f|
                f.clear
            end
            hover do |f|
                f.clear do
                    f.background rgb(180, 180, 180)
                    inscription label, underline: 'single'
                end
            end
            click do
                yield
            end
        end
    end
end
