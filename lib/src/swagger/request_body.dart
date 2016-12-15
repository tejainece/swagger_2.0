part of jaguar.src.console.swagger;

/// Represents a request body in the OpenAPI specification.
class APIRequestBody {
  String description;
  APISchemaObject schema;
  bool required = true;

  Map<String, dynamic> asMap() {
    return {
      "description": description,
      "schema": schema.asMap(),
      "required": required
    };
  }
}
