class SentenceEncoder
    def initialize
        @firstnames = File.readlines('../data/generate/popular-both-first.txt').each { |l| l.strip! }
        @lastnames  = File.readlines('../data/generate/popular-last.txt').each       { |l| l.strip! }
        @adjectives = File.readlines('../data/generate/adjectives.txt').each         { |l| l.strip! }
        @animals    = File.readlines('../data/generate/animals.txt').each            { |l| l.strip! }
        @bodyparts  = File.readlines('../data/generate/bodyparts.txt').each          { |l| l.strip! }
    end

    def generate(options = {})
        id  = options[:id]
        key = options[:key]

        verb = options[:verb]

        return verb_sentence(verb) if !verb.nil?
        return number_sentence(id, key) if !id.nil? and !key.nil?
    end

    private

        def verb_sentence(verb)
            case verb
                when :is
                    @animals.sample + ' IS ' + @adjectives.sample
                when :are
                    @animals.sample + 'S ARE ' + @adjectives.sample
                when :have
                    'I HAVE ' + @bodyparts.sample
                when :has
                    @animals.sample + ' HAS ' + @bodyparts.sample
                when :was
                    @animals.sample + ' WAS ' + @adjectives.sample
                when :were
                    @animals.sample + 'S WERE ' + @adjectives.sample
                when :hadnt
                    @animals.sample + ' HADNT ' + @bodyparts.sample
                when :had
                    @animals.sample + ' HAD ' + @bodyparts.sample
                when :use
                    @animals.sample + ' USES ' + @bodyparts.sample
            end
        end

        def number_sentence(id, key)

        end
end

s = SentenceEncoder.new
puts s.generate(verb: :is)
puts s.generate(verb: :are)
puts s.generate(verb: :have)
puts s.generate(verb: :has)
puts s.generate(verb: :was)
puts s.generate(verb: :were)
puts s.generate(verb: :hadnt)
puts s.generate(verb: :had)
puts s.generate(verb: :use)
