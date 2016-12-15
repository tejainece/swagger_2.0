part of jaguar.src.console.swagger;

/// Represents a schema object in the OpenAPI specification.
class APISchemaObject {
  static const String TypeString = "string";
  static const String TypeArray = "array";
  static const String TypeObject = "object";
  static const String TypeNumber = "number";
  static const String TypeInteger = "integer";
  static const String TypeBoolean = "boolean";

  static const String FormatInt32 = "int32";
  static const String FormatInt64 = "int64";
  static const String FormatDouble = "double";
  static const String FormatBase64 = "byte";
  static const String FormatBinary = "binary";
  static const String FormatDate = "date";
  static const String FormatDateTime = "date-time";
  static const String FormatPassword = "password";
  static const String FormatEmail = "email";

  String title;
  String type;
  String format;
  String description;
  String example;
  bool required = true;
  bool readOnly = false;
  bool deprecated = false;
  APISchemaObject items;
  Map<String, APISchemaObject> properties;
  Map<String, APISchemaObject> additionalProperties;

  APISchemaObject({this.properties, this.additionalProperties})
      : type = APISchemaObject.TypeObject;
  APISchemaObject.string() : type = APISchemaObject.TypeString;
  APISchemaObject.int()
      : type = APISchemaObject.TypeInteger,
        format = APISchemaObject.FormatInt32;
  APISchemaObject.fromTypeMirror(TypeMirror m) {
    type = typeFromTypeMirror(m);
    format = formatFromTypeMirror(m);

    if (type == TypeArray) {
      items = new APISchemaObject.fromTypeMirror(m.typeArguments.first);
    } else if (type == TypeObject) {}
  }

  static String typeFromTypeMirror(TypeMirror m) {
    if (m.isSubtypeOf(reflectType(String))) {
      return TypeString;
    } else if (m.isSubtypeOf(reflectType(List))) {
      return TypeArray;
    } else if (m.isSubtypeOf(reflectType(Map))) {
      return TypeObject;
    } else if (m.isSubtypeOf(reflectType(int))) {
      return TypeInteger;
    } else if (m.isSubtypeOf(reflectType(num))) {
      return TypeNumber;
    } else if (m.isSubtypeOf(reflectType(bool))) {
      return TypeBoolean;
    } else if (m.isSubtypeOf(reflectType(DateTime))) {
      return TypeString;
    }

    return null;
  }

  static String formatFromTypeMirror(TypeMirror m) {
    if (m.isSubtypeOf(reflectType(int))) {
      return FormatInt32;
    } else if (m.isSubtypeOf(reflectType(double))) {
      return FormatDouble;
    } else if (m.isSubtypeOf(reflectType(DateTime))) {
      return FormatDateTime;
    }

    return null;
  }

  Map<String, dynamic> asMap() {
    var m = <String, dynamic>{};

    m["type"] = type;
    m["required"] = required;
    m["readOnly"] = readOnly;
    m["deprecated"] = deprecated;

    if (title != null) {
      m["title"] = title;
    }
    if (format != null) {
      m["format"] = format;
    }

    if (description != null) {
      m["description"] = description;
    }

    if (example != null) {
      m["example"] = example;
    }

    if (items != null) {
      m["items"] = items.asMap();
    }
    if (properties != null) {
      m["properties"] = new Map.fromIterable(properties.keys,
          key: (key) => key, value: (key) => properties[key].asMap());
    }
    if (additionalProperties != null) {
      m["additionalProperties"] = new Map.fromIterable(
          additionalProperties.keys,
          key: (key) => key,
          value: (key) => additionalProperties[key].asMap());
    }

    return m;
  }
}
