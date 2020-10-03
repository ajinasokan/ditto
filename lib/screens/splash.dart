import 'package:ditto/app.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return NotifyOn(
      mutations: {
        LoadStore: (_, __) async {
          Navigator.of(context)
              .pushReplacement(_NoTransitionRoute(builder: (_) => Main()));
        }
      },
      child: Container(color: Theme.of(context).scaffoldBackgroundColor),
    );
  }
}

class _NoTransitionRoute extends CupertinoPageRoute {
  _NoTransitionRoute({builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
}
