import 'package:dam_proyect_application/pages/loginPage.dart';
import 'package:dam_proyect_application/pages/tabs/allEvents.dart';
import 'package:dam_proyect_application/pages/tabs/endEvents.dart';
import 'package:dam_proyect_application/pages/tabs/publicHub.dart';
import 'package:dam_proyect_application/pages/tabs/soonEvents.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(

        appBar: AppBar( 
        backgroundColor: const Color.fromARGB(255, 54, 152, 244),
        title: Row(
          children: [
            Icon(MdiIcons.ticket),
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Row(
                children: [
                  Text(" Show ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                    ),
                    child: Text(" HUB ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),                 
                ],
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [PopupMenuItem(child: Text('Admin Login'), value: 'adminlogin')],
            onSelected: (opcion) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()),);
            },
          ),
        ],
        bottom: TabBar(
        isScrollable: true,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white,
        indicatorColor: Colors.white,
        tabs: [
            Tab(text: 'Activos'),
            Tab(text: 'Pronto'),
            Tab(text: 'Finalizados'),
            Tab(text: 'Todos'),
          ],
        ),
      ),
      body: TabBarView(
        children: [publicHubPage(), soonEventsPage(), endEvents(), allEvents()],
      ),
      ),
    );
  }
}