import 'package:flutter/material.dart';
import 'package:artverse/utils/constants.dart';

/// ================= INPUT DECORATION HELPER =================
class AuthInputDecoration {
  static InputDecoration base({
    String? labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Color? fillColor,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: false,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primary),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      hintStyle: TextStyle(color: AppColors.textSecondary),
    );
  }
}

/// ================= LABEL =================
class AuthLabel extends StatelessWidget {
  final String text;

  const AuthLabel({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

/// ================= TEXT FIELD =================
class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? labelText;
  final bool readOnly;
  final bool obscure;
  final Color? fillColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.labelText,
    this.fillColor = AppColors.surface,
    this.readOnly = false,
    this.obscure = false,
    this.suffixIcon,
    this.keyboardType,
    this.prefixIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      readOnly: readOnly,
      onTap: onTap,
      decoration: AuthInputDecoration.base(
        labelText: labelText,
        hintText: hint,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        fillColor: fillColor,
      ),
      keyboardType: keyboardType,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

/// ================= BUTTON =================
class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isDisabled; // <-- TAMBAH INI

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isDisabled = false, // <-- default false
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isDisabled 
              ? Colors.grey[400] // Warna abu jika disabled
              : Theme.of(context).primaryColor,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: isDisabled ? null : onPressed, // <-- disabled state
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDisabled ? Colors.grey[600] : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// ================= SELECT OPTION =================
class SelectOption {
  final String id;
  final String label;
  final dynamic value;

  SelectOption({
    required this.id,
    required this.label,
    required this.value,
  });

  /// Factory constructor untuk membuat dari JSON (Supabase format)
  factory SelectOption.fromJson(Map<String, dynamic> json, {
    required String idKey,
    required String labelKey,
  }) {
    return SelectOption(
      id: json[idKey].toString(),
      label: json[labelKey].toString(),
      value: json,
    );
  }

  @override
  String toString() => label;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectOption &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          label == other.label;

  @override
  int get hashCode => id.hashCode ^ label.hashCode;
}
class AuthSelectOption extends StatefulWidget {
  final List<SelectOption> options;
  final SelectOption? selectedOption;
  final Function(SelectOption) onChanged;
  final String hint;
  final String? labelText;
  final Color? fillColor;
  final Widget? prefixIcon;
  final bool isDisabled;
  final bool enableSearch; // Aktifkan search jika > 10 items
  final int searchThreshold; // Minimal items untuk show search

  const AuthSelectOption({
    super.key,
    required this.options,
    required this.onChanged,
    this.selectedOption,
    this.hint = 'Pilih opsi',
    this.labelText,
    this.fillColor = AppColors.surface,
    this.prefixIcon,
    this.isDisabled = false,
    this.enableSearch = true,
    this.searchThreshold = 10,
  });

  @override
  State<AuthSelectOption> createState() => _AuthSelectOptionState();
}

class _AuthSelectOptionState extends State<AuthSelectOption> {
  SelectOption? _selectedOption;
  String _searchQuery = '';
  late List<SelectOption> _filteredOptions;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedOption;
    _filteredOptions = widget.options;
  }

  @override
  void didUpdateWidget(AuthSelectOption oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedOption != widget.selectedOption) {
      setState(() {
        _selectedOption = widget.selectedOption;
      });
    }
    if (oldWidget.options != widget.options) {
      _updateFilteredOptions();
    }
  }

  void _updateFilteredOptions() {
    setState(() {
      if (_searchQuery.isEmpty) {
        _filteredOptions = widget.options;
      } else {
        _filteredOptions = widget.options
            .where((option) =>
                option.label.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();
      }
    });
  }

  void _onSearchChanged(String query) {
    _searchQuery = query;
    _updateFilteredOptions();
  }

  SelectOption? _getValidSelectedOption() {
    if (_selectedOption == null) return null;
    
    try {
      return _filteredOptions.firstWhere(
        (option) => option == _selectedOption,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.options.length < widget.searchThreshold || !widget.enableSearch) {
      return DropdownButtonFormField<SelectOption>(
        value: _selectedOption,
        onChanged: widget.isDisabled
            ? null
            : (SelectOption? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedOption = newValue;
                  });
                  widget.onChanged(newValue);
                }
              },
        items: widget.options.map<DropdownMenuItem<SelectOption>>((SelectOption option) {
          return DropdownMenuItem<SelectOption>(
            value: option,
            child: Text(
              option.label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
        decoration: AuthInputDecoration.base(
          labelText: widget.labelText,
          hintText: widget.hint,
          prefixIcon: widget.prefixIcon,
          fillColor: widget.fillColor,
        ),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        dropdownColor: Theme.of(context).scaffoldBackgroundColor,
        isExpanded: true,
      );
    }

    // Jika items banyak, gunakan dropdown dengan search
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search field
        TextField(
          enabled: !widget.isDisabled,
          onChanged: _onSearchChanged,
          decoration: AuthInputDecoration.base(
            hintText: 'Search ${widget.hint} ...',
            prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
          ).copyWith(
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        // Dropdown dengan filtered items
        DropdownButtonFormField<SelectOption>(
          value: _getValidSelectedOption(),
          onChanged: widget.isDisabled || _filteredOptions.isEmpty
              ? null
              : (SelectOption? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedOption = newValue;
                      _searchQuery = '';
                      _updateFilteredOptions();
                    });
                    widget.onChanged(newValue);
                  }
                },
          items: _filteredOptions.isEmpty
              ? [
                  DropdownMenuItem<SelectOption>(
                    value: null,
                    child: Text(
                      'Tidak ada hasil',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.error
                      ),
                    ),
                  )
                ]
              : _filteredOptions.map<DropdownMenuItem<SelectOption>>((SelectOption option) {
                  return DropdownMenuItem<SelectOption>(
                    value: option,
                    child: Text(
                      option.label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
          decoration: AuthInputDecoration.base(
            labelText: widget.labelText,
            hintText: 'Select from search result',
            prefixIcon: widget.prefixIcon,
            fillColor: widget.fillColor,
          ),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: Theme.of(context).scaffoldBackgroundColor,
          isExpanded: true,
        ),
      ],
    );
  }
}