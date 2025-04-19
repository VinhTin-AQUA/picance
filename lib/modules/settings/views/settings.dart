import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picance/modules/settings/services/localization_service.dart';
import 'package:picance/modules/settings/services/theme_service.dart';

import '../../../config/themes/t_dropdownbutton_theme.dart';
import '../../../config/themes/t_radio_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(title: Text('settings'.tr), centerTitle: true),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'theme'.tr,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  ...ThemeService.instance.themes.keys.map((theme) {
                    return RadioListTile<ThemeMode>(
                      title: Text(
                        theme.tr,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      value: ThemeService.instance.themes[theme]!,
                      groupValue: ThemeService.instance.themeMode,
                      activeColor: TRadioListTileTheme.color(),
                      onChanged: (value) {
                        if (value != null) {
                          ThemeService.instance.changeThemeMode(value);
                        }
                      },
                    );
                  }),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'language'.tr,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 0,
                        ),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.indigo, // màu của border
                              width: 1.2, // độ dày của border
                            ),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: LocalizationService.instance.currentLocale,
                            icon: Icon(Icons.arrow_drop_down),
                            dropdownColor: TDropdownButtonTheme.dropdownColor(
                              context,
                            ),
                            style: Theme.of(context).textTheme.bodyMedium,
                            onChanged: (newValue) {
                              if (newValue != null) {
                                LocalizationService.instance.changeLocale(
                                  newValue,
                                );
                              }
                            },
                            items: [
                              ...LocalizationService
                                  .instance
                                  .supportedLocales
                                  .keys
                                  .map((keyLang) {
                                    return DropdownMenuItem(
                                      value: keyLang,
                                      child: Text(
                                        LocalizationService
                                            .instance
                                            .supportedLocales[keyLang]!,
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
  }
}

// class _SettingsScreenState extends State<SettingsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final appSettings = Provider.of<AppSettings>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Settings'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ,
//       ),
//     );
//   }
// }
