extension StringExtensions on String {
  /// Capitaliza la primera letra de cada palabra
  String get capitalize {
    if (isEmpty) return this;
    return split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Verifica si el string es un email válido
  bool get isEmail {
    // Acepta subdominios y + en la parte local
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Verifica si el string es una URL válida (http/https)
  bool get isUrl {
    final uri = Uri.tryParse(this);
    if (uri == null) return false;
    final isHttp = uri.scheme == 'http' || uri.scheme == 'https';
    final hasHost = (uri.host.isNotEmpty);
    return isHttp && hasHost;
  }

  /// Trunca el string si es muy largo
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }

  /// Convierte el string a slug (URL-friendly)
  /// Conserva letras acentuadas comunes en español y ñ/Ñ
  String get toSlug {
    final allowed =
        RegExp(r'[^a-z0-9\s\-áéíóúüñçàèìòùâêîôûäëïöÿÁÉÍÓÚÜÑÇÀÈÌÒÙÂÊÎÔÛÄËÏÖŸ]');
    return toLowerCase()
        .replaceAll(allowed, '')
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .trim();
  }
}
