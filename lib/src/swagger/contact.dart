part of jaguar.src.console.swagger;

/// Represents contact information in the OpenAPI specification.
class APIContact {
  String name = "default";
  String url = "http://localhost";
  String email = "default";

  Map<String, String> asMap() {
    return {"name": name, "url": url, "email": email};
  }
}

/// Represents a copyright/open source license in the OpenAPI specification.
class APILicense {
  String name = "default";
  String url = "http://localhost";

  Map<String, String> asMap() {
    return {"name": name, "url": url};
  }
}

/// Represents a web server host in the OpenAPI specification.
class APIHost {
  String host = "localhost:8000";
  String basePath = "/";
  String scheme = "http";

  Uri get uri {
    return new Uri(scheme: scheme, host: host, path: basePath);
  }

  Map<String, String> asMap() {
    return {"host": host, "basePath": basePath, "scheme": scheme};
  }
}