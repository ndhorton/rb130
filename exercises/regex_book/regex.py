import re

def p(regex, text):
    print(re.findall(regex,
                     text,
                     flags=re.MULTILINE |
                     re.IGNORECASE))

# text = ("cat\ncot\nCATASTROPHE\nWILDCAUGHT\n" +
#         "wildcat\n-GET-\nYacht")

# p(r'^c.t', text) # ['cat', 'cot', 'CAT']
# p(r'c.t$', text) # ['cat', 'cot', 'cat', 'cht']

p(r'\Afoo\Z', 'foo') # ['foo']
p(r'\Afoo\Z', 'fool') # []
p(r'\Afoo\Z', 'barfoo') # []

