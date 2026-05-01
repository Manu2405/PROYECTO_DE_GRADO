import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

class WebWelcomeScreen extends StatelessWidget {
  const WebWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A1929),
              Color(0xFF0F2B3D),
              Color(0xFF1A3A4F),
              Color(0xFF0D2135),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: const [
              _TopBar(),
              _Hero(),
              _StatsSection(),
              _MedicationFeatures(),  // Cambiado: enfoque en medicación
              _AIVoiceAssistant(),    // NUEVO: Asistente por voz IA
              _CollaborativeMonitoring(), // NUEVO: Monitoreo colaborativo
              _MedicationPreview(),   // Cambiado: enfoque en toma de medicamentos
              _HowItWorks(),
              _Testimonials(),
              _CTASection(),
              _Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryColor, Color(0xFF0EA5E9)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.medication, color: Colors.white, size: 28), // Cambiado: ícono de medicación
              ),
              const SizedBox(width: 12),
              Text(
                'VitaSenior Care',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const Spacer(),
              // Botones más grandes para adultos mayores
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/web/login'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white70,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text('Iniciar Sesión'),
                  ),
                  const SizedBox(width: 8),
                  _buildGradientButton(
                    context,
                    'Crear Cuenta',
                    Icons.person_add,
                    () => Navigator.pushNamed(context, '/web/register'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton(BuildContext context, String text, IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.secondaryColor, Color(0xFFF59E0B)],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppTheme.secondaryColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.of(context).size.width < 960;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      '🎙️ Gestión de Medicación con Asistente por Voz',
                      style: GoogleFonts.poppins(
                        color: AppTheme.primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Tus Medicamentos,\nSiempre en Orden',
                    style: GoogleFonts.poppins(
                      fontSize: compact ? 40 : 56,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.1,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Recordatorios inteligentes, confirmación de dosis y seguimiento \ncompartido con familiares y médicos. Diseñado para adultos mayores.',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _buildGradientButton(
                        context,
                        'Comenzar Ahora',
                        Icons.arrow_forward,
                        () => Navigator.pushNamed(context, '/web/register'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => Navigator.pushNamed(context, '/web/login'),
                        icon: const Icon(Icons.login, color: Colors.white),
                        label: const Text('Iniciar Sesión', style: TextStyle(color: Colors.white, fontSize: 16)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white30),
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (!compact) const Expanded(child: _HeroIllustration()),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientButton(BuildContext context, String text, IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, Color(0xFF0EA5E9)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(text, style: const TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _HeroIllustration extends StatelessWidget {
  const _HeroIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 400,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Column(
              children: [
                _buildInfoRow(Icons.access_time, 'Próxima dosis:', '10:00 AM'),
                const Divider(color: Colors.white24, height: 24),
                _buildInfoRow(Icons.check_circle, 'Confirmadas hoy:', '3 de 4'),
                const Divider(color: Colors.white24, height: 24),
                _buildInfoRow(Icons.warning_amber, 'Pendientes:', '1 dosis'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 24),
          const SizedBox(width: 12),
          Text(label, style: GoogleFonts.inter(color: Colors.white70, fontSize: 14)),
          const Spacer(),
          Text(value, style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 48),
      padding: const EdgeInsets.symmetric(vertical: 48),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem('+98%', 'Adherencia\nMejorada'),
            _buildStatItem('24/7', 'Seguimiento\nContinuo'),
            _buildStatItem('< 5min', 'Configuración\nDiaria'),
            _buildStatItem('+3', 'Familiares\nConectados'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
        const SizedBox(height: 8),
        Text(label, textAlign: TextAlign.center, style: GoogleFonts.inter(color: Colors.white70, fontSize: 14)),
      ],
    );
  }
}

// NUEVO: Enfoque en gestión de MEDICACIÓN (no signos vitales)
class _MedicationFeatures extends StatelessWidget {
  const _MedicationFeatures();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            Text(
              'Gestión Inteligente de Medicación',
              style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              'Todo lo necesario para un tratamiento seguro y controlado',
              style: GoogleFonts.inter(fontSize: 18, color: Colors.white60),
            ),
            const SizedBox(height: 48),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: MediaQuery.of(context).size.width < 800 ? 1 : 3,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              children: const [
                _FeatureCard(
                  icon: Icons.schedule,
                  title: 'Recordatorios Programados',
                  description: 'Notificaciones en horarios exactos para cada medicamento.',
                  color: Color(0xFF3B82F6),
                ),
                _FeatureCard(
                  icon: Icons.verified,
                  title: 'Confirmación de Toma',
                  description: 'Registra cada dosis tomada con un simple botón.',
                  color: Color(0xFF10B981),
                ),
                _FeatureCard(
                  icon: Icons.notifications_active,
                  title: 'Alertas por Omisión',
                  description: 'Notifica a familiares si no se confirma una dosis.',
                  color: Color(0xFFEF4444),
                ),
                _FeatureCard(
                  icon: Icons.history,
                  title: 'Historial de Cumplimiento',
                  description: 'Registro completo de todas las tomas realizadas.',
                  color: Color(0xFF8B5CF6),
                ),
                _FeatureCard(
                  icon: Icons.people,
                  title: 'Monitoreo Colaborativo',
                  description: 'Familiares y médicos supervisan el tratamiento.',
                  color: Color(0xFFF59E0B),
                ),
                _FeatureCard(
                  icon: Icons.picture_as_pdf,
                  title: 'Reportes para el Médico',
                  description: 'Informes detallados de adherencia al tratamiento.',
                  color: Color(0xFF06B6D4),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// NUEVO: Asistente por voz con IA
class _AIVoiceAssistant extends StatelessWidget {
  const _AIVoiceAssistant();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 48),
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppTheme.primaryColor.withValues(alpha: 0.15),
            Colors.purple.withValues(alpha: 0.1),
            AppTheme.secondaryColor.withValues(alpha: 0.15),
          ],
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      '🎙️ Innovación con IA',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Asistente por Voz\ncon Inteligencia Artificial',
                    style: GoogleFonts.poppins(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '"Toma tu medicamento de la mañana" - El asistente recuerda,\n'
                    'confirma y aprende de los patrones para anticipar olvidos.',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.mic, color: Colors.white, size: 32),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '"¿Ya tomaste tus medicamentos?"',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Respuesta por voz o toque - Diseñado para adultos mayores',
                                style: GoogleFonts.inter(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [Colors.white24, Colors.transparent],
                    ),
                  ),
                  child: const Icon(Icons.record_voice_over, size: 100, color: Colors.white70),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// NUEVO: Monitoreo Colaborativo
class _CollaborativeMonitoring extends StatelessWidget {
  const _CollaborativeMonitoring();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            Text(
              'Monitoreo Colaborativo',
              style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              'Familiares, cuidadores y médicos trabajando juntos',
              style: GoogleFonts.inter(fontSize: 16, color: Colors.white60),
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRoleCard('👴', 'Adulto Mayor', 'Usuario principal, confirma tomas'),
                const SizedBox(width: 24),
                _buildRoleCard('👨‍👩‍👧', 'Familiares', 'Supervisan y reciben alertas'),
                const SizedBox(width: 24),
                _buildRoleCard('👩‍⚕️', 'Cuidadores', 'Registran y asisten en la toma'),
                const SizedBox(width: 24),
                _buildRoleCard('👨‍⚕️', 'Médicos', 'Acceden a reportes de adherencia'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(String emoji, String role, String description) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(role, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(description, textAlign: TextAlign.center, style: GoogleFonts.inter(color: Colors.white60, fontSize: 12)),
        ],
      ),
    );
  }
}

// CAMBIADO: Enfoque en MEDICAMENTOS (no solo "monitoreo general")
class _MedicationPreview extends StatelessWidget {
  const _MedicationPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 48),
      padding: const EdgeInsets.symmetric(vertical: 60),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppTheme.primaryColor.withValues(alpha: 0.1),
            AppTheme.secondaryColor.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            Text(
              'Seguimiento de Medicamentos',
              style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              'Visualiza el cumplimiento del tratamiento día a día',
              style: GoogleFonts.inter(fontSize: 16, color: Colors.white60),
            ),
            const SizedBox(height: 48),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                children: [
                  _buildMedicationRow('Losartán 50mg', '08:00', 'Confirmada', AppTheme.successColor, Icons.check_circle),
                  const SizedBox(height: 16),
                  _buildMedicationRow('Metformina 850mg', '12:30', 'Pendiente', Colors.orange, Icons.access_time),
                  const SizedBox(height: 16),
                  _buildMedicationRow('Amlodipino 5mg', '20:00', 'Próxima', AppTheme.primaryColor, Icons.schedule),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                '🔔 Las alertas por omisión se envían automáticamente a familiares',
                style: TextStyle(color: Colors.white60, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationRow(String medication, String time, String status, Color statusColor, IconData icon) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.medication, color: Colors.white70, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(medication, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w500)),
              Text(time, style: GoogleFonts.inter(color: Colors.white60, fontSize: 12)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: statusColor, size: 16),
              const SizedBox(width: 4),
              Text(status, style: GoogleFonts.inter(color: statusColor, fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}

class _HowItWorks extends StatelessWidget {
  const _HowItWorks();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            Text(
              'Cómo Funciona',
              style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _StepWidget(step: '1', title: 'Registra tus\nmedicamentos', description: 'Ingresa nombre, dosis y horario', icon: Icons.medication),
                _StepWidget(step: '2', title: 'Recibe\nrecordatorios', description: 'Notificaciones en cada horario', icon: Icons.notifications_active),
                _StepWidget(step: '3', title: 'Confirma la\ntoma', description: 'Un toque para registrar', icon: Icons.check_circle),
                _StepWidget(step: '4', title: 'Familiares\nsupervisan', description: 'Reciben alertas si hay omisión', icon: Icons.people),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StepWidget extends StatelessWidget {
  final String step;
  final String title;
  final String description;
  final IconData icon;

  const _StepWidget({
    required this.step,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppTheme.primaryColor, Color(0xFF0EA5E9)]),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Icon(icon, color: Colors.white, size: 40),
        ),
        const SizedBox(height: 20),
        Text(step, style: GoogleFonts.poppins(color: AppTheme.primaryColor, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text(title, textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(description, textAlign: TextAlign.center, style: GoogleFonts.inter(color: Colors.white60, fontSize: 12)),
      ],
    );
  }
}

class _Testimonials extends StatelessWidget {
  const _Testimonials();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 48),
      padding: const EdgeInsets.symmetric(vertical: 60),
      color: Colors.white.withValues(alpha: 0.02),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            Text(
              'Lo que dicen nuestros usuarios',
              style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _TestimonialCard(
                  name: 'María, hija de paciente',
                  role: 'Familiar',
                  text: 'VitaSenior me da tranquilidad. Sé si mi mamá tomó sus pastillas incluso si no estoy con ella.',
                  rating: 5,
                ),
                SizedBox(width: 24),
                _TestimonialCard(
                  name: 'Dr. Javier Méndez',
                  role: 'Geriatra',
                  text: 'Los reportes de adherencia me permiten ajustar tratamientos con datos objetivos.',
                  rating: 5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final String name;
  final String role;
  final String text;
  final int rating;

  const _TestimonialCard({
    required this.name,
    required this.role,
    required this.text,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(rating, (index) => const Icon(Icons.star, color: Color(0xFFFBBF24), size: 20)),
          ),
          const SizedBox(height: 16),
          Text(text, style: GoogleFonts.inter(color: Colors.white70, height: 1.5)),
          const SizedBox(height: 20),
          Text(name, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
          Text(role, style: GoogleFonts.inter(color: Colors.white60, fontSize: 12)),
        ],
      ),
    );
  }
}

class _CTASection extends StatelessWidget {
  const _CTASection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(48),
      padding: const EdgeInsets.all(60),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, Color(0xFF0EA5E9)],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '¿Listo para mejorar el seguimiento de medicamentos?',
            style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            'Regístrate gratis y comienza a monitorear los tratamientos de tus seres queridos',
            style: GoogleFonts.inter(fontSize: 18, color: Colors.white70),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/web/register'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Comenzar Ahora', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(48),
      color: const Color(0xFF0A0A0A),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [AppTheme.primaryColor, Color(0xFF0EA5E9)]),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.medication, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 8),
                        Text('VitaSenior Care', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('© 2026 VitaSenior. Gestión de medicación para adultos mayores.', 
                        style: GoogleFonts.inter(color: Colors.white60, fontSize: 12)),
                  ],
                ),
                Row(
                  children: [
                    _buildFooterLink('Términos'),
                    const SizedBox(width: 24),
                    _buildFooterLink('Privacidad'),
                    const SizedBox(width: 24),
                    _buildFooterLink('Contacto'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      child: Text(text, style: GoogleFonts.inter(color: Colors.white60)),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.08),
            Colors.white.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.6)]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 20),
          Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 12),
          Text(description, style: GoogleFonts.inter(color: Colors.white60, height: 1.5)),
        ],
      ),
    );
  }
}