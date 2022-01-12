import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final IconData icon;
  final String? hint;
  final String? errorText;
  final bool isObscure;
  final bool isIcon;
  final TextInputType? inputType;
  final TextEditingController? textController;
  final EdgeInsets padding;
  final Color hintColor;
  final Color iconColor;
  final FocusNode? focusNode;
  final ValueChanged? onFieldSubmitted;
  final ValueChanged? onChanged;
  final bool autoFocus;
  final TextInputAction? inputAction;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        controller: textController ?? null,
        focusNode: focusNode,
        onTap: () {
          onTap!();
        },
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        autofocus: autoFocus,
        textInputAction: inputAction,
        obscureText: this.isObscure,
        keyboardType: this.inputType,
        style: Theme.of(context).textTheme.bodyText1,
        decoration: InputDecoration(hintText: this.hint, hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(color: hintColor), errorText: errorText, counterText: '', icon: this.isIcon ? Icon(this.icon, color: iconColor) : null),
      ),
    );
  }

  const TextFieldWidget({
    Key? key,
    required this.icon,
    this.onTap,
    this.errorText,
    this.textController,
    this.inputType,
    this.hint,
    this.isObscure = false,
    this.isIcon = true,
    this.padding = const EdgeInsets.all(0),
    this.hintColor = Colors.grey,
    this.iconColor = Colors.grey,
    this.focusNode,
    this.onFieldSubmitted,
    this.onChanged,
    this.autoFocus = false,
    this.inputAction,
  }) : super(key: key);
}
