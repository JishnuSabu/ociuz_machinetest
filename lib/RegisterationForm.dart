import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("mybox");
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RegisterationPage(),
  ));
}

class RegisterationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterationPageState();
}

class RegisterationPageState extends State {
  List<Map<String, dynamic>> items = [];
  final box = Hive.box('mybox');
  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  void _refreshItems() {
    final item = box.keys.map((Customkey) {
      final value = box.get(Customkey);
      return {
        "key": Customkey,
        "name": value["name"],
        "email": value['email'],
        "phone": value["phone"],
        "designation": value["designation"],
        "address": value["address"],
      };
    }).toList();
    setState(() {
      items = item.toList();
    });
  }

  Future<void> additem(Map<String, dynamic> newItem) async {
    await box.add(newItem);
    _refreshItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee List"),
      ),
      body: items.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20),
              itemCount: items.length,
              itemBuilder: (_, index) {
                final currentItem = items[index];
                return Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.grey),
                  margin: const EdgeInsets.all(10),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 75.0),
                      child: Row(children: [
                        Text(
                          currentItem['name'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        IconButton(
                            onPressed: () {
                              _showForm(context, currentItem['key']);
                            },
                            icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              deleteitem(currentItem['key']);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ]),
                    ),
                  ),
                );
              }),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            "Register Here",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          FloatingActionButton(
            onPressed: () => _showForm(context, null),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  final name_controller = TextEditingController();
  final email_controller = TextEditingController();
  final phone_controller = TextEditingController();
  final designation_controller = TextEditingController();
  final address_controller = TextEditingController();

  _showForm(BuildContext context, int? itemKey) async {
    showModalBottomSheet(
        backgroundColor: Colors.green[600],
        isScrollControlled: true,
        elevation: 3,
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 15,
              left: 15,
              right: 15,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 1)),
                  child: TextField(
                    controller: name_controller,
                    decoration: const InputDecoration(hintText: 'Name'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 1)),
                  child: TextField(
                    controller: email_controller,
                    decoration: const InputDecoration(hintText: 'Email'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 1)),
                  child: TextFormField(
                    controller: phone_controller,
                    decoration: const InputDecoration(hintText: 'Phone'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 1)),
                  child: TextField(
                    controller: designation_controller,
                    decoration: const InputDecoration(hintText: 'Designation'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 1)),
                  child: TextField(
                    controller: address_controller,
                    decoration: const InputDecoration(hintText: 'Address'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    onPressed: () async {
                      if (itemKey == null &&
                          name_controller.text != '' &&
                          email_controller.text != '' &&
                          phone_controller.text != '' &&
                          designation_controller.text != '' &&
                          address_controller.text != '') {
                        additem({
                          'name': name_controller.text.trim(),
                          'email': email_controller.text.trim(),
                          'phone': phone_controller.text.trim(),
                          'designation': designation_controller.text.trim(),
                          'address': address_controller.text.trim()
                        });
                      }
                      Navigator.of(context).pop();
                    },
                    child: const Text("Save Form"))
              ],
            ),
          );
        });
  }

  Future<void> Edititem(int itemkey, Map<String, dynamic> data) async {
    await box.put(itemkey, data);
    _refreshItems();
  }

  Future<void> deleteitem(int itemkey) async {
    await box.delete(itemkey);
    _refreshItems();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Successfully Deleted the item")));
  }
}
