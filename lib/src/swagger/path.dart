part of jaguar.src.console.swagger;

/// Represents a path (also known as a route) in the OpenAPI specification.
class APIPath {
  String path;

  String summary = "";

  String description = "";

  /// A list of definitions of operations on this path
  List<APIOperation> operations = [];

  List<APIParameter> parameters = [];

  Map<String, dynamic> asMap() {
    Map<String, dynamic> i = {};

    operations.forEach((op) {
      i[op.method] = op.asMap();
    });
    i["parameters"] = parameters.map((api) => api.asMap()).toList();

    return i;
  }
}
