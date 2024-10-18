String latinToCyrillic(String input) {
  Map<String, String> mapping = {
    'A': 'А',
    'B': 'Б',
    'D': 'Д',
    'E': 'Е',
    'F': 'Ф',
    'G': 'Г',
    'H': 'Ҳ',
    'I': 'И',
    'J': 'Ж',
    'K': 'К',
    'L': 'Л',
    'M': 'М',
    'N': 'Н',
    'O': 'О',
    'P': 'П',
    'Q': 'Қ',
    'R': 'Р',
    'S': 'С',
    'T': 'Т',
    'U': 'У',
    'V': 'В',
    'X': 'Х',
    'Y': 'Й',
    'Z': 'З',
    'O\'': 'Ў',
    'G\'': 'Ғ',
    'Sh': 'Ш',
    'Ch': 'Ч',
    'Ng': 'нг',
    'Ya': 'Я',
    'Yu': 'Ю',
    'Yo': 'Ё',
    '‘': 'ъ',

    ///
    'a': 'а',
    'b': 'б',
    'd': 'д',
    'e': 'е',
    'f': 'ф',
    'g': 'г',
    'h': 'ҳ',
    'i': 'и',
    'j': 'ж',
    'k': 'к',
    'l': 'л',
    'm': 'м',
    'n': 'н',
    'o': 'о',
    'p': 'п',
    'q': 'қ',
    'r': 'р',
    's': 'с',
    't': 'т',
    'u': 'у',
    'v': 'в',
    'x': 'х',
    'y': 'й',
    'z': 'з',
    'o\'': 'ў',
    'g\'': 'ғ',
    'sh': 'ш',
    'ch': 'ч',
    'ng': 'нг',
    'ya': 'я',
    'yu': 'ю',
    'yo': 'ё',
    '’': 'ъ',
  };

  String output = '';
  int i = 0;

  while (i < input.length) {
    String letter = input[i];
    String nextLetter = i + 1 < input.length ? input[i + 1] : '';

    String twoLetters = letter + nextLetter;

    if (mapping.containsKey(twoLetters)) {
      output += mapping[twoLetters] ?? "";
      i += 2;
    } else if (mapping.containsKey(letter)) {
      output += mapping[letter] ?? '';
      i += 1;
    } else {
      output += letter;
      i += 1;
    }
  }

  return output;
}

//
String cyrillicToLatin(String input) {
  Map<String, String> mapping = {
    'А': 'A',
    'Б': 'B',
    'Д': 'D',
    'Е': 'E',
    'Ф': 'F',
    'Г': 'G',
    'Ҳ': 'H',
    'И': 'I',
    'Ж': 'J',
    'К': 'K',
    'Л': 'L',
    'М': 'M',
    'Н': 'N',
    'О': 'O',
    'П': 'P',
    'Қ': 'Q',
    'Р': 'R',
    'С': 'S',
    'Т': 'T',
    'У': 'U',
    'В': 'V',
    'Х': 'X',
    'Й': 'Y',
    'З': 'Z',
    'Ў': "O'",
    'Ғ': "G'",
    'Ш': 'Sh',
    'Ч': 'Ch',
    'Нг': 'Ng',
    'Я': 'Ya',
    'Ю': 'Yu',
    'Ё': 'Yo',
    'Э': 'E',
    'Ы': 'I',
    'Ъ': '’',

    ///
    'а': 'a',
    'б': 'b',
    'д': 'd',
    'е': 'e',
    'ф': 'f',
    'г': 'g',
    'ҳ': 'h',
    'и': 'i',
    'ж': 'j',
    'к': 'k',
    'л': 'l',
    'м': 'm',
    'н': 'n',
    'о': 'o',
    'п': 'p',
    'қ': 'q',
    'р': 'r',
    'с': 's',
    'т': 't',
    'у': 'u',
    'в': 'v',
    'х': 'x',
    'й': 'y',
    'з': 'z',
    'ў': "o'",
    'ғ': "g'",
    'ш': 'sh',
    'ч': 'ch',
    'нг': 'ng',
    'я': 'ya',
    'ю': 'yu',
    'ё': 'yo',
    'ъ': '’',
    'э': 'e',
    'ы': 'i',
  };

  String output = '';
  int i = 0;

  while (i < input.length) {
    String letter = input[i];
    String nextLetter = (i + 1) < input.length ? input[i + 1] : '';

    String twoLetters = letter + nextLetter;

    if (mapping.containsKey(twoLetters)) {
      output += mapping[twoLetters] ?? "";
      i += 2;
    } else if (mapping.containsKey(letter)) {
      output += mapping[letter] ?? '';
      i += 1;
    } else {
      output += letter;
      i += 1;
    }
  }

  return output;
}
