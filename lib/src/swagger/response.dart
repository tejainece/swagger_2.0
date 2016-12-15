part of jaguar.src.console.swagger;

/// Represents an HTTP response in the OpenAPI specification.
class APIResponse {
  String key;
  String description = "";
  APISchemaObject schema;
  Map<String, APIHeader> headers = {};

  int get statusCode {
    if (key == null || key == "default") {
      return null;
    }
    return int.parse(key);
  }

  void set statusCode(int code) {
    key = "$code";
  }

  Map<String, dynamic> asMap() {
    var mappedHeaders = {};
    headers.forEach((headerName, headerObject) {
      mappedHeaders[headerName] = headerObject.asMap();
    });

    return _stripNull({
      "description": description,
      "schema": schema?.asMap(),
      "headers": mappedHeaders
    });
  }
}
