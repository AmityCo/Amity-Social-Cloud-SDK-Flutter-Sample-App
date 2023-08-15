import 'package:amity_sdk/amity_sdk.dart';
import 'package:flutter/material.dart';

class CommunityCategoryWidget extends StatefulWidget {
  const CommunityCategoryWidget({
    Key? key,
    required this.amityCommunityCategory,
    required this.valueChanged,
    this.selected = false,
  }) : super(key: key);
  final AmityCommunityCategory amityCommunityCategory;
  final ValueChanged valueChanged;
  final bool selected;
  @override
  State<CommunityCategoryWidget> createState() =>
      _CommunityCategoryWidgetState();
}

class _CommunityCategoryWidgetState extends State<CommunityCategoryWidget> {
  bool _value = false;
  @override
  void initState() {
    _value = widget.selected;
    print(_value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(.1),
          borderRadius: BorderRadius.circular(8)),
      child: CheckboxListTile(
        secondary: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: Colors.grey.withOpacity(.3)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: widget.amityCommunityCategory.avatarId != null
              ? Image.network(
                  widget.amityCommunityCategory.avatar!.fileUrl!,
                  fit: BoxFit.fill,
                )
              : Image.asset('assets/user_placeholder.png'),
        ),
        title: Text(widget.amityCommunityCategory.name!),
        subtitle: Text(widget.amityCommunityCategory.categoryId!),
        onChanged: (bool? value) {
          setState(() {
            _value = value ?? false;
            widget.valueChanged(_value);
          });
        },
        value: _value,
      ),
    );
  }
}
