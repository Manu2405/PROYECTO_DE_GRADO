import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';
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
      text: '👋 Hola ${widget.userName}, soy tu asistente de salud.\n\nToca el micrófono y habla claramente.\n\n¿En qué puedo ayudarte?',
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
    });

    _scrollToBottom();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isAITyping = false;
        _messages.add(ChatMessage(
          text: _getAIResponse(message),
          isUser: false,
          time: DateTime.now(),
        ));
      });
      _scrollToBottom();
    });
  }

  String _getAIResponse(String message) {
    message = message.toLowerCase();
    String userName = widget.userName;
    
    if (message.contains('medicamento') || message.contains('pastilla') || message.contains('medicina')) {
      return '💊 $userName, tus medicamentos de hoy:\n\n📍 Losartán 50mg - 2:30pm\n📍 Metformina 850mg - 8:00pm\n📍 Aspirina 100mg - 8:00am';
    } 
    else if (message.contains('recordatorio') || message.contains('alarma')) {
      return '⏰ Claro $userName, dime qué medicamento y a qué hora.';
    }
    else if (message.contains('presion') || message.contains('tension')) {
      return '❤️ $userName, tu presión debe estar entre 120/80. Toma Losartán a las 2:30pm.';
    }
    else if (message.contains('hola')) {
      return '🌟 ¡Hola $userName! ¿Cómo estás hoy?';
    }
    else if (message.contains('gracias')) {
      return '🎉 ¡De nada $userName! Estoy aquí para ti.';
    }
    else if (message.contains('ayuda')) {
      return '📋 Puedo ayudarte con: Medicamentos, Recordatorios, Control de presión';
    }
    else {
      return '🤔 $userName, puedes decir: "Ver medicamentos" o "Necesito ayuda"';
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
            _buildVoiceOption('💊 Ver medicamentos', 'Ver medicamentos'),
            _buildVoiceOption('⏰ Crear recordatorio', 'Crear recordatorio'),
            _buildVoiceOption('❤️ Control de presión', 'Controlar presión'),
            _buildVoiceOption('📋 Ayuda', 'Ayuda por favor'),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceOption(String title, String message) {
    return Container(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Asistente de Salud',
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
      body: Column(
        children: [
          // Microfono grande
          SizedBox(
            height: 220,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _isListening ? _pulseAnimation.value : 1.0,
                        child: GestureDetector(
                          onTap: _startListening,
                          child: Container(
                            width: _isListening ? 140 : 120,
                            height: _isListening ? 140 : 120,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: _isListening 
                                    ? [Colors.red, Colors.red.shade300]
                                    : [AppTheme.primaryColor, AppTheme.secondaryColor],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (_isListening ? Colors.red : AppTheme.primaryColor).withValues(alpha: 0.4),
                                  blurRadius: _isListening ? 30 : 20,
                                  spreadRadius: _isListening ? 8 : 5,
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
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isListening ? '🎤 Escuchando...' : '¡Toca para hablar!',
                    style: TextStyle(
                      fontSize: _isListening ? 18 : 16,
                      fontWeight: FontWeight.bold,
                      color: _isListening ? Colors.red : AppTheme.primaryColor,
                    ),
                  ),
                  if (!_isListening)
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        'Habla sobre tus medicamentos',
                        style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Área de mensajes
          Expanded(
            child: Container(
              color: const Color(0xFFF8F9FA),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'Conversación',
                      style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _messages.length + (_isAITyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _messages.length && _isAITyping) {
                          return const TypingIndicator();
                        }
                        final message = _messages[index];
                        return ChatBubble(message: message);
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
                      _buildQuickButton('💊 Medicamentos', Colors.teal, 'Ver medicamentos'),
                      const SizedBox(width: 8),
                      _buildQuickButton('⏰ Recordatorio', Colors.orange, 'Crear recordatorio'),
                      const SizedBox(width: 8),
                      _buildQuickButton('❤️ Presión', Colors.red, 'Controlar presión'),
                      const SizedBox(width: 8),
                      _buildQuickButton('❓ Ayuda', AppTheme.primaryColor, 'Ayuda por favor'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Botón de volver grande y llamativo
                ElevatedButton.icon(
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickButton(String text, Color color, String message) {
    return Container(
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
    );
  }
}

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
                _buildDot(),
                const SizedBox(width: 4),
                _buildDot(),
                const SizedBox(width: 4),
                _buildDot(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.6),
        shape: BoxShape.circle,
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Container(
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
    );
  }
}

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