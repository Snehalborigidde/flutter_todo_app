mixin ValidationMixin {
  String? validateTitle(String value) {
    if (value.isEmpty) {
      return 'Title cannot be empty';
    } else if (value.length < 3) {
      return 'Title must be at least 3 characters long';
    }
    return null;
  }
}
