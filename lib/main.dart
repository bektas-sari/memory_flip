import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MemoryFlipApp());

class MemoryFlipApp extends StatelessWidget {
  const MemoryFlipApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Flip',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6C63FF),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontWeight: FontWeight.w800),
          titleLarge: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      home: const GamePage(),
    );
  }
}

class CardItem {
  final String emoji;
  bool revealed;
  bool matched;
  CardItem(this.emoji, {this.revealed = false, this.matched = false});
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final rnd = Random();
  late List<CardItem> _cards;
  int _moves = 0;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() {
    const base = ['🐶','🐱','🦊','🐵','🦄','🐸','🐼','🐯']; // 8 çift = 16 kart
    final deck = [...base, ...base]..shuffle(rnd);
    _cards = deck.map((e) => CardItem(e)).toList();
    _moves = 0;
    _busy = false;
    setState(() {});
  }

  Future<void> _onTap(int index) async {
    if (_busy) return;
    final card = _cards[index];
    if (card.matched || card.revealed) return;

    setState(() => card.revealed = true);

    final open = _cards.where((c) => c.revealed && !c.matched).toList();
    if (open.length == 2) {
      _busy = true;
      _moves++;
      await Future.delayed(const Duration(milliseconds: 600));
      if (open[0].emoji == open[1].emoji) {
        setState(() {
          open[0].matched = true;
          open[1].matched = true;
        });
      } else {
        setState(() {
          open[0].revealed = false;
          open[1].revealed = false;
        });
      }
      _busy = false;

      if (_cards.every((c) => c.matched)) {
        await Future.delayed(const Duration(milliseconds: 300));
        if (!mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => _WinDialog(moves: _moves, onRestart: _reset),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final gridPadding = size.width < 500 ? 12.0 : 18.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const _FancyBackground(),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Memory Flip',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _Pill(text: 'Hamle: $_moves'),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        onPressed: _reset,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Yeniden'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 520),
                      padding: EdgeInsets.all(gridPadding),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.14),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.white.withOpacity(.35)),
                        boxShadow: const [BoxShadow(blurRadius: 24, color: Colors.black26)],
                      ),
                      child: LayoutBuilder(
                        builder: (context, c) {
                          final side = (c.maxWidth - gridPadding * 2) / 4;
                          return GridView.builder(
                            itemCount: _cards.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10,
                            ),
                            itemBuilder: (_, i) {
                              final item = _cards[i];
                              return _FlipCard(
                                size: side,
                                revealed: item.revealed || item.matched,
                                matched: item.matched,
                                front: Center(child: Text(item.emoji, style: TextStyle(fontSize: side * .55))),
                                onTap: () => _onTap(i),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FlipCard extends StatelessWidget {
  final double size;
  final bool revealed;
  final bool matched;
  final Widget front;
  final VoidCallback onTap;

  const _FlipCard({
    required this.size,
    required this.revealed,
    required this.matched,
    required this.front,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final back = Icon(Icons.question_mark_rounded, size: size * .45, color: Colors.white);
    final baseColor = matched ? Colors.greenAccent : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        transitionBuilder: (child, anim) {
          final rotate = Tween(begin: pi, end: 0.0).animate(anim);
          return AnimatedBuilder(
            animation: rotate,
            builder: (_, __) {
              final isUnder = (ValueKey(revealed) != child.key);
              final tilt = (anim.value - .5).abs() - .5; // hafif perspektif
              final value = isUnder ? min(rotate.value, pi / 2) : rotate.value;
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(value)
                  ..rotateZ(tilt * 0.05),
                child: child,
              );
            },
          );
        },
        layoutBuilder: (currentChild, previousChildren) => Stack(
          alignment: Alignment.center,
          children: [if (currentChild != null) currentChild, ...previousChildren],
        ),
        child: Container(
          key: ValueKey(revealed),
          decoration: BoxDecoration(
            color: revealed ? baseColor : Colors.black.withOpacity(.18),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: revealed ? Colors.black12 : Colors.white.withOpacity(.3),
              width: 1.2,
            ),
            boxShadow: const [BoxShadow(blurRadius: 14, color: Colors.black26, offset: Offset(0, 6))],
          ),
          alignment: Alignment.center,
          child: AnimatedScale(
            scale: revealed ? 1.0 : 0.95,
            duration: const Duration(milliseconds: 200),
            child: revealed ? front : back,
          ),
        ),
      ),
    );
  }
}

class _WinDialog extends StatelessWidget {
  final int moves;
  final VoidCallback onRestart;
  const _WinDialog({required this.moves, required this.onRestart});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tebrikler! 🎉'),
      content: Text('Tüm eşleşmeleri buldun.\nToplam hamle: $moves'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Kapat'),
        ),
        FilledButton.icon(
          onPressed: () {
            Navigator.pop(context);
            onRestart();
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Yeniden oyna'),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.85),
        borderRadius: BorderRadius.circular(100),
        boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}

class _FancyBackground extends StatelessWidget {
  const _FancyBackground();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF23A6D5), Color(0xFF23D5AB)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
      ),
    );
  }
}
