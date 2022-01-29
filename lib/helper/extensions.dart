extension StringCasingExtension on String {
  String append(String? appendix) => this + (appendix ?? '');

  String toCapitalized() =>
      this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
}