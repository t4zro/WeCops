class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }

    if (!value.contains("@")) {
      return "Invalid email";
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.length < 6) {
      return "Password must be at least 6 characters";
    }

    return null;
  }

  static String? requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Required";
    }

    return null;
  }
}
