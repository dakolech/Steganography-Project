require 'green_shoes'

Shoes.app(width: 300, height: 400) do
    stack(margin: 10) do
        @edit_box = edit_box do |e|
            @copy_box.text = @edit_box.text
        end

        @copy_box = para "What you type in the edit box goes here"

        @button = button("obfuscate") do
            ob_bytes = @copy_box.text.each_byte.map { |b| b + 1 }
            @copy_box.text = ob_bytes.map { |b| b.chr}.join
        end
    end
end
