module OptionHelper
    def OptionHelper.get_options
        @options ||= load_config
    end

    def OptionHelper.load_config
        options = File.readlines('../data/config')
        options.map! { |o| o.strip.split(':') }
        options.map  { |o| o[0] = o[0].to_sym }
        options = options.to_h
        options[:server_ip] = options[:server_ip].split('.')
        options
    end

    def OptionHelper.change_options(server_ip, folder_name)
        server_ip.each_index do |i|
            @options[:server_ip][i] = server_ip[i].text
        end
        @options[:folder_with_images] = folder_name.text[1..-1]
    end

    def OptionHelper.save_options
        # na wypadek niezainicjalizowanej zmiennej @options
        @options = get_options
        @options[:server_ip] = @options[:server_ip].join('.')
        File.open('../data/config', 'w') do |f|
            @options.each do |key, value|
                f.puts "#{key}:#{value}"
            end
        end
    end
end
