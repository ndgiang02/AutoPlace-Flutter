import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';

class AutoComplete extends StatelessWidget {
  AutoComplete({super.key});

  final HomeController autoController = Get.put(HomeController());

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
        child: Center(
          child: Container(
            alignment: Alignment.center,
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Auto Complete Location Example Flutter",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20,),
                Column(
                  children: [
                    TextField(
                      controller: autoController.pickupController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.place,
                          color: Colors.redAccent,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.orangeAccent,
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        hintText: 'Pickup Location',
                      ),
                      onChanged: (String value) async {
                        autoController.getPickupPlace(value);
                        debugPrint('Pickup Value entered: $value');
                      },
                    ),
                    Obx(() {
                      return Visibility(
                        visible: autoController.pickupPlaceList.isNotEmpty,
                        child: Container(
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
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: autoController.pickupPlaceList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(autoController
                                    .pickupPlaceList[index]['description']!),
                                onTap: () {
                                  autoController.pickupController.text =
                                      autoController.pickupPlaceList[index]
                                          ['description']!;
                                  autoController.pickupPlaceList.clear();
                                  autoController.fetchLatLngFromView(
                                      autoController.pickupController.text);
                                },
                                leading: Icon(Icons.location_on_outlined,
                                    color: Colors.redAccent),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider(
                                color: Colors.grey.shade300,
                              );
                            },
                          ),
                        ),
                      );
                    }),
                    SizedBox(
                      height: 20,
                    ),
                    Obx(() {
                      return Visibility(
                        visible: autoController.pickupPlaceList.isEmpty,
                        child: TextField(
                          controller: autoController.destinationController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.place,
                              color: Colors.greenAccent,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color: Colors.orangeAccent,
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                            hintText: 'Destination',
                          ),
                          onChanged: (String value) {
                            autoController.getDestinationPlace(value);
                            debugPrint('Destination Value entered: $value');
                          },
                        ),
                      );
                    }),
                    Obx(() {
                      return Visibility(
                        visible: autoController.destinationPlaceList.isNotEmpty,
                        child: Container(
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
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount:
                                autoController.destinationPlaceList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                    autoController.destinationPlaceList[index]
                                        ['description']!),
                                onTap: () {
                                  autoController.destinationController.text =
                                      autoController.destinationPlaceList[index]
                                          ['description']!;
                                  autoController.destinationPlaceList.clear();
                                },
                                leading: Icon(Icons.location_on_outlined,
                                    color: Colors.greenAccent),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider(
                                color: Colors.grey.shade300,
                              );
                            },
                          ),
                        ),
                      );
                    }),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await autoController.getDistanceBetweenLocations();
                      },
                      child: Text('Calculate Distance'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Obx(() {
                      return Text(
                        'Distance: ${autoController.distance.value.toStringAsFixed(2)} km',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
