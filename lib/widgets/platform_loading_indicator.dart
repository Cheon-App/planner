import 'package:cheon/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformLoadingIndicator extends StatelessWidget {
  /// Creates a loading indicator that adheres to the conventional platform
  /// theme
  const PlatformLoadingIndicator({Key key, this.small = false})
      : assert(small != null),
        super(key: key);

  final bool small;

  @override
  Widget build(BuildContext context) {
    return isMaterial(context)
        ? CircularProgressIndicator(
            strokeWidth: small ? 2 : 4,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          )
        : const CupertinoActivityIndicator();
  }
}
