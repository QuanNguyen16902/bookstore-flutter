import 'package:bookstore/services/assets_manager.dart';
import 'package:bookstore/widgets/subtitle_text.dart';
import 'package:bookstore/widgets/title_text.dart';
import 'package:flutter/material.dart';

class MyAppFunction {
  static Future<void> showErrorOrWarningDialog({
    required BuildContext context,
    required String subtitle,
    bool isError = true,
    required Function fct,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Image.asset(
                isError ? AssetManager.error : AssetManager.warning,
                height: 60,
                width: 60,
              ),
              const SizedBox(
                height: 16.0,
              ),
              SubtitleTextWidget(
                label: subtitle,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Visibility(
                  visible: !isError,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const SubtitleTextWidget(
                      label: "Cancel",
                      color: Colors.green,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    fct();
                    Navigator.pop(context);
                  },
                  child: const SubtitleTextWidget(
                    label: "OK",
                    color: Colors.red,
                  ),
                ),
              ])
            ]),
          );
        });
  }

  static Future<void> ImagePickerDialog ({
    required BuildContext context,
    required Function cameraFunct,
    required Function galeryFunct,
    required Function removeFunct,

    }) async{
    await showDialog(context: context, builder: (BuildContext context){
      return  AlertDialog(
          title: const Center(
            child: TitleTextWidget(
               label: "Choose Option",),
          ),
          content: SingleChildScrollView(
            child: ListBody(
            children: [
              TextButton.icon(
                onPressed: (){
                  cameraFunct();
                  if(Navigator.canPop(context)){
                    Navigator.pop(context);
                  }
                }, 
                icon: const Icon(Icons.camera),
                label: const Text("Camera"),
                ),
                const SizedBox(
                  height: 10,
                ),
              TextButton.icon(
                onPressed: (){
                  galeryFunct();
                  if(Navigator.canPop(context)){
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.browse_gallery),
                label: const Text("Galery"),
                ),
                      const SizedBox(
                  height: 10,
                ),
              TextButton.icon(
                onPressed: (){
                  removeFunct();
                  if(Navigator.canPop(context)){
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.remove_circle_outline),
                label: const Text("Remove"),
                ),
          ],
          ),
          ),
      );
    });
    
  }
}
