library jaguar.src.console.swagger;

import 'dart:mirrors';

//TODO import 'dart:html';
import 'dart:io';

part 'api_info.dart';
part 'api_operation.dart';
part 'api_schema_object.dart';
part 'contact.dart';
part 'header.dart';
part 'parameter.dart';
part 'path.dart';
part 'request_body.dart';
part 'response.dart';
part 'security.dart';
part 'utils.dart';

/// An object that can be documented into a OpenAPI specification.
///
/// Classes that wish to participate in the documentation process should extend
/// or mixin this class.
///
/// Documentation behavior starts at the root of an application (its [RequestSink])
/// by invoking [documentAPI].
/// The [RequestSink] will invoke methods from this interface on its
/// [RequestSink.initialHandler]. These methods travel down the object graph
/// formed by a [RequestSink], its [Router], [RequestController]s, [AuthServer]
/// and [ManagedObject]s.
///
/// Classes that extend this class will override methods such as [documentPaths]
/// and [documentOperations] if they have the information available to complete
/// those requests. Any method from this interface that a subclasses does not
/// override will automatically be forwarded on to its [documentableChild].
/// Thus, subclasses should override [documentableChild] to return the 'next'
/// documentable item in their logical flow. For [RequestController]s, this will
/// be their 'next' handler.
class APIDocumentable {
  /// Returns the next documentable object in a chain of documentable objects.
  ///
  /// If this instance does not have the information to return a value from the
  /// other methods in this interface, it will forward on that method to this property.
  APIDocumentable get documentableChild => null;

  /// Returns an entire [APIDocument] describing an OpenAPI specification.
  ///
  /// This method is typically invoked on a [RequestSink]. This method is invoked
  /// on root of documentable chain, [RequestSink].
  APIDocument documentAPI(PackagePathResolver resolver) =>
      documentableChild?.documentAPI(resolver);

  /// Returns all [APIPath] objects this instance knows about.
  ///
  /// This method is implemented by [Router].
  List<APIPath> documentPaths(PackagePathResolver resolver) =>
      documentableChild?.documentPaths(resolver);

  /// Returns all [APIOperation]s this object knows about.
  List<APIOperation> documentOperations(PackagePathResolver resolver) =>
      documentableChild?.documentOperations(resolver);

  /// Returns all [APIResponse]s for [operation].
  List<APIResponse> documentResponsesForOperation(APIOperation operation) =>
      documentableChild?.documentResponsesForOperation(operation);

  /// Returns all [APIRequestBody]s for [operation].
  APIRequestBody documentRequestBodyForOperation(APIOperation operation) =>
      documentableChild?.documentRequestBodyForOperation(operation);

  /// Returns all [APISecurityScheme]s this instance knowsa bout.
  Map<String, APISecurityScheme> documentSecuritySchemes(
          PackagePathResolver resolver) =>
      documentableChild?.documentSecuritySchemes(resolver);
}

/// Represents an OpenAPI specification.
class APIDocument {

  /// Provides metadata about the API
  APIInfo info = new APIInfo();

  /// The host (name or ip) serving the API
  List<APIHost> hosts = [];

  String basePath = "";

  List<String> schemes = [];

  List<ContentType> consumes = [];

  List<ContentType> produces = [];

  List<APIPath> paths = [];

  List<APISecurityRequirement> securityRequirements = [];

  Map<String, APISecurityScheme> securitySchemes = {};

  Map<String, dynamic> asMap({String version: "2.0"}) {
    var m = <String, dynamic>{};

    if (version.startsWith("2.")) {
      m["swagger"] = version;
    } else {
      m["openapi"] = version;
    }
    m["info"] = info.asMap();

    if (version.startsWith("2.")) {
      if (hosts.length > 0) {
        m["host"] = hosts.first.host;
      }
    } else {
      m["hosts"] = hosts.map((host) => host.asMap()).toList();
    }

    m["basePath"] = basePath;
    m["schemes"] = schemes;

    m["consumes"] = consumes.map((ct) => ct.toString()).toList();
    m["produces"] = produces.map((ct) => ct.toString()).toList();
    m["security"] = securityRequirements.map((sec) => sec.name).toList();
    m["paths"] = new Map.fromIterable(paths,
        key: (APIPath k) => k.path, value: (APIPath v) => v.asMap());

    var mappedSchemes = {};
    securitySchemes?.forEach((k, scheme) {
      mappedSchemes[k] = scheme.asMap();
    });
    m["securityDefinitions"] = mappedSchemes;

    return m;
  }
}
