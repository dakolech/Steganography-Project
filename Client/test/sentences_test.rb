require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/colorize'

require_relative '../class/sentence_encoder'

describe SentenceEncoder do
    before do
        @encoder = SentenceEncoder.new
    end

    describe 'generating verb_sentence' do
        it 'should contain required verb' do
            [:is, :are, :have, :has, :was, :were, :hadnt, :had, :use].each do |v|
                @encoder.generate(verb: v).must_include v.to_s.upcase
            end
        end
    end

    describe 'generating number_sentence' do
        it 'should contain required verb' do
            [:loves, :likes, :hates].each do |v|
                dummy_ids = []
                (1..100).each do |i|
                    dummy_ids << (0..3).map { rand(10).to_s }.join
                end

                dummy_ids.each do |id|
                    @encoder.generate(id: id, key: 'BEZLITOSNY2', verb: v).must_include v.to_s.upcase
                end
            end
        end
    end
end

describe 'Encoding and decoding id, pass and destination in sentences' do
    it 'should decode properly previous encoded id' do
        nil.must_be_nil
    end
end
