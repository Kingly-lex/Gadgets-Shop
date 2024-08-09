extension Formatter on double {
  String addComma() {
    String formattedPrice = toStringAsFixed(2); // Ensure two decimal places

    List<String> parts = formattedPrice.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    String result = '';
    int count = 0;

    for (int i = integerPart.length - 1; i >= 0; i--) {
      result = integerPart[i] + result;
      count++;
      if (count % 3 == 0 && i != 0) {
        result = ',$result';
      }
    }

    return 'N$result$decimalPart';
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
