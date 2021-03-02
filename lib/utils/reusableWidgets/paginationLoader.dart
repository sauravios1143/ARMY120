import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaginationLoader extends StatelessWidget {
  final ValueNotifier<bool> loaderNotifier;

  PaginationLoader({@required this.loaderNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: loaderNotifier,
      builder: (context, value, _) {
        print("snpashot:${value}");
        return Offstage(
          offstage: !value ?? true,
          child: Center(
            child: CupertinoActivityIndicator(
              radius: 15,
            ),
          ),
        );
      },
    );
  }
}
