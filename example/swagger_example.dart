// Copyright (c) 2016, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:swagger/swagger.dart';
import 'dart:io';
import 'package:yamlicious/yamlicious.dart';

main(List<String> args) {
  APIDocument doc = new APIDocument();
  doc.info.description =
      "Example API to swagger generation capabilities of Jaguar-dart";
  doc.info.title = "Sample swagger generation";
  doc.info.termsOfServiceURL = "All rights reserved!";
  doc.info.contact.email = "tejaience@gmail.com";
  doc.info.contact.name = "Ravi Teja Gudapati";
  doc.info.contact.url = "jaguar-dart.github.io";

  {
    APIHost host = new APIHost();
    doc.hosts.add(host);
  }

  doc.basePath = "/";

  doc.schemes.addAll(['http', 'https']);

  doc.consumes.add(ContentType.JSON);
  doc.produces.add(ContentType.JSON);

  {
    APIPath path = new APIPath();
    path.path = "/user";
    APIOperation op = new APIOperation();
    op.method = 'GET';

    op.consumes.add(ContentType.JSON);
    op.produces.add(ContentType.JSON);
    {
      APIParameterInlined param = new APIParameterInlined();
      param.name = "id";
      param.type = APISchemaObject.TypeInteger;
      param.parameterLocation = APIParameterLocation.path;
      op.parameters.add(param);
    }

    path.operations.add(op);
    doc.paths.add(path);
  }

  print(toYamlString(doc.asMap()));
}
