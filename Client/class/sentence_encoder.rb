class SentenceEncoder
    PROJECT_PATH = File.expand_path('../../', __FILE__)

    def initialize
        @firstnames = File.readlines(PROJECT_PATH + '/data/generate/popular-both-first.txt').each { |l| l.strip! }
        @lastnames  = File.readlines(PROJECT_PATH + '/data/generate/popular-last.txt').each       { |l| l.strip! }
        @adjectives = File.readlines(PROJECT_PATH + '/data/generate/adjectives.txt').each         { |l| l.strip! }
        @animals    = File.readlines(PROJECT_PATH + '/data/generate/animals.txt').each            { |l| l.strip! }
        @bodyparts  = File.readlines(PROJECT_PATH + '/data/generate/bodyparts.txt').each          { |l| l.strip! }
    end

    def generate(options = {})
        id  = options[:id]
        key = options[:key]
        verb = options[:verb]

        return number_sentence(id, key, verb) if !id.nil? and !key.nil?
        return verb_sentence(verb) if !verb.nil?
    end

    private

        def verb_sentence(verb)
            case verb
                when :belongs
                    @bodyparts.sample + ' BELONGS TO ' + @animals.sample
                when :was
                    @animals.sample + ' WAS ' + @adjectives.sample
                when :were
                    @animals.sample + 'S WERE ' + @adjectives.sample
                when :hadnt
                    @animals.sample + ' HADNT ' + @bodyparts.sample
                when :had
                    @animals.sample + ' HAD ' + @bodyparts.sample
            end
        end

        def number_sentence(id, key, verb)
            pos = key[-1].to_i

            letters = Array.new(id.length) { |i| key[id[i].to_i] }
            names = Array.new(id.length) do |i|
                file = if i%2 == 0 then @firstnames else @lastnames end
                find_name(pos, letters[i], file)
            end

            names[0] + ' ' + names[1] + " #{verb.to_s.upcase} " + names[2] + ' ' + names[3]
        end

        def find_name(n, letter, file)
            file.find { |name| name[n] == letter }
        end
end
