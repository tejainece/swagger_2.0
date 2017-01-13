part of jaguar.src.console.swagger;

/// Represents a parameter location in the OpenAPI specification.
enum APIParameterLocation { query, header, path, formData, cookie, body }

String parameterLocationStringForType(APIParameterLocation parameterLocation) {
  switch (parameterLocation) {
    case APIParameterLocation.query:
      return "query";
    case APIParameterLocation.header:
      return "header";
    case APIParameterLocation.path:
      return "path";
    case APIParameterLocation.formData:
      return "formData";
    case APIParameterLocation.cookie:
      return "cookie";
    case APIParameterLocation.body:
      return "body";
  }
  return null;
}

class APIParameter {
  String name;
  String description = "";
  bool required = false;
  bool deprecated = false;
  APIParameterLocation parameterLocation;

  Map<String, dynamic> asMap() {
    var m = <String, dynamic>{};
    m["name"] = name;
    m["description"] = description;
    m["required"] =
        (parameterLocation == APIParameterLocation.path ? true : required);
    if (deprecated) m["deprecated"] = deprecated;
    m["in"] = parameterLocationStringForType(parameterLocation);

    return _stripNull(m);
  }
}

class APIParameterInlined extends APIParameter {
  String type;
  String format;

  Map<String, dynamic> asMap() {
    final m = super.asMap();
    m["type"] = type;
    m["format"] = format;

    return _stripNull(m);
  }
}

/// Represents a parameter in the OpenAPI specification.
class APIParameterRefed extends APIParameter {
  APISchemaObject schemaObject;

  Map<String, dynamic> asMap() {
    final m = super.asMap();
    m["schema"] = schemaObject?.asMap();

    return _stripNull(m);
  }
}
