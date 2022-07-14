import 'package:flutter/material.dart';
import 'package:flutter_logger/components/log_filter.dart';
import 'package:flutter_logger/models/environments_model.dart';
import 'package:flutter_logger/models/enums/enums.dart';

class AppLogFilter extends StatelessWidget {
  final bool dark;
  final dynamic provider;
  AppLogFilter({
    Key? key,
    required this.dark,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Level maxLevel = EnvironmentsModel.getMaxDisplayLevel;
    return LogFilter(
      dark: dark,
      provider: provider,
      padding: const SizedBox(width: 20),
      levelFiltering: DropdownButton(
        value: provider.filterLevel,
        items: [
          const DropdownMenuItem(
            value: Level.nothing,
            child: Text("ALL"),
          ),
          for (var item in Level.values)
            if (item != Level.nothing)
              DropdownMenuItem(
                value: item,
                enabled: item.index <= maxLevel.index,
                child: Text(item.name.toUpperCase()),
              )
        ],
        onChanged: (value) {
          provider.filterLevel = value as Level;
          provider.refreshFilter();
        },
      ),
      logType: 'app log',
    );
  }
}
