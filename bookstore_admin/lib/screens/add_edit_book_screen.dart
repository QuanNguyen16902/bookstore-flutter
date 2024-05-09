import 'dart:io';

import 'package:bookstore_admin/consts/app_constant.dart';
import 'package:bookstore_admin/consts/validator.dart';
import 'package:bookstore_admin/models/book_model.dart';
import 'package:bookstore_admin/services/app_function.dart';
import 'package:bookstore_admin/widget/subtitle_text.dart';
import 'package:bookstore_admin/widget/title_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AddOrEditBookScreen extends StatefulWidget {
  static const routeName = "/AddOrEditBookScreen";
  const AddOrEditBookScreen({super.key, this.bookModel});
  final BookModel? bookModel;
  @override
  State<AddOrEditBookScreen> createState() => _AddOrEditBookScreenState();
}

class _AddOrEditBookScreenState extends State<AddOrEditBookScreen> {
  final formKey = GlobalKey<FormState>();
  XFile? imageBook;

  late TextEditingController titleController,
      authorController,
      priceController,
      descriptionController,
      quantityController;
  String? categoryValue;
  bool isEditing = false;
  String? bookNetWorkImage;

  @override
  void initState() {
    if (widget.bookModel != null) {
      isEditing = true;
      bookNetWorkImage = widget.bookModel!.bookImage;
      categoryValue = widget.bookModel!.bookCategory;
    }
    titleController = TextEditingController(
        text: widget.bookModel == null ? "" : widget.bookModel!.bookTitle);
    authorController = TextEditingController(
        text: widget.bookModel == null ? "" : widget.bookModel!.bookAuthor);
    priceController = TextEditingController(
        text: widget.bookModel == null ? "" : widget.bookModel!.bookPrice);
    descriptionController = TextEditingController(
        text:
            widget.bookModel == null ? "" : widget.bookModel!.bookDescription);
    quantityController = TextEditingController(
        text: widget.bookModel == null ? "" : widget.bookModel!.bookQuantity);

    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    authorController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  void clearForm() {
    titleController.clear();
    authorController.clear();
    priceController.clear();
    descriptionController.clear();
    quantityController.clear();
    removePickedImage();
  }

  Future<void> uploadBook() async {
    if (imageBook == null) {
      MyAppFunction.showErrorOrWarningDialog(
        context: context,
        subtitle: "Bạn chưa chọn ảnh",
        fct: () {},
      );
      return;
    }
    final isValid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {}
  }

  Future<void> editBook() async {
    final isValid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (imageBook == null && bookNetWorkImage == null) {
      MyAppFunction.showErrorOrWarningDialog(
        context: context,
        subtitle: "Bạn hãy chọn ảnh",
        fct: () {},
      );
      return;
    }
    if (isValid) {}
  }

  Future<void> removePickedImage() async {
    setState(() {
      imageBook = null;
      bookNetWorkImage = null;
    });
  }

  Future<void> imagePicker() async {
    final ImagePicker picker = ImagePicker();
    await MyAppFunction.ImagePickerDialog(
      context: context,
      cameraFunct: () async {
        imageBook = await picker.pickImage(source: ImageSource.camera);
      },
      galeryFunct: () async {
        imageBook = await picker.pickImage(source: ImageSource.gallery);
      },
      removeFunct: () {
        removePickedImage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        bottomSheet: SizedBox(
          height: kBottomNavigationBarHeight + 10,
          child: Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      clearForm();
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text("Clear")),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.upload),
                  label: Text(isEditing ? "Edit Book" : "Upload book"),
                  onPressed: () {
                    if (isEditing) {
                      editBook();
                    } else {
                      uploadBook();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: TitleTextWidget(
              label: isEditing ? "Edit Book" : "Upload a new book"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                if (isEditing && bookNetWorkImage != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      bookNetWorkImage!,
                      height: size.width * 0.5,
                      alignment: Alignment.center,
                    ),
                  )
                ] else if (imageBook == null) ...[
                  SizedBox(
                    width: size.width * 0.4 + 10,
                    height: size.width * 0.4,
                    child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12),
                        padding: const EdgeInsets.all(6),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.image_outlined,
                                  size: 80, color: Colors.blue),
                              TextButton(
                                child: const Text("Chọn ảnh"),
                                onPressed: () {
                                  imagePicker();
                                },
                              )
                            ],
                          ),
                        )),
                  ),
                ] else ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(
                        imageBook!.path,
                      ),
                      height: size.width * 0.5,
                      alignment: Alignment.center,
                    ),
                  )
                ],
                if (imageBook != null || bookNetWorkImage != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          imagePicker();
                        },
                        child: const Text("Chọn ảnh khác"),
                      ),
                      TextButton(
                          onPressed: () {
                            removePickedImage();
                          },
                          child: const Text(
                            "Remove image",
                            style: TextStyle(color: Colors.red),
                          ))
                    ],
                  )
                ],
                const SizedBox(
                  height: 20,
                ),
                DropdownButton(
                    items: AppConstant.categoriesDropDownList,
                    value: categoryValue,
                    hint: const Text("Chọn Category"),
                    onChanged: (String? value) {
                      setState(() {
                        categoryValue = value;
                      });
                    }),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: titleController,
                          key: const ValueKey("Title"),
                          maxLength: 30,
                          minLines: 1,
                          maxLines: 2,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          decoration: const InputDecoration(
                            hintText: "Book Title",
                          ),
                          validator: (value) {
                            return MyValidator.uploadBookText(
                              value: value,
                              toBeReturnedString: "Hãy nhập đúng title",
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: authorController,
                          key: const ValueKey("Author"),
                          maxLength: 20,
                          minLines: 1,
                          maxLines: 2,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          decoration: const InputDecoration(
                            hintText: "Book Author",
                          ),
                          validator: (value) {
                            return MyValidator.uploadBookText(
                              value: value,
                              toBeReturnedString: "Hãy nhập tác giả",
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: TextFormField(
                                controller: priceController,
                                key: const ValueKey("Price \$"),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^(\d+)?\.?\d{0,2}'),
                                  ),
                                ],
                                decoration: const InputDecoration(
                                    hintText: "Price",
                                    prefix: SubtitleTextWidget(
                                      label: "\$ ",
                                      color: Colors.blue,
                                      fontSize: 16,
                                    )),
                                validator: (value) {
                                  return MyValidator.uploadBookText(
                                      value: value,
                                      toBeReturnedString: "Giá bán trống");
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                                flex: 1,
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: quantityController,
                                  keyboardType: TextInputType.number,
                                  key: const ValueKey("Quantity"),
                                  decoration: const InputDecoration(
                                    hintText: "quantity",
                                  ),
                                  validator: (value) {
                                    MyValidator.uploadBookText(
                                        value: value,
                                        toBeReturnedString: "Số lượng trống");
                                  },
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          key: const ValueKey("Description"),
                          controller: descriptionController,
                          minLines: 5,
                          maxLines: 8,
                          maxLength: 1000,
                          textCapitalization: TextCapitalization.sentences,
                          decoration:
                              const InputDecoration(hintText: "Mô tả sách"),
                          validator: (value) {
                            MyValidator.uploadBookText(
                                value: value,
                                toBeReturnedString: "Mô tả đang rỗng");
                          },
                          onTap: () {},
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
