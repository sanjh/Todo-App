import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:todo_app/shared/styles/colors.dart';
import 'package:todo_app/shared/utilities.dart';

class MyTextfield extends StatelessWidget {
  final IconData icon;
  final String hint;
  final FormFieldValidator<String> validator;
  final TextEditingController textEditingController;
  final TextInputType keyboardtype;
  final bool obscure;
  final bool readonly;
  final bool showicon;
  final int? maxlenght;
  final Function()? ontap;
  const MyTextfield(
      {Key? key,
      required this.hint,
      required this.icon,
      required this.validator,
      required this.textEditingController,
      this.obscure = false,
      this.readonly = false,
      this.showicon = true,
      this.ontap,
      this.keyboardtype = TextInputType.text,
      this.maxlenght = null})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      maxLines: 1,
      maxLength: maxlenght,
      readOnly: readonly,
      obscureText: obscure,
      keyboardType: keyboardtype,
      onTap: readonly ? ontap : null,
      controller: textEditingController,
      style: Theme.of(context).textTheme.headline1?.copyWith(
            fontSize: 9.sp,
            color: Appcolors.kBlackColor800,
          ),
      decoration: InputDecoration(
          fillColor: Appcolors.kGreyColor100,
          filled: true,
          hintText: hint,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Appcolors.kGreyColor900),
            borderRadius: BorderRadius.circular(size),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Appcolors.kWhiteColor),
            borderRadius: BorderRadius.circular(size),
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.3.h),
          hintStyle: Theme.of(context).textTheme.headline1?.copyWith(
                fontSize: 9.sp,
                color: Appcolors.kGreyColor900,
              ),
          prefixIcon: showicon
              ? Icon(
                  icon,
                  size: 22,
                  color: Appcolors.kGreyColor900,
                )
              : null,
          suffixIcon: readonly
              ? Icon(
                  icon,
                  size: 22,
                  color: Appcolors.kGreyColor900,
                )
              : null),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
    );
  }
}
