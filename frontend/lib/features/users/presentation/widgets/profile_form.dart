import 'package:fct_frontend/core/utils/validators.dart';
import 'package:fct_frontend/core/widgets/app_button.dart';
import 'package:fct_frontend/shared/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileForm extends ConsumerStatefulWidget {
  const ProfileForm({
    super.key,
    required this.user,
  });

  final User user;

  @override
  ConsumerState<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Editar perfil',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: Icon(_isEditing ? Icons.close : Icons.edit),
                    onPressed: () {
                      setState(() {
                        if (_isEditing) {
                          // Cancelar edición - restaurar valores originales
                          _firstNameController.text = widget.user.firstName;
                          _lastNameController.text = widget.user.lastName;
                          _emailController.text = widget.user.email;
                        }
                        _isEditing = !_isEditing;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Campo de nombre
              TextFormField(
                controller: _firstNameController,
                enabled: _isEditing,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => Validators.combine([
                  (v) => Validators.required(v, fieldName: 'El nombre'),
                  (v) => Validators.name(v, fieldName: 'El nombre'),
                  (v) => Validators.maxLength(v, 50, fieldName: 'El nombre'),
                ], value),
              ),

              const SizedBox(height: 16),

              // Campo de apellidos
              TextFormField(
                controller: _lastNameController,
                enabled: _isEditing,
                decoration: const InputDecoration(
                  labelText: 'Apellidos',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) => Validators.combine([
                  (v) => Validators.required(v, fieldName: 'Los apellidos'),
                  (v) => Validators.name(v, fieldName: 'Los apellidos'),
                  (v) =>
                      Validators.maxLength(v, 100, fieldName: 'Los apellidos'),
                ], value),
              ),

              const SizedBox(height: 16),

              // Campo de email
              TextFormField(
                controller: _emailController,
                enabled: _isEditing,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) => Validators.combine([
                  Validators.required,
                  Validators.email,
                  (v) => Validators.maxLength(v, 255, fieldName: 'El email'),
                ], value),
              ),

              const SizedBox(height: 16),

              // Campo de rol (solo lectura)
              TextFormField(
                initialValue: _getRoleDisplayName(widget.user.role),
                enabled: false,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Rol',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.security),
                ),
              ),

              if (_isEditing) ...[
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        onPressed: _isLoading ? null : _saveProfile,
                        text: _isLoading ? 'Guardando...' : 'Guardar cambios',
                        isLoading: _isLoading,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : _cancelEdit,
                        child: const Text('Cancelar'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implementar actualización de perfil
      await Future.delayed(const Duration(seconds: 1)); // Simulación

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil actualizado correctamente'),
            backgroundColor: Colors.green,
          ),
        );

        setState(() {
          _isEditing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar perfil: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _cancelEdit() {
    setState(() {
      _firstNameController.text = widget.user.firstName;
      _lastNameController.text = widget.user.lastName;
      _emailController.text = widget.user.email;
      _isEditing = false;
    });
  }

  String _getRoleDisplayName(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'Administrador';
      case 'tutor':
        return 'Tutor';
      case 'student':
        return 'Estudiante';
      default:
        return role;
    }
  }
}
