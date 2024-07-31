import 'package:auto_complete_location/controller/auto_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AutoComplete extends StatelessWidget {
  AutoComplete({super.key});

  final AutoController autoController = Get.put(AutoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AutoComplete Example'),
        backgroundColor: Colors.cyan,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              alignment: Alignment.center,
              width: 400,
              height: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    " Auto Complete Location Example Flutter",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: autoController.addressSearch,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.place, color: Colors.redAccent,),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                            color: Colors.orangeAccent, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                            color: Colors.grey, width: 2.0),
                      ),
                      hintText: 'Location',
                    ),
                    onChanged: (String value) {
                      autoController.getPlaceSuggestions(value);
                      debugPrint('Value entered: $value');
                    },
                  ),
                  Expanded(
                    child: Obx(() {
                      if (autoController.placeList.isEmpty) {
                        return SizedBox(); // Trả về một SizedBox để ẩn danh sách
                      } else {
                        return
                          Container(
                            width: 400,
                            constraints: BoxConstraints(maxHeight: 200),
                      decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                      BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8.0,
                      ),
                      ],
                      ),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                            children: [
                              Expanded(
                                child: ListView.separated(
                                  itemCount: autoController.placeList.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(autoController.placeList[index]
                                          ['description']),
                                      onTap: () {
                                        // Cập nhật giá trị cho TextField và ẩn danh sách
                                        autoController.addressSearch.text =
                                            autoController.placeList[index]
                                                ['description'];
                                        autoController.placeList
                                            .clear(); // Xóa danh sách gợi ý
                                        debugPrint(
                                            'Selected place: ${autoController.placeList[index]['description']}');
                                      },
                                    );
                                  }, separatorBuilder: (BuildContext context, int index) {  return Divider(color: Colors.grey.shade300,); },
                                ),
                              ),
                            ],
                                                    ),
                          );
                      }
                    }),
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
