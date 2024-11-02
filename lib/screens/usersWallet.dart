import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsersWallets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Users Walls'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            // Extract user documents from snapshot
            List<DocumentSnapshot> users = snapshot.data?.docs;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Country')),
                  DataColumn(label: Text('City')),
                 // DataColumn(label: Text('Join Date')),
                  DataColumn(label: Text('Difference in Days')),
                ],
                rows: List.generate(users.length, (index) {
                  // Extract user data from document
                  Map<String, dynamic> userData = users[index].data() as Map<String, dynamic>;
                  Timestamp joinDateTimestamp = userData['joinDate'];
                  DateTime joinDate = joinDateTimestamp?.toDate();

                  // Compare join date with comparison date if both are not null
                  DateTime comparisonDate = DateTime.now(); // Change this to your desired comparison date
                  int differenceInDays;
                  if (joinDate != null) {
                    differenceInDays = joinDate.difference(comparisonDate).inDays;
                  }

                  // Create a DataRow with user data
                  return DataRow(cells: [
                    DataCell(Text(userData['name'] ?? '')),
                    DataCell(Text(userData['country'] ?? '')),
                    DataCell(Text(userData['city'] ?? '')),
                   // DataCell(Text(joinDate != null ? joinDate.toString() : 'Not Available')),
                    DataCell(joinDate != null ? differenceInDays>=1 && differenceInDays<7? Image.asset("assets/madel/silver.jpeg"):differenceInDays>=7 && differenceInDays<30?Row(children: [
                      Image.asset("assets/madel/silver.jpeg"),
                      SizedBox(width: 5,),
                      Image.asset("assets/madel/bronge.jpeg")
                    ],):differenceInDays>=30 ? Row(children: [
                      Image.asset("assets/madel/silver.jpeg"),
                      SizedBox(width: 5,),
                      Image.asset("assets/madel/bronge.jpeg"),
                      SizedBox(width: 5,),
                      Image.asset("assets/madel/gold.jpeg")
                    ],):Text("") : Text('Not Available')),
                  ]);
                }),
              ),
            );
          }
        },
      ),
    );
  }
}