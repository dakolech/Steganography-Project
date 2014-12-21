class SentenceDecoder
    def decode(options = {})
        key = options[:key]
        sentence = options[:sentence]

        return number_sentence(key, sentence) if !key.nil? and !sentence.nil?
        return verb_sentence(sentence) if !sentence.nil?
    end

    private

        def number_sentence(key, sentence)

        end

        def verb_sentence(verb)

        end
end
