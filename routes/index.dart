import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

int _count = 0;
Map _todos = {};
List<int> _myList = [];

FutureOr<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.post:
      return _post(
        context,
      );
    case HttpMethod.get:
      return _get(context);

    case HttpMethod.delete:
    // return _delete(context);
    case HttpMethod.put:
    // return _put(context);
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context) async {
  return Response.json(body: {'success': true, 'message': _todos});
}

Future<Response> _post(
  RequestContext context,
) async {
  final request = context.request;
  try {
    final body = await request.body();
    final bodyData = jsonDecode(body);

    if (bodyData['name'] == null) {
      return Response.json(
          body: {'success': false, 'message': 'name is needed'});
    } else {
      final count = context.read<int>();
      _todos[count.toString()] = {'name': bodyData['name']};
      return Response.json(
          body: {'success': true, 'message': _todos[count.toString()]});
    }
  } catch (e) {
    return Response.json(body: {'success': false, 'message': e.toString()});
  }
}
