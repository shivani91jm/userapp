import 'package:demandium/components/core_export.dart';

class CustomPopScopeWidget extends StatefulWidget {
  final Widget child;
  final Function()? onPopInvoked;
  const CustomPopScopeWidget({super.key, required this.child, this.onPopInvoked}) ;

  @override
  State<CustomPopScopeWidget> createState() => _CustomPopScopeWidgetState();
}

class _CustomPopScopeWidgetState extends State<CustomPopScopeWidget> {

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: ResponsiveHelper.isWeb() ? true : Navigator.canPop(context),
      onPopInvoked: (didPop) {
        if(widget.onPopInvoked != null) {
          widget.onPopInvoked!();
        }
      },
      child: widget.child,
    );
  }
}