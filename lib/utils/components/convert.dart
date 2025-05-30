class NumberToWords {
  static final List<String> _units = [
    "Zero",
    "One",
    "Two",
    "Three",
    "Four",
    "Five",
    "Six",
    "Seven",
    "Eight",
    "Nine",
    "Ten",
    "Eleven",
    "Twelve",
    "Thirteen",
    "Fourteen",
    "Fifteen",
    "Sixteen",
    "Seventeen",
    "Eighteen",
    "Nineteen"
  ];

  static final List<String> _tens = [
    "",
    "",
    "Twenty",
    "Thirty",
    "Forty",
    "Fifty",
    "Sixty",
    "Seventy",
    "Eighty",
    "Ninety"
  ];

  static String convert(int number) {
    if (number < 20) {
      return _units[number];
    } else if (number < 100) {
      return _tens[number ~/ 10] +
          (number % 10 != 0 ? " ${_units[number % 10]}" : "");
    } else if (number < 1000) {
      return "${_units[number ~/ 100]} Hundred${number % 100 != 0 ? " and ${convert(number % 100)}" : ""}";
    } else if (number < 1000000) {
      return "${convert(number ~/ 1000)} Thousand${number % 1000 != 0 ? " ${convert(number % 1000)}" : ""}";
    } else if (number < 1000000000) {
      return "${convert(number ~/ 1000000)} Million${number % 1000000 != 0 ? " ${convert(number % 1000000)}" : ""}";
    } else {
      return "${convert(number ~/ 1000000000)} Billion${number % 1000000000 != 0 ? " ${convert(number % 1000000000)}" : ""}";
    }
  }
}
