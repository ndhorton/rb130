# Anagrams

=begin

P:

Write a program that takes a word and a list of possible
anagrams and returns the correct sublist that contains
the anagrams of the word.

For example, given the word "listen" and a list of candidates
like "enlists", "google", "inlets", "banana", the program
should return a list containing "inlets".

Etc:

So we give the word to the constructor
Then we have a #match method that takes an array of possible
anagrams and returns a new array containing the actual anagrams
if any.

if there's no anagrams, return empty array
Anagrams should be case insensitive
  the returned anagram should be same case as given
Return successful candidates in the order given

DS:

class Anagram
#initialize (string word) set @word to word
                          set @ordered_letters to normalized case, sorted
#match(array candidates) -> array anagrams

A:

#initialize (string word) set @word to word
                          set @ordered_letters to normalized case, sorted

#match
Given an array, candidates
Select candidates that are #anagram? and != @word (normalize case)

private #anagram?
Given a string, candidate
Set normalized_candidate := normalize case of candidate
                  split into chars
                  sort
                  join
return @ordered_letters == normalized_candidate

=end

class Anagram
  def initialize(word)
    @word = word
    @ordered_letters = @word.downcase.chars.sort.join
  end

  def match(candidates)
    candidates.select do |candidate|
      anagram?(candidate) && candidate.downcase != @word.downcase
    end
  end

  private

  def anagram?(candidate)
    ordered_candidate = candidate.downcase.chars.sort.join
    @ordered_letters == ordered_candidate
  end
end

# 16:14
