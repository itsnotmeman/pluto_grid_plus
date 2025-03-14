import 'package:flutter/material.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

import 'popup_cell.dart';

class PlutoSelectCell extends StatefulWidget implements PopupCell {
  @override
  final PlutoGridStateManager stateManager;

  @override
  final PlutoCell cell;

  @override
  final PlutoColumn column;

  @override
  final PlutoRow row;

  const PlutoSelectCell({
    required this.stateManager,
    required this.cell,
    required this.column,
    required this.row,
    super.key,
  });

  @override
  PlutoSelectCellState createState() => PlutoSelectCellState();
}

class PlutoSelectCellState extends State<PlutoSelectCell>
    with PopupCellState<PlutoSelectCell> {
  @override
  List<PlutoColumn> popupColumns = [];

  @override
  List<PlutoRow> popupRows = [];

  @override
  IconData? get icon => widget.column.type.select.popupIcon;

  late bool enableColumnFilter;

  @override
  void initState() {
    super.initState();

    enableColumnFilter = widget.column.type.select.enableColumnFilter;

    final columnFilterHeight = enableColumnFilter
        ? widget.stateManager.configuration.style.columnFilterHeight
        : 0;

    final rowsHeight = widget.column.type.select.items.length *
        widget.stateManager.rowTotalHeight;

    popupHeight = widget.stateManager.configuration.style.columnHeight +
        columnFilterHeight +
        rowsHeight +
        PlutoGridSettings.gridInnerSpacing +
        widget.stateManager.configuration.style.gridBorderWidth;

    fieldOnSelected = widget.column.title;

    popupColumns = [
      PlutoColumn(
        width: widget.column.type.select.width ?? PlutoGridSettings.columnWidth,
        title: widget.column.title,
        field: widget.column.title,
        readOnly: true,
        type: PlutoColumnType.text(),
        formatter: widget.column.formatter,
        enableFilterMenuItem: enableColumnFilter,
        enableHideColumnMenuItem: false,
        enableSetColumnsMenuItem: false,
        renderer: widget.column.type.select.builder == null
            ? null
            : (rendererContext) {
                var item =
                    widget.column.type.select.items[rendererContext.rowIdx];

                return widget.column.type.select.builder!(item);
              },
      )
    ];

    popupRows = widget.column.type.select.items.map((dynamic item) {
      return PlutoRow(
        cells: {
          widget.column.title: PlutoCell(value: item),
        },
      );
    }).toList();
  }

  @override
  void onSelected(PlutoGridOnSelectedEvent event) {
    widget.column.type.select.onItemSelected(event);
    super.onSelected(event);
  }

  @override
  void onLoaded(PlutoGridOnLoadedEvent event) {
    super.onLoaded(event);

    if (enableColumnFilter) {
      event.stateManager.setShowColumnFilter(true, notify: false);
    }

    event.stateManager.setSelectingMode(PlutoGridSelectingMode.none);
  }
}
