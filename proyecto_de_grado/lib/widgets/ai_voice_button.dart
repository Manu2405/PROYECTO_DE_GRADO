import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/theme/app_theme.dart';

class AiVoiceButton extends StatefulWidget {
  final VoidCallback onTap;

  const AiVoiceButton({super.key, required this.onTap});

  @override
  State<AiVoiceButton> createState() => _AiVoiceButtonState();
}

class _AiVoiceButtonState extends State<AiVoiceButton> with SingleTickerProviderStateMixin {
  bool _isListening = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
      if (_isListening) {
        _pulseController.repeat(reverse: true);
        widget.onTap();
        // Simulate a timeout where the AI finishes listening after 5 seconds
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted && _isListening) {
            _toggleListening();
            _showSuccessDialog();
          }
        });
      } else {
        _pulseController.stop();
        _pulseController.value = 1.0;
      }
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: AppTheme.successColor, size: 32),
            const SizedBox(width: 10),
            const Text('Receta Guardada'),
          ],
        ),
        content: const Text(
          'He registrado la nueva medicación correctamente. Te recordaré cuando sea hora de tomarla.',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isListening)
          FadeInUp(
            duration: const Duration(milliseconds: 300),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LottieListeningDots(),
                  const SizedBox(width: 12),
                  const Text(
                    'Te estoy escuchando...',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        GestureDetector(
          onTap: _toggleListening,
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _isListening ? _pulseAnimation.value : 1.0,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: _isListening
                          ? [AppTheme.primaryColor, AppTheme.primaryColor.withValues(alpha: 0.7)]
                          : [AppTheme.secondaryColor, AppTheme.secondaryColor.withValues(alpha: 0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (_isListening ? AppTheme.primaryColor : AppTheme.secondaryColor).withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: FaIcon(
                    _isListening ? FontAwesomeIcons.microphone : FontAwesomeIcons.microphoneLines,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Un widget simple para simular los 3 puntos de escucha estilo ChatGPT
class LottieListeningDots extends StatefulWidget {
  const LottieListeningDots({super.key});

  @override
  State<LottieListeningDots> createState() => _LottieListeningDotsState();
}

class _LottieListeningDotsState extends State<LottieListeningDots> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double delay = index * 0.2;
            double value = (_controller.value - delay).clamp(0.0, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 8,
              height: 8 + (value * 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.5 + (value * 0.5)),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          },
        );
      }),
    );
  }
}
