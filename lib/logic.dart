class Logic {

  static final Map<String, String> _complementMap = {
    'A': 'T',
    'T': 'A',
    'C': 'G',
    'G': 'C',
  };

  static String reversecomplementDNA(String sequence) {
    return sequence
        .split('')
        .toList()
        .reversed
        .map((nucleotide) {
      return _complementMap[nucleotide];
    }).join();
  }

  static String reverseDNA(String sequence) {
    return sequence
        .split('')
        .reversed
        .join();
  }

  static String complementDNA(String sequence) {
    return sequence.split('').toList().map((nucleotide) {
      return _complementMap[nucleotide];
    }).join();
  }


}