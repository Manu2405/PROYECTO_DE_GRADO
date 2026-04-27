import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/theme/app_theme.dart';
import 'ai_voice_chat_screen.dart';

class AiVoiceButton extends StatefulWidget {
  final VoidCallback? onTap;
  final String? userName;

  const AiVoiceButton({super.key, this.onTap, this.userName});

  @override
  State<AiVoiceButton> createState() => _AiVoiceButtonState();
}

class _AiVoiceButtonState extends State<AiVoiceButton> with SingleTickerProviderStateMixin {
  bool _isListening = false;
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;
  late Animation<double> _iconScaleAnimation;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    // Animación de respiración: crece y se encoge
    _breathingAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
    
    // Animación del icono
    _iconScaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
      if (_isListening) {
        _breathingController.repeat(reverse: true);
        if (widget.onTap != null) {
          widget.onTap!();
        }
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted && _isListening) {
            _toggleListening();
            _showVoiceInputDialog();
          }
        });
      } else {
        _breathingController.stop();
        _breathingController.value = 0;
      }
    });
  }

  void _showVoiceInputDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 30,
                offset: Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                '🎙️ Escuchando...',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Habla sobre tu medicamento o consulta',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.4),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.microphone,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const ListeningDots(),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AiVoiceChatScreen(userName: widget.userName ?? "Usuario"),
        ),
      );
    });
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Escuchando...',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        GestureDetector(
          onTap: _toggleListening,
          child: AnimatedBuilder(
            animation: _breathingAnimation,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Ondas de expansión cuando está escuchando
                  if (_isListening)
                    ...List.generate(3, (index) {
                      return Container(
                        width: 70 * (_breathingAnimation.value + (index * 0.15)),
                        height: 70 * (_breathingAnimation.value + (index * 0.15)),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryColor.withValues(alpha: 0.1 - (index * 0.03)),
                        ),
                      );
                    }),
                  
                  // Botón principal con efecto de crecimiento
                  Transform.scale(
                    scale: _isListening ? _breathingAnimation.value : 1.0,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: _isListening
                              ? [AppTheme.primaryColor, AppTheme.secondaryColor]
                              : [AppTheme.secondaryColor, Colors.orange.shade400],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (_isListening ? AppTheme.primaryColor : AppTheme.secondaryColor).withValues(alpha: 0.5),
                            blurRadius: _isListening ? 30 : 15,
                            spreadRadius: _isListening ? 8 : 2,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Transform.scale(
                        scale: _isListening ? 1.1 : 1.0,
                        child: Center(
                          child: FaIcon(
                            _isListening ? FontAwesomeIcons.microphone : FontAwesomeIcons.microphoneLines,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _isListening ? 0 : 1,
          child: Text(
            'Asistente IA',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (_isListening)
          FadeInUp(
            child: Text(
              '🎤 Habla ahora...',
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}

// Widget personalizado para los 3 puntos de escucha estilo ChatGPT
class ListeningDots extends StatefulWidget {
  const ListeningDots({super.key});

  @override
  State<ListeningDots> createState() => _ListeningDotsState();
}

class _ListeningDotsState extends State<ListeningDots> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
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
            double value = (_controller.value + (index * 0.33)) % 1.0;
            double height = 8 + (value * 10);
            
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 8,
              height: height,
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