part of jaguar.src.console.swagger;

/// Represents a security requirement in the OpenAPI specification.
class APISecurityRequirement {
  String name;
  List<APISecurityScope> scopes;

  Map<String, dynamic> asMap() {
    return {name: scopes};
  }
}

/// Represents a security scope in the OpenAPI specification.
class APISecurityScope {
  String name;
  String description;

  Map<String, String> asMap() {
    return {name: description};
  }
}

/// Represents a security definition in the OpenAPI specification.
class APISecurityDefinition {
  String name;
  APISecurityScheme scheme;

  Map<String, dynamic> asMap() => scheme.asMap();
}

/// Represents a OAuth 2.0 security scheme flow in the OpenAPI specification.
enum APISecuritySchemeFlow { implicit, password, application, accessCode }

/// Represents a security scheme in the OpenAPI specification.
class APISecurityScheme {
  static String stringForFlow(APISecuritySchemeFlow flow) {
    switch (flow) {
      case APISecuritySchemeFlow.accessCode:
        return "accessCode";
      case APISecuritySchemeFlow.password:
        return "password";
      case APISecuritySchemeFlow.implicit:
        return "implicit";
      case APISecuritySchemeFlow.application:
        return "application";
    }
    return null;
  }

  APISecurityScheme.basic() {
    type = "basic";
  }

  APISecurityScheme.apiKey() {
    type = "apiKey";
  }

  APISecurityScheme.oauth2() {
    type = "oauth2";
  }

  String type;
  String description;

  // API Key
  String apiKeyName;
  APIParameterLocation apiKeyLocation;

  // Oauth2
  APISecuritySchemeFlow oauthFlow;
  String authorizationURL;
  String tokenURL;
  List<APISecurityScope> scopes = [];

  bool get isOAuth2 {
    return type == "oauth2";
  }

  Map<String, dynamic> asMap() {
    var m = <String, dynamic>{"type": type, "description": description};

    if (type == "basic") {
      /* nothing to do */
    } else if (type == "apiKey") {
      m["name"] = apiKeyName;
      m["in"] = APIParameter.parameterLocationStringForType(apiKeyLocation);
    } else if (type == "oauth2") {
      m["flow"] = stringForFlow(oauthFlow);

      if (oauthFlow == APISecuritySchemeFlow.implicit ||
          oauthFlow == APISecuritySchemeFlow.accessCode) {
        m["authorizationUrl"] = authorizationURL;
      }

      if (oauthFlow != APISecuritySchemeFlow.implicit) {
        m["tokenUrl"] = tokenURL;
      }

      m["scopes"] = new Map.fromIterable(scopes,
          key: (APISecurityScope k) => k.name,
          value: (APISecurityScope v) => v.description);
    }

    return m;
  }
}
