import 'package:flutter/material.dart';
import 'package:mega_sena/config/ConfigViewModel.dart';
import 'package:mega_sena/services/ConfigService.dart';
import 'package:mega_sena/shared/extension/ThemeExtension.dart';


class ConfigWidget extends StatelessWidget {

  final ConfigViewModel _configViewModel = ConfigViewModel(configService: ConfigService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: Text(
              'Configuração',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _body(context),
      ),
    );
  }

  Widget _body(context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tema da aplicação: ', style: Theme.of(context).textTheme.headline6,),
            SizedBox(width: 32),
            Expanded(child: _buildDropDownTheme()),
          ],
        )
      ],
    );
  }

  Widget _buildDropDownTheme() {
    return StreamBuilder(
      stream: _configViewModel.stream,
      builder: (context, _) {
        return DropdownButton<ThemeMode>(
          isExpanded: true,
          onChanged: (value) {
            _configViewModel.changeTheme(value!);
          },
          value: _configViewModel.currentTheme,
          items: _configViewModel.items
          .map<DropdownMenuItem<ThemeMode>>((item) => DropdownMenuItem<ThemeMode>(
            child: Text(item.name),
            value: item
          )).toList(),
          );
      },
    );
  }

}