import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final Widget page;

  AnimatedButton({@required this.page});

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin{
  double scale;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.1
    )..addListener(() {
      setState(() {});
      }
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _onTapDown(TapDownDetails details){
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details){
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    scale  = 1 - _controller.value;

    return GestureDetector(
      onTap: () {

      },
      onTapUp: _onTapUp,
      onTapDown: _onTapDown,
      child: Transform.scale(
        scale: scale,
        child: _animatedButtonUI,
      ),
    );
  }

  Widget get _animatedButtonUI =>
      Container(
        height: 40,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Color(0x80000000),
              blurRadius: 30.0,
              offset: Offset(0.0, 30.0)
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFF9844),
              Color(0xFFFE8853),
              Color(0xFFFD7267),
            ]
          ),
        ),
        child: Center(
          child: Text('Proceed',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Colors.white
            ),
          ),
        ),
      );
}

class HighLightedIcon extends StatefulWidget {
  final IconData icon;
  final double size;
  final Color color;

  HighLightedIcon(
      this.icon, {
        Key key,
        this.size = 24.0,
        this.color,
      })
      : super(key: key);
  @override
  State<HighLightedIcon> createState() {
    return new _AnimatedIconState();
  }
}

class _AnimatedIconState extends State<HighLightedIcon>
    with SingleTickerProviderStateMixin {
  final double dx = 4.0;
  AnimationController controller;
  Animation<double> animation;

  @override
  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    animation = new Tween(begin: widget.size, end: widget.size + dx)
        .animate(controller);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        new Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;
          controller?.forward();
        });
      }
    });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new _Animator(
      icon: widget.icon,
      animation: animation,
      color: widget.color,
      size: widget.size + dx,
    );
  }
}

class _Animator extends AnimatedWidget {
  final double size;
  final IconData icon;
  final Color color;
  _Animator({
    Key key,
    this.icon,
    this.size,
    this.color,
    Animation<double> animation,
  })
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return new Container(
      width: size,
      height: size,
      child: new Center(
        child: new Icon(
          icon,
          size: animation.value,
          color: color,
        ),
      ),
    );
  }
}