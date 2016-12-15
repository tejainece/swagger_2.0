part of jaguar.src.console.swagger;

/// Represents a parameter location in the OpenAPI specification.
enum APIParameterLocation { query, header, path, formData, cookie, body }

/// Represents a parameter in the OpenAPI specification.
class APIParameter {
  static String parameterLocationStringForType(
      APIParameterLocation parameterLocation) {
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

  String name;
  String description = "";
  bool required = false;
  bool deprecated = false;
  APISchemaObject schemaObject;
  APIParameterLocation parameterLocation;

  Map<String, dynamic> asMap() {
    var m = <String, dynamic>{};
    m["name"] = name;
    m["description"] = description;
    m["required"] =
        (parameterLocation == APIParameterLocation.path ? true : required);
    m["deprecated"] = deprecated;
    m["schema"] = schemaObject?.asMap();
    m["in"] = parameterLocationStringForType(parameterLocation);

    return _stripNull(m);
  }
}
