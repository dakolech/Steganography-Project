class SentenceDecoder
    def decode(options = {})
        key = options[:key]
        sentence = options[:sentence]

        return number_sentence(key, sentence) if !key.nil? and !sentence.nil?
        return verb_sentence(sentence) if !sentence.nil?
    end

    private

        def number_sentence(key, sentence)
            pos = key[-1].to_i

            sentence = sentence.split(' ')
            sentence.delete_at(2)

            decoded = ''
            sentence.each do |word|
                decoded += key.index(word[pos]).to_s
            end
            decoded
        end

        def verb_sentence(sentence)
            sentence.split(' ')[1].downcase.to_sym
        end
end

s = SentenceDecoder.new
p s.decode(key: 'BEZLITOSNY2', sentence: 'GAIL HATCHER LOVES GROVER BEST')
