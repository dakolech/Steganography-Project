module MessageHelper
    def MessageHelper.get_timestamp
        Time.now.to_f.to_s.sub('.', '')[0..12]
    end
end
