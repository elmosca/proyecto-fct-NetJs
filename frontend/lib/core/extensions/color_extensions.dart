// Extensión utilitaria para manipular valores del color
// Escribe todo el código en inglés, comentarios en castellano.

import 'package:flutter/material.dart';

/// Extensión para facilitar la modificación del canal alpha de un [Color].
/// Permite usar la sintaxis `color.withValues(alpha: 0.5)` tan utilizada
/// previamente en el proyecto.
extension ColorWithValues on Color {
  /// Devuelve una copia del color con el canal alpha modificado.
  /// [alpha] debe estar entre 0.0 y 1.0. Si se pasa `null` se conserva
  /// el alpha original.
  Color withValues({double? alpha}) {
    // Si no se especifica alpha, devolvemos el mismo color.
    if (alpha == null) return this;

    // Aseguramos rango 0..1 y convertimos a 0..255.
    final double safe = alpha.clamp(0.0, 1.0);
    final int newAlpha = (safe * 255).round();

    return withAlpha(newAlpha);
  }
}