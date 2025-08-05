import 'package:fct_frontend/core/utils/validators.dart';
import 'package:fct_frontend/core/widgets/app_button.dart';
import 'package:fct_frontend/features/users/domain/entities/role_enum.dart';
import 'package:fct_frontend/shared/models/user.dart';
import 'package:flutter/material.dart';

class UserForm extends StatefulWidget {
  const UserForm({
    super.key,
    this.user,
    this.onSubmit,
    this.isLoading = false,
  });

  final User? user;
  final Function(Map<String, dynamic> data)? onSubmit;
  final bool isLoading;

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _phoneController;
  late final TextEditingController _avatarController;
  String _selectedRole = RoleEnum.student.value;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.user != null;

    _firstNameController =
        TextEditingController(text: widget.user?.firstName ?? '');
    _lastNameController =
        TextEditingController(text: widget.user?.lastName ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _phoneController =
        TextEditingController(); // Campo opcional, no en el modelo actual
    _avatarController = TextEditingController(text: widget.user?.avatar ?? '');

    if (_isEditMode) {
      _selectedRole = widget.user!.role;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Nombre
          TextFormField(
            controller: _firstNameController,
            decoration: const InputDecoration(
              labelText: 'Nombre *',
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

          // Apellidos
          TextFormField(
            controller: _lastNameController,
            decoration: const InputDecoration(
              labelText: 'Apellidos *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) => Validators.combine([
              (v) => Validators.required(v, fieldName: 'Los apellidos'),
              (v) => Validators.name(v, fieldName: 'Los apellidos'),
              (v) => Validators.maxLength(v, 100, fieldName: 'Los apellidos'),
            ], value),
          ),

          const SizedBox(height: 16),

          // Email
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email *',
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

          // Contraseña (solo para nuevos usuarios)
          if (!_isEditMode) ...[
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Contraseña *',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              validator: (value) => Validators.combine([
                Validators.required,
                Validators.password,
              ], value),
            ),

            const SizedBox(height: 16),

            // Confirmar contraseña
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirmar contraseña *',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock_reset),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
              validator: (value) => Validators.confirmPassword(
                value,
                _passwordController.text,
              ),
            ),

            const SizedBox(height: 16),
          ],

          // Rol
          DropdownButtonFormField<String>(
            value: _selectedRole,
            decoration: const InputDecoration(
              labelText: 'Rol *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.security),
            ),
            items: RoleEnum.allRoles.map((role) {
              return DropdownMenuItem(
                value: role.value,
                child: Text(role.displayName),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedRole = value!;
              });
            },
            validator: (value) => Validators.role(value),
          ),

          const SizedBox(height: 16),

          // Teléfono (opcional)
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Teléfono',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
            validator: Validators.phone,
          ),

          const SizedBox(height: 16),

          // Avatar URL (opcional)
          TextFormField(
            controller: _avatarController,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(
              labelText: 'URL del avatar',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.image),
            ),
            validator: Validators.url,
          ),

          const SizedBox(height: 24),

          // Botones
          Row(
            children: [
              Expanded(
                child: AppButton(
                  onPressed: widget.isLoading ? null : _submitForm,
                  text: widget.isLoading
                      ? (_isEditMode ? 'Actualizando...' : 'Creando...')
                      : (_isEditMode ? 'Actualizar usuario' : 'Crear usuario'),
                  isLoading: widget.isLoading,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final data = <String, dynamic>{
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      'email': _emailController.text.trim(),
      'role': _selectedRole,
    };

    // Solo incluir contraseña si no es modo edición
    if (!_isEditMode) {
      data['password'] = _passwordController.text;
    }

    // Campos opcionales
    if (_phoneController.text.trim().isNotEmpty) {
      data['phone'] = _phoneController.text.trim();
    }
    if (_avatarController.text.trim().isNotEmpty) {
      data['avatar'] = _avatarController.text.trim();
    }

    widget.onSubmit?.call(data);
  }
}
