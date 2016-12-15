part of jaguar.src.console.swagger;

/// Provides metadata about the API
///
/// https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md#infoObject
class APIInfo {
  /// The title of the application
  String title = "API";

  /// A short description of the application. GFM syntax can be used for rich
  /// text representation.
  String description = "Description";

  /// The Terms of Service for the API
  String termsOfServiceURL = "";

  /// The contact information for the exposed API
  APIContact contact = new APIContact();

  /// The license information for the exposed API
  APILicense license = new APILicense();

  /// Provides the version of the application API (not to be confused with the
  /// specification version)
  String version = "1.0";

  /// Returns [Map] containing fields of the [APIInfo] object
  Map<String, dynamic> asMap() {
    return _stripNull({
      "title": title,
      "description": description,
      "version": version,
      "termsOfService": termsOfServiceURL,
      "contact": contact.asMap(),
      "license": license.asMap()
    });
  }
}
