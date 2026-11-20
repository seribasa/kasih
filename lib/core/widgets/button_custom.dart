import 'package:flutter/material.dart';

class ButtonCustom extends StatelessWidget {
  final Widget child;
  final Function? onPressed;
  final bool loading;
  const ButtonCustom({
    Key? key,
    required this.child,
    required this.onPressed,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isEnable = onPressed != null || loading;
    return Container(
      width: double.infinity,
      decoration:
          isEnable
              ? BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.zero,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey.shade200,
                    offset: const Offset(4, 2),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              )
              : BoxDecoration(color: Colors.grey[300]),
      child: TextButton(
        onPressed: !loading ? onPressed as void Function()? : null,
        child:
            loading
                ? SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : child,
      ),
    );
  }
}
