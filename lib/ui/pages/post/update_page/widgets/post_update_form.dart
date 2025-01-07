import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/_core/utils/validator_util.dart';
import 'package:flutter_blog/ui/widgets/custom_elavated_button.dart';
import 'package:flutter_blog/ui/widgets/custom_text_area.dart';
import 'package:flutter_blog/ui/widgets/custom_text_form_field.dart';

import '../../../../../data/model/post.dart';

class PostUpdateForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _content = TextEditingController();

  Post post;
  PostUpdateForm(this.post);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          CustomTextFormField(
            controller: _title,
            initValue: "${post.title}",
            hint: "Title",
          ),
          const SizedBox(height: smallGap),
          CustomTextArea(
            controller: _content,
            hint: "${post.content}", // ""안에 넣으면 null point exception안터져
          ),
          const SizedBox(height: largeGap),
          CustomElevatedButton(
            text: "글 수정하기",
            click: () {},
          ),
        ],
      ),
    );
  }
}
