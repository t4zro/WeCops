class SlideUpPageRoute extends PageRouteBuilder {
  final Widget page;

  SlideUpPageRoute(this.page)
      : super(
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, anim, __, child) {
            return SlideTransition(
              position: Tween(begin: const Offset(0, 1), end: Offset.zero)
                  .animate(anim),
              child: child,
            );
          },
        );
}
