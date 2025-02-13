// import 'package:flutter/material.dart';
// class CustomTable<T> extends StatelessWidget {
//   final int itemCount;
//   final List<String> columnHeadings;
//   final List<T> tableData;
//   final List<Widget> Function(T) rows;
//   final int rowsPerPage;
//
//
//   const CustomTable({
//     required this.itemCount, //rowCount
//     required this.columnHeadings,
//     required this.tableData,
//     required this.rows,
//      this.rowsPerPage = 10,
//     super.key
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           buildHeadings(),
//           Expanded(
//               child:
//               ListView.builder(
//                 itemCount: rowsPerPage,
//                 itemBuilder: (context,index){
//                   return buildRow(index);
//                 },
//           ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   Widget buildHeadings() {
//     return Container();
//   }
//
//   Widget buildRow(int index) {
//     return Container(
//       child: Row(
//         children: rows(tableData[index])
//       ),
//     );
//   }
// }
