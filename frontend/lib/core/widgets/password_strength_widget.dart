import 'package:flutter/material.dart';
import 'package:fct_frontend/core/extensions/color_extensions.dart';

enum PasswordStrength {
  weak,
  medium,
  strong,
  veryStrong,
}

class PasswordStrengthWidget extends StatelessWidget {
  const PasswordStrengthWidget({
    super.key,
    required this.password,
    this.showLabel = true,
  });

  final String password;
  final bool showLabel;

  PasswordStrength _getPasswordStrength() {
    if (password.isEmpty) return PasswordStrength.weak;

    int score = 0;

    // Longitud
    if (password.length >= 8) score += 1;
    if (password.length >= 12) score += 1;

    // Caracteres
    if (RegExp(r'[a-z]').hasMatch(password)) score += 1;
    if (RegExp(r'[A-Z]').hasMatch(password)) score += 1;
    if (RegExp(r'[0-9]').hasMatch(password)) score += 1;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score += 1;

    // Variedad de caracteres
    final uniqueChars = password.split('').toSet().length;
    if (uniqueChars >= 8) score += 1;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    if (score <= 6) return PasswordStrength.strong;
    return PasswordStrength.veryStrong;
  }

  Color _getStrengthColor() {
    switch (_getPasswordStrength()) {
      case PasswordStrength.weak:
        return Colors.red;
      case PasswordStrength.medium:
        return Colors.orange;
      case PasswordStrength.strong:
        return Colors.yellow;
      case PasswordStrength.veryStrong:
        return Colors.green;
    }
  }

  String _getStrengthText() {
    switch (_getPasswordStrength()) {
      case PasswordStrength.weak:
        return 'Débil';
      case PasswordStrength.medium:
        return 'Media';
      case PasswordStrength.strong:
        return 'Fuerte';
      case PasswordStrength.veryStrong:
        return 'Muy fuerte';
    }
  }

  double _getStrengthPercentage() {
    switch (_getPasswordStrength()) {
      case PasswordStrength.weak:
        return 0.25;
      case PasswordStrength.medium:
        return 0.5;
      case PasswordStrength.strong:
        return 0.75;
      case PasswordStrength.veryStrong:
        return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    final strength = _getPasswordStrength();
    final color = _getStrengthColor();
    final text = _getStrengthText();
    final percentage = _getStrengthPercentage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          Row(
            children: [
              Text(
                'Fuerza de la contraseña: ',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                text,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: Colors.grey.withValues(alpha: 0.3),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 4,
        ),
        const SizedBox(height: 8),
        _buildRequirementsList(),
      ],
    );
  }

  Widget _buildRequirementsList() {
    final requirements = <Widget>[];

    // Longitud mínima
    final hasMinLength = password.length >= 8;
    requirements.add(_buildRequirement(
      'Al menos 8 caracteres',
      hasMinLength,
    ));

    // Letra minúscula
    final hasLowerCase = RegExp(r'[a-z]').hasMatch(password);
    requirements.add(_buildRequirement(
      'Al menos una letra minúscula',
      hasLowerCase,
    ));

    // Letra mayúscula
    final hasUpperCase = RegExp(r'[A-Z]').hasMatch(password);
    requirements.add(_buildRequirement(
      'Al menos una letra mayúscula',
      hasUpperCase,
    ));

    // Número
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    requirements.add(_buildRequirement(
      'Al menos un número',
      hasNumber,
    ));

    // Carácter especial
    final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    requirements.add(_buildRequirement(
      'Al menos un carácter especial',
      hasSpecialChar,
    ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: requirements,
    );
  }

  Widget _buildRequirement(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isMet ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isMet ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
