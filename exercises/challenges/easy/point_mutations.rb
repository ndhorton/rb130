# 2. Point Mutations

=begin

P:

Write a program that can calculate the Hamming distance between two DNA
strands.

The Hamming distance is the number of characters that are different at
corresponding positions in two strings representing DNA.

The Hamming distance is only defined for sequences of equal length.
If you have two sequences of different length, you should compute Hamming
distance over the shorter length.

So more pragmatically, we need to compare two collections or strings
on an index-by-index basis. The Hamming distance starts at 0 and incremenets
by 1 for every difference found between the characters at index n in the two
collections/strings.

We only compute this over the length of the shorter collection/string.

Etc:

DNA#hamming_distance == 0 if object dna string or argument string are empty

Do not mutatate either string

Only iterate over the first n characters of both strings where n is shorter
length

We do not seem to need to validate inputs

DS:

We need a class called DNA

DNA
-initialize(string: strand)
-hamming_distance(string: other_strand)
-strand attribute

A:

#hamming_distance
Given a string, other_strand
Set target_length := minimum of the lengths of the two strands
Set distance := 0
Iterate for index from 0 upto not including target_length
  if strand[index] != other_strand[index]
    distance = distance + 1
Return distance
=end

class DNA
  attr_reader :strand

  def initialize(strand)
    @strand = strand
  end

  def hamming_distance(other_strand)
    target_length = [strand.length, other_strand.length].min
    distance = 0

    (0...target_length).each do |index|
      next if strand[index] == other_strand[index]
      distance += 1
    end

    distance
  end
end

# 23:54

# LS solution

# class DNA
#   def initialize(strand)
#     @strand = strand
#   end

#   def hamming_distance(comparison)
#     shorter = @strand.length < comparison.length ? @strand : comparison
#     differences = 0

#     shorter.length.times do |index|
#       differences += 1 unless @strand[index] == comparison[index]
#     end

#     differences
#   end
# end
