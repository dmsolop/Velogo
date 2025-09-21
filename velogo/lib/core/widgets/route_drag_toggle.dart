import 'package:flutter/material.dart';
import '../services/route_drag_service.dart';
import '../services/log_service.dart';

/// Віджет для перемикання режиму перетягування маршрутів
class RouteDragToggle extends StatefulWidget {
  final VoidCallback? onToggle;
  final bool showLabel;
  final Color? activeColor;
  final Color? inactiveColor;

  const RouteDragToggle({
    Key? key,
    this.onToggle,
    this.showLabel = true,
    this.activeColor,
    this.inactiveColor,
  }) : super(key: key);

  @override
  State<RouteDragToggle> createState() => _RouteDragToggleState();
}

class _RouteDragToggleState extends State<RouteDragToggle> {
  bool _isEnabled = false;

  @override
  void initState() {
    super.initState();
    _isEnabled = RouteDragService.isDragEnabled;
  }

  void _toggleDragMode() {
    setState(() {
      _isEnabled = !_isEnabled;
    });

    RouteDragService.setDragEnabled(_isEnabled);
    LogService.log('🔄 [RouteDragToggle] Режим перетягування: ${_isEnabled ? "увімкнено" : "вимкнено"}');

    widget.onToggle?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = widget.activeColor ?? theme.primaryColor;
    final inactiveColor = widget.inactiveColor ?? theme.disabledColor;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleDragMode,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Іконка
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _isEnabled ? activeColor : inactiveColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isEnabled ? Icons.drag_indicator : Icons.drag_indicator_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                ),

                if (widget.showLabel) ...[
                  const SizedBox(width: 12),
                  // Текст
                  Text(
                    _isEnabled ? 'Перетягування увімкнено' : 'Перетягування вимкнено',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _isEnabled ? activeColor : theme.textTheme.bodyMedium?.color,
                      fontWeight: _isEnabled ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],

                const SizedBox(width: 8),
                // Перемикач
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 44,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: _isEnabled ? activeColor : inactiveColor.withOpacity(0.3),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    alignment: _isEnabled ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      width: 20,
                      height: 20,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Компактна версія перемикача (тільки іконка)
class RouteDragToggleCompact extends StatelessWidget {
  final VoidCallback? onToggle;
  final Color? activeColor;
  final Color? inactiveColor;

  const RouteDragToggleCompact({
    Key? key,
    this.onToggle,
    this.activeColor,
    this.inactiveColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = this.activeColor ?? theme.primaryColor;
    final inactiveColor = this.inactiveColor ?? theme.disabledColor;
    final isEnabled = RouteDragService.isDragEnabled;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () {
            RouteDragService.setDragEnabled(!isEnabled);
            LogService.log('🔄 [RouteDragToggleCompact] Режим перетягування: ${!isEnabled ? "увімкнено" : "вимкнено"}');
            onToggle?.call();
          },
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              isEnabled ? Icons.drag_indicator : Icons.drag_indicator_outlined,
              color: isEnabled ? activeColor : inactiveColor,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
