class Winner {
  final String? name;
  final String? phone;
  final String? id;
  final String? defaultMessage;

  Winner({this.id, this.name, this.phone, this.defaultMessage});

  factory Winner.fromjson(Map json) {
    return Winner(
        id: json['id'],
        name: json['name'],
        phone: json['phone'],
        defaultMessage: json['default'] ?? '');
  }

  String getMessage(String role, String userId) {
    String message = 'testing';

    if (defaultMessage != null && defaultMessage!.isNotEmpty) {
      return defaultMessage!;
    }
    if (role == "admin") {
      message =
          "Hongera $name mwenye nambari $phone ameshinda zawadi iliyowekwa";
    } else if (id == userId) {
      message = "Hongera umeshinda zawadi iliyowekwa";
    } else {
      message = "Hongera $name ameshinda zawadi iliyowekwa";
    }

    return message;
  }

  Map<String, dynamic> tojson() {
    return {"id": id, "phone": phone, "name": name, "default": defaultMessage};
  }

  factory Winner.addDefaultMessage(String message) {
    return Winner(defaultMessage: message);
  }
}
