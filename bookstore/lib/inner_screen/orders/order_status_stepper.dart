import 'package:bookstore/models/order_model.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';

class OrderStatusStepper extends StatelessWidget {
  final OrderModel order;

  OrderStatusStepper({required this.order});

  @override
  Widget build(BuildContext context) {
   
    const steps = [
        EasyStep(
          title: 'Processing',
          icon: Icon(Icons.work),
        ),
        EasyStep(
          title: 'Picking',
          icon: Icon(Icons.local_shipping),
        ),
        EasyStep(
          title: 'Shipping',
          icon: Icon(Icons.airport_shuttle),
        ),
        EasyStep(
          title: 'Delivered',
          icon: Icon(Icons.home),
        ),
      ];
    return EasyStepper(
      activeStep: statusToStepIndex(order.status),
      steps: steps,
      onStepReached: (index) {
        order.updateStatusByStepIndex(index);
      },
      stepRadius: 20,
      activeStepTextColor: Colors.black87,
      finishedStepBackgroundColor: Colors.green,
      lineStyle: LineStyle(
        defaultLineColor: Colors.grey.shade300,
        lineLength: (MediaQuery.of(context).size.width * 0.5) / steps.length,
      ),
    );
  }
}

int statusToStepIndex(OrderStatus status) {

  switch (status) {
    case OrderStatus.processing:
      return 1;
    case OrderStatus.picking:
      return 2;
    case OrderStatus.shipping:
      return 3;
    case OrderStatus.delivered:
      return 4;
    default:
      return 0;
  }
}

OrderStatus stepIndexToStatus(int index) {
  switch (index) {
    case 0:
      return OrderStatus.processing;
    case 1:
      return OrderStatus.picking;
    case 2:
      return OrderStatus.shipping;
    case 3:
      return OrderStatus.delivered;
    default:
      return OrderStatus.confirmed;
  }
}
