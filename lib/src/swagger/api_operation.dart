part of jaguar.src.console.swagger;

/// Represents a HTTP operation (a path/method pair) in the OpenAPI specification.
class APIOperation {
  String method;

  String summary = "";
  String description = "";
  String id;
  bool deprecated = false;

  List<String> tags = [];
  List<ContentType> consumes = [];
  List<ContentType> produces = [];
  List<APIParameter> parameters = [];
  List<APISecurityRequirement> security = [];
  APIRequestBody requestBody;
  List<APIResponse> responses = [];

  Map<String, dynamic> get _requestBodyParameterMap {
    var param = new APIParameter();
    param.schemaObject = requestBody.schema;
    param.description = requestBody.description;
    param.name = "Body";
    param.deprecated = false;
    param.parameterLocation = APIParameterLocation.body;
    param.required = true;
    return param.asMap();
  }

  static String idForMethod(Object classInstance, Symbol methodSymbol) {
    return "${MirrorSystem.getName(reflect(classInstance).type.simpleName)}.${MirrorSystem.getName(methodSymbol)}";
  }

  static Symbol symbolForID(String operationId, Object classInstance) {
    var components = operationId.split(".");
    if (components.length != 2 ||
        components.first !=
            MirrorSystem.getName(reflect(classInstance).type.simpleName)) {
      return null;
    }

    return new Symbol(components.last);
  }

  Map<String, dynamic> asMap() {
    var m = <String, dynamic>{};

    m["summary"] = summary;
    m["description"] = description;
    m["id"] = id;
    m["deprecated"] = deprecated;
    m["tags"] = tags;
    m["consumes"] = consumes.map((ct) => ct.toString()).toList();
    m["produces"] = produces.map((ct) => ct.toString()).toList();
    m["parameters"] = parameters.map((param) => param.asMap()).toList();
    if (requestBody != null) {
      m["parameters"].add(_requestBodyParameterMap);
    }

    m["responses"] = new Map.fromIterable(responses,
        key: (APIResponse k) => k.key, value: (APIResponse v) => v.asMap());
    m["security"] = security.map((req) => req.asMap()).toList();

    // m["requestBody"] = requestBody?.asMap();

    return _stripNull(m);
  }
}