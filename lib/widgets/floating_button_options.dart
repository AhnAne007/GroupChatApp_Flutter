import 'package:flutter/material.dart';

typedef SaveImagePressed = void Function();

class FloatingOptions extends StatefulWidget {
  const FloatingOptions(
      {Key? key,
        required this.onSearchPressed,
        required this.onGroupCreatePressed})
      : super(key: key);

  final VoidCallback onSearchPressed;
  final VoidCallback onGroupCreatePressed;

  @override
  State<FloatingOptions> createState() => _FloatingOptionsState();
}

class _FloatingOptionsState extends State<FloatingOptions>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _buttonColor;
  bool _isAnimation = false;
  late Animation<double> _animationIcon;
  late Animation<double> _translateButton;
  final Curve _curve = Curves.easeOut;
  late double _fabHeight;

  @override
  void initState() {
    _fabHeight = 56;
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animationIcon = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController);
    _buttonColor = ColorTween(begin: Colors.blue, end: Colors.red).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.0, 0.75, curve: Curves.linear)));
    _translateButton = Tween<double>(begin: _fabHeight, end: -14.0).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Interval(0.0, 0.75, curve: _curve)));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget openSearchScreen() {
    return Visibility(
      child: SizedBox(
        width: 110,
        height: 45,
        child: ElevatedButton.icon(
          onPressed: () {
            widget.onSearchPressed;
          },
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.amberAccent!),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)
                  )
              )
          ),
          icon: const Icon(Icons.search), label: const Text('Search'),
        ),
      ),
    );
  }

  Widget openCreateGroup() {
    return Visibility(
      child: SizedBox(
        width: 110,
        height: 45,
        child: ElevatedButton.icon(
          onPressed: () {
            widget.onGroupCreatePressed;
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)
                  )
              )
          ),
          icon: const Icon(Icons.add), label: const Text('Create Group'),
        ),
      ),
    );
  }

  animate() {
    if (!_isAnimation) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    _isAnimation = !_isAnimation;
  }

  Widget buttonToggle() {
    return FloatingActionButton(
        onPressed: animate,
        backgroundColor: _buttonColor.value,
        child: const  Icon(Icons.add)
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Transform(
          transform:
          Matrix4.translationValues(0.0, _translateButton.value * 2, 0.0),
          child: openSearchScreen(),
        ),
        Transform(
          transform:
          Matrix4.translationValues(0.0, _translateButton.value, 0.0),
          child: openCreateGroup(),
        ),
        buttonToggle()
      ],
    );
  }
}
