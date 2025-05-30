// ignore_for_file: non_constant_identifier_names

import 'package:autowheel_workshop/utils/components/library.dart';

Widget dropdownTextfield(
  BuildContext context,
  String? labelText,
  Widget? widget,
) {
  return SizedBox(
    height: (Responsive.isMobile(context)) ? 45 : 40,
    child: TextFormField(
      readOnly: true,
      initialValue: " ",
      decoration: InputDecoration(
        fillColor: AppColor.colWhite,
        filled: true,
        suffix: SizedBox(width: double.infinity, child: widget),
        labelText: labelText,
        labelStyle: rubikTextStyle(15, FontWeight.w400, AppColor.colLabel),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.colBlack, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.colBlack, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.colBlack, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.colBlack, width: 1),
        ),
      ),
    ),
  );
}

Widget defaultDropDown({
  required Map<String, dynamic>? value,
  required List<DropdownMenuItem<Map<String, dynamic>>>? items,
  required void Function(Map<String, dynamic>?)? onChanged,
}) {
  return DropdownButton<Map<String, dynamic>>(
    underline: Container(),
    value: value,
    items: items,
    icon: const Icon(Icons.keyboard_arrow_down_outlined),
    isExpanded: true,
    onChanged: onChanged,
  );
}

textformfiles(
  TextEditingController? controller, {
  Widget? label,
  TextInputType? keyboardType,
  int? maxLength,
  Widget? suffixIcon,
  Widget? prefixIcon,
  String? Function(String?)? validator,
  Function(String)? onChanged,
  Function(String)? onFieldSubmitted,
  String? labelText,
  bool readOnly = false,
  bool obscureText = false,
  TextCapitalization textCapitalization = TextCapitalization.sentences,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      TextFormField(
        onFieldSubmitted: onFieldSubmitted,
        textCapitalization: textCapitalization,
        keyboardType: keyboardType,
        controller: controller,
        readOnly: readOnly,
        maxLength: maxLength,
        obscureText: obscureText,
        validator: validator,
        onChanged: onChanged,
        style: rubikTextStyle(15, FontWeight.w500, AppColor.colBlack),
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          labelText: labelText,
          counterText: "",
          filled: true,
          fillColor: AppColor.colWhite,
          prefixIcon: prefixIcon,
          label: label,
          labelStyle: rubikTextStyle(14, FontWeight.w500, AppColor.colLabel),
          isDense: true,
          contentPadding: const EdgeInsets.only(top: 28, left: 15, right: 10),
          border: UnderlineInputBorder(),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: AppColor.colBlack, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: AppColor.colBlack, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: AppColor.colBlack, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: AppColor.colBlack, width: 1),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: AppColor.colBlack, width: 1),
          ),
        ),
      ),
    ],
  );
}

DropdownButtonHideUnderline searchDropDown(
  BuildContext context,
  String hintText,
  List<DropdownMenuItem<Map<String, dynamic>>>? items,
  Map<String, dynamic>? value,
  Function(Map<String, dynamic>?)? onChanged,
  TextEditingController? controller,
  Function(String)? onChangedText,
  String hintTextInside,
  Function(bool)? onMenuStateChange,
) {
  return DropdownButtonHideUnderline(
    child: DropdownButton2<Map<String, dynamic>>(
      isExpanded: true,
      // ignore: prefer_const_constructors
      iconStyleData: IconStyleData(icon: Icon(Icons.keyboard_arrow_down)),
      alignment: Alignment.centerLeft,

      hint: Text(
        hintText,
        style: rubikTextStyle(15, FontWeight.w500, AppColor.colBlack),
      ),
      items: items,
      value: value,
      onChanged: onChanged,
      buttonStyleData: ButtonStyleData(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: (Responsive.isMobile(context)) ? 45 : 40,
        width: 200,
      ),
      dropdownStyleData: const DropdownStyleData(maxHeight: 200),
      menuItemStyleData: const MenuItemStyleData(height: 40),
      dropdownSearchData: DropdownSearchData(
        searchController: controller,
        searchInnerWidgetHeight: 50,
        searchInnerWidget: Container(
          height: 50,
          padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8),
          child: TextFormField(
            expands: true,
            readOnly: false,
            maxLines: null,
            controller: controller,
            onChanged: onChangedText,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              hintText: hintTextInside,
              hintStyle: const TextStyle(fontSize: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
      onMenuStateChange: onMenuStateChange,
    ),
  );
}
