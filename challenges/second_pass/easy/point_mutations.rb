=begin

P:

Write a method that computes the Hamming distance between two
DNA strands. The first strand is given to a new DNA instance.
The second is passed to the #hamming_distance method.

Essentially, we need to count the number of characters where the
two strings differ at the same index.

Approach:
Iterate over one string and if the other differs at a character, add one to acc
If the two strings differ in size, we ignore the extra letters in the larger one
So iterate over the shorter one
Do not mutate arguments

Etc:

The Hamming distance between two empty strings is 0.
distance between identical strings is 0.

'GAC TA CG G ACA GG       GTAGGGAAT'
'GAC AT CG C ACA CC'
=>   2  +  1   + 2  = 5 

DS:
class DNA
# initialize (string sequence)
# hamming_distance (string other_sequence) -> int distance

A:
#initialize
Given a string, sequence
Set @sequence to sequence

#hamming
Given a string, other_sequence
Set result := 0
Set shorter := shorter string between @sequence and other_sequence
Set longer := longer ""
Iterate over each char with index in shorter string
  If char != longer[index]
    Increment result
Return result
=end

# class DNA
#   def initialize(sequence)
#     @sequence = sequence
#   end

#   def hamming_distance(other_sequence)
#     result = 0
#     shorter = @sequence.size < other_sequence.size ? @sequence : other_sequence
#     longer = @sequence.size < other_sequence.size ? other_sequence : @sequence
#     shorter.each_char.with_index do |char, index|
#       result += 1 if char != longer[index]
#     end
#     result
#   end
# end

# LS solution
# we don't even need to distinguish which string is shorter in this
# way, we just need to know what the shortest _length_ is.

class DNA
  def initialize(strand)
    @strand = strand
  end

  def hamming_distance(comparison)
    shorter = @strand.length < comparison.length ? @strand : comparison
    differences = 0

    shorter.length.times do |index|
      differences += 1 unless @strand[index] == comparison[index]
    end

    differences
  end
end
