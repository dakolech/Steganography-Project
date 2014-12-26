class SentenceDecoder
    def decode(options = {})
        key = options[:key]
        sentence = options[:sentence]

        return number_sentence(key, sentence) if !key.nil? and !sentence.nil?
        return verb_sentence(sentence) if !sentence.nil?
    end

    def validate(answer, type)
        case type
        when :id_answer
            answer.include?('USE')
        when :pass_answer
            answer.include?('IS')
        when :has_messages
            answer.include?('HAVE') or answer.include?('HAS')
        when :dest_answer
            answer.include?('HADNT') or answer.include?('HAD')
        else
            false
        end
    end

    def has_messages?(answer)
       answer.include?('HAVE')
    end

    def proper_destination?(answer)
        answer.include?('HADNT')
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
