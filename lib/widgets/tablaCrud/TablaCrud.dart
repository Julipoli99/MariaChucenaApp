import 'package:flutter/material.dart';

class TablaCrud<T> extends StatelessWidget {
  final String
      tituloAppBar; // Titulo del appbar, dependiendo del crud va cambiando
  final List<T>
      items; // La lista generica de los elementos o clase que la utilice
  final List<String> encabezados; // Son los encabezados de la tabla
  final List<Widget Function(T)>
      dataMapper; // Es la funcion para mapear los datos a columnas

  TablaCrud({
    super.key,
    required this.tituloAppBar,
    required this.items,
    required this.encabezados,
    required this.dataMapper,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        // Agrega un SingleChildScrollView aquí para permitir desplazamiento
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Table(
                border: TableBorder.all(
                    color: const Color.fromRGBO(184, 178, 178, 1)),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const <int, TableColumnWidth>{
                  0: FixedColumnWidth(80), // Ancho fijo
                  1: FlexColumnWidth(2), // Espacio flexible
                  2: FlexColumnWidth(3), // Espacio flexible
                  3: FlexColumnWidth(1), // Espacio flexible
                  4: FlexColumnWidth(1), // Espacio flexible
                },
                children: [
                  TableRow(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(212, 205, 205, 1),
                    ),
                    children: encabezados
                        .map((header) =>
                            // Encabezados
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(header),
                              ),
                            ))
                        .toList(),
                  ),
                  // Recorre la coleccion de entidades
                  ...items.map((item) => TableRow(
                        children: dataMapper
                            .map((mapper) =>
                                // Valores
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: mapper(item),
                                  ),
                                ))
                            .toList(),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(tituloAppBar),
      centerTitle: true,
    );
  }
}
