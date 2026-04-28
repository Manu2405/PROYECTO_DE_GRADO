import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/theme/app_theme.dart';
import '../../models/ai_analysis_model.dart';
import '../../services/ai_service.dart';
import '../../widgets/ai_analysis_card.dart';
import 'help_screen.dart';

class AiVoiceChatScreen extends StatefulWidget {
  final String userName;
  
  const AiVoiceChatScreen({super.key, required this.userName});

  @override
  State<AiVoiceChatScreen> createState() => _AiVoiceChatScreenState();
}

class _AiVoiceChatScreenState extends State<AiVoiceChatScreen> with SingleTickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isListening = false;
  bool _isAITyping = false;
  bool _showAIAnalysis = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    _messages.add(ChatMessage(
      text: '👋 Hola ${widget.userName}, soy tu asistente de salud con IA.\n\n🧠 Puedo ayudarte a analizar tu cumplimiento médico, identificar patrones y generar alertas inteligentes.',
      isUser: false,
      time: DateTime.now(),
    ));
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: true,
        time: DateTime.now(),
      ));
      _isAITyping = true;
      _showAIAnalysis = false;
    });

    _scrollToBottom();

    Future.delayed(const Duration(seconds: 2), () {
      final response = _getAIResponse(message);
      setState(() {
        _isAITyping = false;
        _messages.add(ChatMessage(
          text: response,
          isUser: false,
          time: DateTime.now(),
        ));
        
        if (message.toLowerCase().contains('cumplimiento') ||
            message.toLowerCase().contains('analizar') ||
            message.toLowerCase().contains('progreso')) {
          _showAIAnalysis = true;
        }
      });
      _scrollToBottom();
    });
  }

  String _getAIResponse(String message) {
    message = message.toLowerCase();
    String userName = widget.userName;
    
    if (message.contains('medicamento') || message.contains('pastilla') || message.contains('medicina')) {
      return '💊 $userName, tus medicamentos de hoy:\n\n📍 Losartán 50mg - 2:30pm\n📍 Metformina 850mg - 8:00pm\n📍 Aspirina 100mg - 8:00am\n\n¿Necesitas que analice tu cumplimiento?';
    } 
    else if (message.contains('recordatorio') || message.contains('alarma')) {
      return '⏰ Claro $userName, puedo ayudarte a crear recordatorios inteligentes.\n\n¿Para qué medicamento y a qué hora?';
    }
    else if (message.contains('presion') || message.contains('tension')) {
      return '❤️ $userName, según tus registros, tu presión debe estar entre 120/80.\n\n⚠️ Alerta: Has omitido Losartán 2 veces esta semana. ¿Necesitas ayuda para recordarlo?';
    }
    else if (message.contains('cumplimiento') || message.contains('analizar') || message.contains('progreso')) {
      final analysis = AIService.analyzeCompliance(userName);
      return '📊 $userName, he analizado tu cumplimiento:\n\n✅ Tasa de adherencia: ${analysis.adherenceRate.toStringAsFixed(1)}%\n\n${analysis.patterns.first}\n\n💡 ¿Quieres que te muestre el análisis completo?';
    }
    else if (message.contains('alerta') || message.contains('omision')) {
      return '⚠️ $userName, se han detectado las siguientes alertas:\n\n• Omisión de Losartán 50mg (2 días)\n• Retraso en Metformina 850mg\n\n💡 Recomendación: Activa recordatorios por voz.';
    }
    else if (message.contains('recomendacion') || message.contains('mejorar')) {
      return '💡 $userName, para mejorar tu cumplimiento:\n\n1️⃣ Usa recordatorios por voz\n2️⃣ Toma tus medicamentos a la misma hora\n3️⃣ Revisa tu progreso semanalmente\n\n¿Necesitas ayuda para implementar alguna?';
    }
    else if (message.contains('hola')) {
      return '🌟 ¡Hola $userName! ¿Cómo te sientes hoy?\n\n🧠 Recuerda que puedo analizar tu cumplimiento médico y generar alertas inteligentes.';
    }
    else if (message.contains('gracias')) {
      return '🎉 ¡De nada $userName! Estoy aquí para cuidar de tu salud.\n\n¿Necesitas analizar tu cumplimiento o crear algún recordatorio?';
    }
    else if (message.contains('ayuda')) {
      return '📋 Puedo ayudarte con:\n\n🧠 Analizar cumplimiento médico\n📍 Ver medicamentos\n⏰ Crear recordatorios inteligentes\n⚠️ Alertas de omisiones\n💡 Recomendaciones personalizadas\n\n¿Qué deseas hacer?';
    }
    else {
      return '🤔 $userName, puedes preguntarme sobre:\n\n• "Analizar cumplimiento"\n• "Ver medicamentos"\n• "Alertas"\n• "Recomendaciones"';
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startListening() {
    setState(() {
      _isListening = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isListening) {
        setState(() {
          _isListening = false;
        });
        _showVoiceResult();
      }
    });
  }

  void _showVoiceResult() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '¿Qué deseas hacer?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildVoiceOption('🧠 Analizar cumplimiento', 'Analizar cumplimiento de medicamentos'),
            _buildVoiceOption('💊 Ver medicamentos', 'Ver medicamentos'),
            _buildVoiceOption('⏰ Crear recordatorio', 'Crear recordatorio'),
            _buildVoiceOption('⚠️ Ver alertas', 'Mostrar alertas'),
            _buildVoiceOption('💡 Recomendaciones', 'Recomendaciones para mejorar'),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceOption(String title, String message) {
    return FadeInUp(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _sendMessage(message);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
              ),
            ),
            child: Text(title, style: const TextStyle(fontSize: 16)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Asistente IA de Salud',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryColor, size: 24),
          tooltip: 'Volver',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: AppTheme.primaryColor, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelpScreen()),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // Microfono con animación corregida
                    Container(
                      height: screenHeight * 0.28,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                // Anillo de onda - corregido para no causar overflow
                                if (_isListening)
                                  AnimatedBuilder(
                                    animation: _pulseAnimation,
                                    builder: (context, child) {
                                      return Container(
                                        width: 120 + (40 * (_pulseAnimation.value - 1)),
                                        height: 120 + (40 * (_pulseAnimation.value - 1)),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red.withValues(alpha: 0.15),
                                        ),
                                      );
                                    },
                                  ),
                                // Botón de micrófono
                                GestureDetector(
                                  onTap: _startListening,
                                  child: AnimatedBuilder(
                                    animation: _pulseAnimation,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _isListening ? _pulseAnimation.value : 1.0,
                                        child: Container(
                                          width: 90,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: _isListening 
                                                  ? [Colors.red, Colors.red.shade300]
                                                  : [AppTheme.primaryColor, AppTheme.secondaryColor],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: (_isListening ? Colors.red : AppTheme.primaryColor).withValues(alpha: 0.4),
                                                blurRadius: _isListening ? 20 : 15,
                                                spreadRadius: _isListening ? 5 : 3,
                                              ),
                                            ],
                                          ),
                                          child: const Center(
                                            child: FaIcon(
                                              FontAwesomeIcons.microphone,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            FadeInUp(
                              child: Text(
                                _isListening ? '🎤 Escuchando...' : '🎤 ¡Toca para hablar!',
                                style: TextStyle(
                                  fontSize: _isListening ? 16 : 14,
                                  fontWeight: FontWeight.bold,
                                  color: _isListening ? Colors.red : AppTheme.primaryColor,
                                ),
                              ),
                            ),
                            if (!_isListening)
                              FadeInUp(
                                delay: const Duration(milliseconds: 200),
                                child: Text(
                                  isSmallScreen ? 'IA analizando salud' : 'IA analizando tu salud | Di algo',
                                  style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Tarjeta de análisis IA
                    if (_showAIAnalysis)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AIAnalysisCard(
                          userName: widget.userName,
                          onSendMessage: _sendMessage,
                        ),
                      ),
                    
                    // Área de mensajes
                    Container(
                      constraints: BoxConstraints(
                        minHeight: screenHeight * 0.35,
                      ),
                      child: Container(
                        color: const Color(0xFFF8F9FA),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: const Text(
                                'Conversación Inteligente',
                                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.35,
                              child: ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: _messages.length + (_isAITyping ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == _messages.length && _isAITyping) {
                                    return const TypingIndicator();
                                  }
                                  final message = _messages[index];
                                  return FadeInUp(
                                    duration: const Duration(milliseconds: 300),
                                    child: ChatBubble(message: message),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Botones de ayuda rápida
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildQuickButton('🧠 Analizar', Colors.purple, 'Analizar cumplimiento de medicamentos'),
                                const SizedBox(width: 8),
                                _buildQuickButton('💊 Medicamentos', Colors.teal, 'Ver medicamentos'),
                                const SizedBox(width: 8),
                                _buildQuickButton('⏰ Recordatorio', Colors.orange, 'Crear recordatorio'),
                                const SizedBox(width: 8),
                                _buildQuickButton('⚠️ Alertas', Colors.red, 'Mostrar alertas'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          FadeInUp(
                            child: ElevatedButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back, size: 20),
                              label: const Text('Volver al menú principal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 4,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                minimumSize: const Size(double.infinity, 48),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickButton(String text, Color color, String message) {
    return FadeInLeft(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _sendMessage(message),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Indicador de escritura
class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _AnimatedDot(delay: 0),
                const SizedBox(width: 4),
                _AnimatedDot(delay: 150),
                const SizedBox(width: 4),
                _AnimatedDot(delay: 300),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Punto animado
class _AnimatedDot extends StatefulWidget {
  final int delay;
  
  const _AnimatedDot({required this.delay});

  @override
  State<_AnimatedDot> createState() => _AnimatedDotState();
}

class _AnimatedDotState extends State<_AnimatedDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

// Burbuja de chat
class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return FadeInUp(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isUser ? AppTheme.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            message.text,
            style: TextStyle(
              color: isUser ? Colors.white : AppTheme.textPrimary,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}

// Modelo de mensaje
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });
}