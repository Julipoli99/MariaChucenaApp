import 'package:flutter/material.dart';

class TablaCrud<T> extends StatelessWidget {
  final String tituloAppBar; // Titulo del appbar, dependiendo del crud va cambiando
  final List<T> items; // La lista generica de los elementos o clase que la utilice
  final List<String> encabezados; // Son los encabezados de la tabla
  final List<Widget Function(T)> dataMapper; // Es la funcion para mapear los datos a columnas


  // DATOS OPCIONALES PARA EL APPBAR
  //final Widget? leading;
  //final Widget? rightSide;


  TablaCrud({
    super.key,
    //this.leading,
    //this.rightSide,
    required this.tituloAppBar,
    required this.items,
    required this.encabezados,
    required this.dataMapper,
    });

  /*final List<User> users = [
    User(id: 1, name: 'Julian', email: 'polimenijulian9@gmail.com', role: 'Admin'),
    User(id: 2, name: 'Tomas', email: 'totopoli9@gmail.com', role: 'free'),
    User(id: 3, name: 'Agustin', email: 'aguspoli@gmail.com', role: 'free'),
  ];*/

  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Table(
                  border: TableBorder.all(color: const Color.fromRGBO(184, 178, 178, 1)),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const <int, TableColumnWidth> {
                    0: FixedColumnWidth(80),  // Columna generica<T> con ancho fijo de 50 píxeles
                    1: FlexColumnWidth(2),     // Columna generica<T> con 2 unidades de espacio flexible
                    2: FlexColumnWidth(3),     // Columna generica<T> con 3 unidades de espacio flexible
                    3: FlexColumnWidth(1),     // Columna generica<T> con 1 unidad de espacio flexible
                    4: FlexColumnWidth(1),     // Columna generica<T> con 1 unidad de espacio flexible
                  },
                  children: [
                    TableRow(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(212, 205, 205, 1),
                      ),
                      children: encabezados.map((header) => 
                      
                      //Encabezados
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(header),
                          ),
                        )
                      ).toList()
                    ),
          
                    // Recorre la coleccion de entidades
                    ...items.map((item) => TableRow(
                      children: dataMapper.map((mapper) => 
                      // Valores
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: mapper(item),
                          ),
                        )
                      ).toList()
                    ))
                  ],
                  
                ),
              ]
              
            ),
          ),
        ],
      )
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      // Titulo del appBar
      //leading: leading,
      //actions: rightSide != null ? [rightSide!] : [],
      title: Text(tituloAppBar),
      centerTitle: true,
    );
  }
}