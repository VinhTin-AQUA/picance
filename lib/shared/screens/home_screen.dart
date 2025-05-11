import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> toolButtons = [
      {
        'icon': Icons.auto_awesome,
        'text': 'upscaler'.tr,
        'onTap': () {
          Get.toNamed('/upscaler');
        },
      },
      {
        'icon': Icons.vertical_split,
        'text': 'split_image'.tr,
        'onTap': () {
          Get.toNamed('/split-image');
        },
      },
      {'icon': Icons.hd, 'text': 'enhance'.tr, 'isPro': true, 'onTap': () {}},
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 51, 236, 78),
                    Color(0xffe11d48),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 30,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        'Newtun',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(top: 20, right: 10, child: ClipRRect()),
                  Positioned(
                    bottom: 50,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Picance',
                          style: Theme.of(context).textTheme.headlineMedium!
                              .copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'Automatic Tools ',
                              style: Theme.of(context).textTheme.titleSmall!
                                  .copyWith(color: Colors.white),
                            ),
                            const Icon(
                              Icons.auto_awesome,
                              size: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Tools'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children:
                    toolButtons.map((tool) {
                      return _buildRoundedButton(
                        icon: tool['icon'],
                        text: tool['text'],
                        isPro: tool['isPro'] ?? false,
                        onTap: tool['onTap'],
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 1:
              Get.toNamed('/library');
              break;
            case 2:
              Get.toNamed('/settings');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'home'.tr),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder,),
            label: 'library'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'settings'.tr,
          ),
        ],
      ),
    );
  }

  Widget _buildRoundedButton({
    required IconData icon,
    required String text,
    bool isPro = false,
    required VoidCallback onTap, // Thêm callback khi nhấn
  }) {
    return SizedBox(
      width: 90,
      height: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(
              15,
            ), // Cho hiệu ứng ripple bo tròn
            child: Ink(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[900]
                        : Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                    blurRadius: 1.5,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(child: Icon(icon, size: 30)),
                  if (isPro)
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text('Pro'),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
