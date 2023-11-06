import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SourabhPage extends StatefulWidget {
  const SourabhPage({Key? key}) : super(key: key);

  @override
  State<SourabhPage> createState() => _SourabhPageState();
}

class _SourabhPageState extends State<SourabhPage> {
 @override
 void initState() {
  super.initState();
  SystemChrome.setSystemUIOverlayStyle( const SystemUiOverlayStyle(
    statusBarColor:  Color.fromARGB(255, 71, 117, 72),
  ));
 }
 
 File? imageFile;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: () async {
      // Handle the back button press here and close the app
      // You can use `SystemNavigator.pop()` to close the app
      SystemNavigator.pop();
      return true; // Return true to prevent the default back button behavior
    },

    
    child :Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Add Image / Icon',
          style: GoogleFonts.metal(color: Colors.grey,),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(11),
            padding:
                const EdgeInsets.only(top: 17, bottom: 17, left: 26, right: 26),
            decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(96, 64, 63, 63)),
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                Text(
                  'Upload Image',
                  style: GoogleFonts.metal(color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                  
style: ElevatedButton.styleFrom(
                     backgroundColor: Color.fromARGB(255, 71, 117, 72),
                     shadowColor: const Color.fromARGB(255, 48, 64, 49),

                     ),

                    onPressed: () async {
                      Map<Permission, PermissionStatus> statuses = await [
                        Permission.storage,
                        Permission.camera,
                      ].request();
                      if (statuses[Permission.storage]!.isGranted &&
                          statuses[Permission.camera]!.isGranted) {
                        showImagePicker(context);
                      } else {
                        print('No permission provided');
                      }
                    },
                    child: Text('Choose from Device'),
                  ),
                ),
                const SizedBox(height: 20.0),
                // Conditional rendering of the image
                if (imageFile == null)
                  const SizedBox()
                else
                  ClipRRect(
                    child: Image.file(
                      imageFile!,
                      height: 300.0,
                      width: 300.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  final picker = ImagePicker();

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Card(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5.2,
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    child: const Column(
                      children: [
                        Icon(
                          Icons.image,
                          size: 60.0,
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          "Gallery",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _imgFromGallery() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _cropImage(File(pickedFile.path));
      }
    } else {
      print('Permission denied');
    }
  }

 _cropImage(File imgFile) async {
  final croppedFile = await ImageCropper().cropImage(
    sourcePath: imgFile.path,
    aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1), // Set your desired aspect ratio here
  );

    if (croppedFile != null) {
      imageCache.clear();
      setState(() {
        imageFile = File(croppedFile.path);
      });

      // ignore: use_build_context_synchronously
      showDialog(

        context: context,
        builder: (context) {
          return Center(
            child: Container(
              width: 400,
              height: 450,
              
              child: AlertDialog(
               shadowColor:const Color.fromARGB(255, 48, 64, 49),
                title:  Center(child: Text('uploaded Image',style: GoogleFonts.metal(color: Colors.grey),)),
                content: Column(
                  children: [
                    Image.file(
                      imageFile!,
                      height: 200.0,
                      width: 200.0,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 40,),
                    ElevatedButton(
                    
                     style: ElevatedButton.styleFrom(
                     backgroundColor: Color.fromARGB(255, 71, 117, 72),
                     shadowColor: const Color.fromARGB(255, 48, 64, 49),
                     minimumSize: const Size(200, 50),
                     

                     ),
                     
                      onPressed: () {
                        
                        setState(() {
                         Navigator.of(context, rootNavigator: true).pop();
                        });
                      },
                      child: Text('Submit'),
                      
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
       
    }
  }
}


