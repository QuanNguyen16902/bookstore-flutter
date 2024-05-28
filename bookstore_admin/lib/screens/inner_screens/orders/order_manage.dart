import 'package:bookstore_admin/consts/validator.dart';
import 'package:bookstore_admin/models/order_model.dart';
import 'package:bookstore_admin/screens/loadding_widget.dart';
import 'package:bookstore_admin/services/app_function.dart';
import 'package:bookstore_admin/widget/title_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdateOrderScreen extends StatefulWidget {
  static const routeName = "/UpdateOrderScreen";
  const UpdateOrderScreen({super.key, this.orderModel});
  final OrderModel? orderModel;
  @override
  State<UpdateOrderScreen> createState() => _UpdateOrderScreenState();
}

class _UpdateOrderScreenState extends State<UpdateOrderScreen> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController nameController,
      addressController,
      phoneNumberController;
  late OrderStatus _selectedStatus;
  bool isEditing = false;
  bool? isLoading = false;
  bool? isConfirm = false;
  @override
  void initState() {
    if (widget.orderModel != null) {
      isEditing = true;
      _selectedStatus =
          widget.orderModel!.status; // Initialize the selected status
    } else {
      _selectedStatus = OrderStatus.confirmed; // Default status
    }
    nameController = TextEditingController(
        text: widget.orderModel == null ? "" : widget.orderModel!.name);
    addressController = TextEditingController(
        text: widget.orderModel == null ? "" : widget.orderModel!.address);
    phoneNumberController = TextEditingController(
        text: widget.orderModel == null ? "" : widget.orderModel!.phoneNumber);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  void clearForm() {
    nameController.clear();
    addressController.clear();
    phoneNumberController.clear();
  }

  Future<void> _updateOrderStatus() async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderModel!.orderId)
          .update({'status': _selectedStatus.toString().split('.').last});
      Fluttertoast.showToast(
        msg: 'Trạng thái đơn hàng đã được cập nhật thành công!',
        textColor: Colors.white,
      );
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Đã xảy ra lỗi khi cập nhật trạng thái đơn hàng: $error',
        textColor: Colors.red,
      );
    }
  }

  Future<void> confirmOrder() async {
    try {
      // Cập nhật trạng thái đơn hàng thành processing
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderModel!.orderId)
          .update({
        'status': OrderStatus.processing.toString().split('.').last,
        'confirmed': true,
      });

      // Hiển thị thông báo xác nhận đơn hàng
      Fluttertoast.showToast(
        msg: 'Đơn hàng đã được xác nhận thành công!',
        textColor: Colors.white,
      );

      // Sau khi xác nhận đơn hàng, hiển thị trạng thái đơn hàng để edit
      setState(() {
        widget.orderModel!.confirmed = true;
        _selectedStatus = OrderStatus.processing;
      });
    } catch (error) {
      // Hiển thị thông báo lỗi nếu có lỗi xảy ra
      Fluttertoast.showToast(
        msg: 'Đã xảy ra lỗi khi xác nhận đơn hàng: $error',
        textColor: Colors.red,
      );
    }
  }

  Future<void> editOrder() async {
    try {
      await FirebaseFirestore.instance
          .collection("orders")
          .doc(widget.orderModel!.orderId)
          .update({
        'userName': nameController.text,
        'address': addressController.text,
        'phoneNumber': phoneNumberController.text,
        'items': widget.orderModel!.items,
        'totalPrice': widget.orderModel!.totalPrice,
        'paymentMethod': widget.orderModel!.paymentMethod,
        'orderDate': widget.orderModel!.orderDate,
        'userId': widget.orderModel!.userId,
        'shippingDate': widget.orderModel!.shippingDate,
        'userPoints': widget.orderModel!.userPoints,
        'status': _selectedStatus.toString().split('.').last, //,
      });
      Fluttertoast.showToast(
        msg: "Đơn hàng được cập nhật thành công",
        textColor: Colors.white,
      );
      if (!mounted) return;
      MyAppFunction.showErrorOrWarningDialog(
          isError: false,
          context: context,
          subtitle: "Clear form?",
          fct: () {
            clearForm();
          });
    } on FirebaseException catch (error) {
      await MyAppFunction.showErrorOrWarningDialog(
          context: context, subtitle: error.toString(), fct: () {});
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error updating order: $error",
        textColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return LoadingWidget(
      isLoading: isLoading!,
      child: GestureDetector(
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
                    label: const Text("Edit Order"),
                    onPressed: () {
                      if (isEditing) {
                        editOrder();
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
                label:
                    "Order ID: [#${widget.orderModel!.orderId.replaceRange(5, null, '')}]"),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Name",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            TextFormField(
                              controller: nameController,
                              key: const ValueKey("userName"),
                              maxLength: 30,
                              minLines: 1,
                              maxLines: 2,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              validator: (value) {
                                return MyValidator.uploadBookText(
                                  value: value,
                                  toBeReturnedString: "Hãy nhập đúng name",
                                );
                              },
                            ),
                          
                            const Text(
                              "Địa chỉ", // Nhãn cho trường Name
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            TextFormField(
                              controller: addressController,
                              key: const ValueKey("address"),
                              maxLength: 100,
                              minLines: 1,
                              maxLines: 2,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              validator: (value) {
                                return MyValidator.uploadBookText(
                                  value: value,
                                  toBeReturnedString: "Hãy nhập địa chỉ",
                                );
                              },
                            ),
                           const Text(
                              "Số điện thoại", // Nhãn cho trường Name
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            TextFormField(
                              key: const ValueKey("phoneNumber"),
                              controller: phoneNumberController,
                              maxLength: 12,
                              validator: (value) {
                                MyValidator.uploadBookText(
                                  value: value,
                                  toBeReturnedString: "SDT đang trống",
                                );
                              },
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          !widget.orderModel!.confirmed
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Xác nhận đơn hàng:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      child: Text('Xác nhận đơn hàng'),
                                      onPressed: confirmOrder,
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Trạng thái hiện tại:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    DropdownButton<OrderStatus>(
                                      value: _selectedStatus,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedStatus = value!;
                                        });
                                      },
                                      items: OrderStatus.values.map((status) {
                                        return DropdownMenuItem<OrderStatus>(
                                          value: status,
                                          child: Text(
                                            status.toString().split('.').last,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: _updateOrderStatus,
                                      child: Text('Cập nhật trạng thái'),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
