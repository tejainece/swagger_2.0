part of jaguar.src.console.swagger;

/// Represents a header type in the OpenAPI specification.
enum APIHeaderType { string, number, integer, boolean }

/// Represents a header in the OpenAPI specification.
class APIHeader {
  String description;
  APIHeaderType type;

  static String headerTypeStringForType(APIHeaderType type) {
    switch (type) {
      case APIHeaderType.string:
        return "string";
      case APIHeaderType.number:
        return "number";
      case APIHeaderType.integer:
        return "integer";
      case APIHeaderType.boolean:
        return "boolean";
    }
    return null;
  }

  Map<String, dynamic> asMap() {
    return {"description": description, "type": headerTypeStringForType(type)};
  }
}