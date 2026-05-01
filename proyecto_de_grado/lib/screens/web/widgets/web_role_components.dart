import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class WebSidebarItem {
  final IconData icon;
  final String label;

  const WebSidebarItem({
    required this.icon,
    required this.label,
  });
}

class WebProfileMenu extends StatelessWidget {
  final VoidCallback onProfile;
  final VoidCallback onLogout;
  final bool isDarkMode;

  const WebProfileMenu({
    super.key,
    required this.onProfile,
    required this.onLogout,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isDarkMode ? Colors.white : Colors.white;
    
    return PopupMenuButton<String>(
      icon: Icon(Icons.account_circle, color: iconColor),
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      onSelected: (value) {
        if (value == 'perfil') onProfile();
        if (value == 'salir') onLogout();
      },
      itemBuilder: (_) => [
        const PopupMenuItem(value: 'perfil', child: Text('Mi perfil')),
        const PopupMenuItem(value: 'salir', child: Text('Cerrar sesión')),
      ],
    );
  }
}

class WebRoleScaffold extends StatelessWidget {
  final String title;
  final Widget sidebarHeader;
  final List<WebSidebarItem> sidebarItems;
  final int selectedIndex;
  final ValueChanged<int> onSelectItem;
  final Widget body;
  final VoidCallback onProfile;
  final VoidCallback onLogout;
  final VoidCallback? onToggleTheme;
  final bool isDarkMode;
  final double compactBreakpoint;

  const WebRoleScaffold({
    super.key,
    required this.title,
    required this.sidebarHeader,
    required this.sidebarItems,
    required this.selectedIndex,
    required this.onSelectItem,
    required this.body,
    required this.onProfile,
    required this.onLogout,
    this.onToggleTheme,
    this.isDarkMode = false,
    this.compactBreakpoint = 1024,
  });

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.of(context).size.width < compactBreakpoint;
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFF0F7FF);
    final appBarColor = isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFF1D4ED8);
    final textColor = isDarkMode ? Colors.white : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: appBarColor,
        foregroundColor: textColor,
        elevation: isDarkMode ? 0 : 0,
        actions: [
          // Botón de tema en app bar
          if (onToggleTheme != null)
            IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: onToggleTheme,
              color: Colors.white,
            ),
          WebProfileMenu(
            onProfile: onProfile,
            onLogout: onLogout,
            isDarkMode: isDarkMode,
          ),
        ],
      ),
      drawer: isCompact ? Drawer(child: _buildSidebar()) : null,
      body: Row(
        children: [
          if (!isCompact) SizedBox(width: 280, child: _buildSidebar()),
          Expanded(child: body),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    final backgroundColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final gradientColors = isDarkMode
        ? [const Color(0xFF1E1E1E), const Color(0xFF2D2D2D)]
        : [Colors.white, const Color(0xFFF3F8FF)];
    final textColor = isDarkMode ? Colors.white : Colors.grey.shade700;
    final selectedTextColor = isDarkMode ? Colors.white : AppTheme.primaryColor;
    final selectedTileColor = isDarkMode 
        ? AppTheme.primaryColor.withValues(alpha: 0.2)
        : const Color(0xFFDBEAFE);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors,
        ),
      ),
      child: ListView(
        children: [
          sidebarHeader,
          const SizedBox(height: 20),
          ...List.generate(
            sidebarItems.length,
            (index) {
              final item = sidebarItems[index];
              final selected = selectedIndex == index;
              return ListTile(
                leading: Icon(
                  item.icon,
                  color: selected ? AppTheme.primaryColor : Colors.grey,
                  size: 24,
                ),
                title: Text(
                  item.label,
                  style: TextStyle(
                    color: selected ? selectedTextColor : textColor,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                selected: selected,
                selectedTileColor: selectedTileColor,
                onTap: () => onSelectItem(index),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          // Botón de tema en sidebar (para versión compacta)
          if (onToggleTheme != null)
            ListTile(
              leading: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              title: Text(isDarkMode ? 'Modo Claro' : 'Modo Oscuro'),
              onTap: onToggleTheme,
            ),
        ],
      ),
    );
  }
}

class WebWelcomeBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isDarkMode;

  const WebWelcomeBanner({
    super.key,
    required this.title,
    required this.subtitle,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors = isDarkMode
        ? [const Color(0xFF0EA5E9), const Color(0xFF3B82F6)]
        : [AppTheme.primaryColor, AppTheme.primaryColor.withValues(alpha: 0.82)];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

class WebMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDarkMode;

  const WebMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isDarkMode ? const Color(0xFF2D2D2D) : Colors.white;
    final textColor = isDarkMode ? Colors.white : AppTheme.textPrimary;
    final secondaryTextColor = isDarkMode ? Colors.grey[400] : AppTheme.textSecondary;

    return SizedBox(
      width: 320,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: isDarkMode ? 0.2 : 0.18),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
          border: isDarkMode
              ? Border.all(color: color.withValues(alpha: 0.3), width: 1)
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: secondaryTextColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: textColor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Componente para tabla responsiva
class WebResponsiveTable extends StatelessWidget {
  final List<String> headers;
  final List<List<Widget>> rows;
  final bool isDarkMode;

  const WebResponsiveTable({
    super.key,
    required this.headers,
    required this.rows,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final headerColor = isDarkMode ? const Color(0xFF2D2D2D) : AppTheme.primaryColor.withValues(alpha: 0.05);
    final textColor = isDarkMode ? Colors.white : Colors.grey[800];
    final borderColor = isDarkMode ? Colors.grey[800]! : Colors.grey[200]!;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.resolveWith<Color?>(
              (states) => headerColor,
            ),
            dataRowColor: WidgetStateProperty.resolveWith<Color?>(
              (states) => isDarkMode ? const Color(0xFF252525) : Colors.white,
            ),
            border: TableBorder.all(color: borderColor),
            columns: headers.map((header) => DataColumn(
              label: Text(
                header,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            )).toList(),
            rows: rows.map((rowCells) => DataRow(
              cells: rowCells.map((cell) => DataCell(cell)).toList(),
            )).toList(),
          ),
        ),
      ),
    );
  }
}

// Componente para tarjeta de actividad
class WebActivityCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color color;
  final bool isDarkMode;

  const WebActivityCard({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isDarkMode ? const Color(0xFF2D2D2D) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.grey[800];
    final secondaryTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}