require 'spec_helper'

describe Question do

	before(:each) do 
		@tagger = EngTagger.new
		@fact = Question.new(text: "Einstein", choice1: "1910", choice2: "1879", choice3: "1855")
		@string_q = Question.new(text: "When was Einstein born?")
		@word_array = @string_q.text.chomp("?").downcase.split(" ")
		@tagged_string = @tagger.add_tags(@string_q.text)
	end
	
	describe '#part_of_speech' do
		it 'types words by lexical category' do
			#this may be unnecessary due to EngTagger gem
		end 
	end

	describe '#keyword_finder' do
		it 'attempts to parse out a search term from a question string' do
			@string_q.keyword_finder(@tagged_string).should eq "Einstein"
		end
	end

	describe '#choice_array' do
		it 'makes an array of a question\'s choices for manipulation' do
			@fact.choice_array.should eq ["1910", "1879", "1855"]
		end
	end
end