require 'spec_helper'

describe Question do

	before(:each) do 
		@tagger = EngTagger.new
		@fact = Question.new(text: "Einstein", choice1: "1910", choice2: "1879", choice3: "1855")
		@single_proper = Question.new(text: "When was Einstein born?", choice1: "1910", choice2: "1879", choice3: "1855")
		@double_proper = Question.new(text: "When was Albert Einstein born?", choice1: "1910", choice2: "1879", choice3: "1855")
		@double_common = Question.new(text: "What kind of animal is a giraffe?", choice1: "reptile", choice2: "mammal", choice3: "bird")
		@word_array = @single_proper.text.chomp("?").downcase.split(" ")
		@tagged_single = @tagger.add_tags(@single_proper.text)
		@tagged_double = @tagger.add_tags(@double_proper.text)
	end
	
	describe '#question_type' do
		it 'returns interrogative word found in question string' do
			@double_proper.question_type.should eq "when"
		end 
	end

	describe '#dictionary_lookup' do
		it 'gets a definition string from wiktionary api' do
			@fact.dictionary_lookup("animal")
		end
	end

	describe '#proper_nouns' do
		it 'hash counts all the proper nouns from input' do
			@single_proper.proper_nouns(@tagged_single).should eq "Einstein" => 1
			@double_proper.proper_nouns(@tagged_double).should include "Albert" => 1, "Einstein" => 1
		end
	end

	describe '#common_nouns' do
		it 'hash counts all the nouns from input' do
			@double_common.nouns(@tagger.add_tags(@double_common.text)).should include "animal" => 1, "giraffe" => 1
		end
	end

	describe '#choice_array' do
		it 'makes an array of a question\'s choices for manipulation' do
			@fact.choice_array.should eq ["1910", "1879", "1855"]
		end
	end
end