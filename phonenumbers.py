wordsfilelocation = '/Users/Jared/Desktop/words.txt'

numbers_for_letter = {
'a': 2, 'A': 2,
'b': 2, 'B': 2,
'c': 2, 'C': 2,

'd': 3, 'D': 3,
'e': 3, 'E': 3,
'f': 3, 'F': 3,

'g': 4, 'G': 4,
'h': 4, 'H': 4,
'i': 4, 'I': 4,

'j': 5, 'J': 5,
'k': 5, 'K': 5,
'l': 5, 'L': 5,

'm': 6, 'A': 6,
'n': 6, 'A': 6,
'o': 6, 'A': 6,

'p': 7, 'P': 7,
'q': 7, 'Q': 7,
'r': 7, 'R': 7,
's': 7, 'S': 7,

't': 8, 'T': 8,
'u': 8, 'U': 8,
'v': 8, 'V': 8,

'w': 9, 'W': 9,
'x': 9, 'X': 9,
'y': 9, 'Y': 9,
'z': 9, 'Z': 9
}

words_for_numberstrings = {}

wordsfile = open(wordsfilelocation)
for line in wordsfile:
    word = line[:-1]
    letters = list(word)
    def number_of_letter(l):
        if l in numbers_for_letter:
            return str(numbers_for_letter[l])
        else:
            return ''
    numbers = map(number_of_letter, letters)
    numberstring = ''.join(numbers)
    
    if numberstring in words_for_numberstrings:
        words_for_numberstrings[numberstring].append(word.upper())
    else:
        words_for_numberstrings[numberstring] = [word.upper()]
        
wordsfile.close()

class Namespace: pass
def possibles_for_phone(number):
    ns = Namespace()
    ns.results = set([])
    def ppn(prefix, prefixIsWord, number):
        if len(number) == 0:
            ns.results |= set([prefix])
            return
            
        for i in range(1, len(number) + 1):
            pre = number[:i]
            remain = number[i:]
            if pre in words_for_numberstrings:
                for foundword in words_for_numberstrings[pre]:
                    newprefix = prefix + ('-' if not prefixIsWord else '') + foundword + ('-' if remain<>'' else '')
                    ppn(newprefix, True, remain)
            else:
                ppn(prefix + pre, False, remain)
    
    ppn("", True, number)
    return ns.results ^ set([number])

def print_possiblilities_for_phone(number_as_string):
    for result in sorted(possibles_for_phone(number_as_string)):
        print result


print 'just type "exit" to quit'
while True:
    print 'Phone number:',
    input = raw_input()
    if input == 'exit':
        exit()
    number = ''.join(filter((lambda c: c if '0' <= c <= '9' else ''), list(input)))
    print_possiblilities_for_phone(number)
