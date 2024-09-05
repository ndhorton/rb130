# Encrypted Pioneers

=begin

P:

  Write a method that implements ROT13.

Etc:

Given a string, text
All chars except letters map to themselves
A letter is rotated 13 in the alphabet

A -> N
N -> A
a -> n
n -> a

DS:

A hash that maps every lowercase letter to its alphabetic ordinal number 0-25
  and does the same for uppercase letters

A:
Define a hash as above, alphabet
Given a string, text
Set chars := split text into array of chars
Set result_chars := empty array
Iterate through each char in chars
  If char is not a letter
    Push char to result_chars
    Continue to next iteration
  Set letter_number := alphabet[char]
  letter_number = (letter_number + 13) % 26
  Push key from alphabet corresponding to letter_number to result_chars
Return join result_chars to a string
=end

ALPHABET = (('A'..'Z').zip(0..25) + ('a'..'z').zip(0..25)).to_h.freeze

def rot13(text)
  result_chars = []
  text.each_char do |char|
    if char =~ /[^a-zA-Z]/
      result_chars << char
      next
    end

    letter = ALPHABET.key((ALPHABET[char] + 13) % 26)
    result_chars << (char == char.upcase ? letter.upcase : letter.downcase)
  end
  result_chars.join
end

# LS solution

def rot13(encrypted_text)
  encrypted_text.each_char.reduce('') do |result, encrypted_char|
    result + decipher_character(encrypted_char)
  end
end

def decipher_character(encrypted_char)
  case encrypted_char
  when 'a'..'m', 'A'..'M' then (encrypted_char.ord + 13).chr
  when 'n'..'z', 'N'..'Z' then (encrypted_char.ord - 13).chr
  else                         encrypted_char
  end
end

# Further exploration

EBDIC = (
  ('a'..'i').zip(129..137) +
  ('j'..'r').zip(145..153) +
  ('s'..'z').zip(162..169) +
  ('A'..'I').zip(193..201) +
  ('J'..'R').zip(209..217) +
  ('S'..'Z').zip(226..233)
).to_h.freeze

def decipher_ebcdic_char(char)
  intermediate_number = case char
                        when 'a'..'m', 'A'..'M' then EBDIC[char] + 13
                        when 'n'..'z', 'N'..'Z' then EBDIC[char] - 13
                        else                         nil
                        end
  # make EBCDIC adjustment
  case char
  when 'a'..'e', 'A'..'E' then EBDIC.key(intermediate_number + 7)
  when 'f'..'i', 'F'..'I' then EBDIC.key(intermediate_number + 15)
  when 'j'..'m', 'J'..'M' then EBDIC.key(intermediate_number + 8)
  when 'n'..'r', 'N'..'R' then EBDIC.key(intermediate_number - 7)
  when 's'..'v', 'S'..'V' then EBDIC.key(intermediate_number - 15)
  when 'w'..'z', 'W'..'Z' then EBDIC.key(intermediate_number - 8)
  else
    char
  end
end

def ebdic_rot13(text)
  text.each_char.reduce('') do |result, char|
    result + decipher_ebcdic_char(char)
  end
end

names = [
  'Nqn Ybirynpr',
  'Tenpr Ubccre',
  'Nqryr Tbyqfgvar',
  'Nyna Ghevat',
  'Puneyrf Onoontr',
  'Noqhyynu Zhunzznq ova Zhfn ny-Xujnevmzv',
  'Wbua Ngnanfbss',
  'Ybvf Unvog',
  'Pynhqr Funaaba',
  'Fgrir Wbof',
  'Ovyy Tngrf',
  'Gvz Orearef-Yrr',
  'Fgrir Jbmavnx',
  'Xbaenq Mhfr',
  'Fve Nagbal Ubner',
  'Zneiva Zvafxl',
  'Lhxvuveb Zngfhzbgb',
  'Unllvz Fybavzfxv',
  'Tregehqr Oynapu'
]

names.each { |name| puts ebdic_rot13(name) }

