part of jaguar.src.console.swagger;

/// Utility to find source files.
class PackagePathResolver {
  PackagePathResolver(String packageMapPath) {
    var contents = new File(packageMapPath).readAsStringSync();
    var lines = contents
        .split("\n")
        .where((l) => !l.startsWith("#") && l.indexOf(":") != -1)
        .map((l) {
      var firstColonIdx = l.indexOf(":");
      var packageName = l.substring(0, firstColonIdx);
      var packagePath =
          l.substring(firstColonIdx + 1, l.length).replaceFirst(r"file://", "");
      return [packageName, packagePath];
    });
    _map =
        new Map.fromIterable(lines, key: (k) => k.first, value: (v) => v.last);
  }

  Map<String, String> _map;

  String resolve(Uri uri) {
    if (uri.scheme == "package") {
      var firstElement = uri.pathSegments.first;
      var packagePath = _map[firstElement];
      if (packagePath == null) {
        throw new Exception("Package $firstElement could not be resolved.");
      }

      var remainingPath = uri.pathSegments.sublist(1).join("/");
      return "$packagePath$remainingPath";
    }
    return uri.path;
  }
}

Map<String, dynamic> _stripNull(Map<String, dynamic> m) {
  var outMap = <String, dynamic>{};
  m.forEach((k, v) {
    if (v != null) {
      outMap[k] = v;
    }
  });
  return outMap;
}
