# 4. Anagrams

=begin

P:

Write a program that takes a word and a list of possible anagrams
and returns a list of only the correct anagrams of the word.

Anagrams must be complete anagrams, not partial

An identical word is not an anagram
  this suggests we need to remove any copies of the word string from 
  the match list before selecting for anagrams via the sort method

Anagrams are case insensitive
  however, the return list should have the original casing

Etc:

given "listen" and the list (enlists google inlets banana)
=> (inlets)

A checksum is not a reliable indicator of anagrams

Does not seem that we need to sort the return list

DS:

input:
-initialize takes a string
-match takes an array of strings

output:
-match returns array of strings

Anagram class
-initialize: saves word string
-match: given list, selects anagrams of word string

A:

Anagram function could sort characters of strings to compare.
#match
Given an array of strings, list
list = remove any (case-insensitive) copies of @word
Set match_string := normalize_sort(@word)
Select each current_word in list for
  match_string == normalize_sort(current_word)

#normalize_sort(text)
lowercase version of text
  split into chars
  sort
  join to new_text
return new_text
=end

# class Anagram
#   def initialize(word)
#     @word = word
#   end

#   def match(list)
#     match_string = normalize_sort(@word)
#     list.select do |current_word|
#       next if @word.downcase == current_word.downcase
#       match_string == normalize_sort(current_word)
#     end
#   end

#   private

#   def normalize_sort(text)
#     text.downcase.chars.sort.join
#   end
# end

# 25:51 including refactor

# LS solution
class Anagram
  attr_reader :word

  def initialize(word)
    @word = word.downcase
  end

  def match(word_array)
    word_array.select do |ana|
      ana.downcase != word && anagram?(ana, word)
    end
  end

  private

  def sorted_letters(str)
    str.downcase.chars.sort.join
  end

  def anagram?(word1, word2)
    sorted_letters(word1) == sorted_letters(word2)
  end
end