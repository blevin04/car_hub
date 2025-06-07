import 'package:car_hub/backendFxns.dart';
import 'package:car_hub/models.dart';
import 'package:flutter/material.dart';

class Research extends StatefulWidget {
  const Research({super.key});

  @override
  State<Research> createState() => _ResearchState();
}

ValueNotifier<List<Vehicle>> vehicleResults = ValueNotifier(List.empty(growable: true));
class _ResearchState extends State<Research> {
  @override
  Widget build(BuildContext context) {
    print(vehicleResults.value.length);
    return  Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SearchBar(
            onChanged: (value) async{
              print("object");
              vehicleResults.value = await fetchVehicles(value);
            },
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: vehicleResults, builder: (context,child){
              return ListView.builder(
                shrinkWrap: true,
                itemCount: vehicleResults.value.length,
                itemBuilder: (BuildContext context, int index) {
                  return VehicleCard(vehicleResults.value[index]);
                },
              );
            }),
          )
        ],
      ),
    );
  }
}

Widget VehicleCard(Vehicle vehicle){
  return Card(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage("lib/assets/carIcon.png"),
          
        ),
        Column(
          children: [
            Text("${vehicle.make} ${vehicle.model}",
            style:const TextStyle(fontWeight: FontWeight.bold,fontSize: 17,),softWrap: true,overflow: TextOverflow.ellipsis,),
            Text("Engine:${vehicle.cylinders}cylinders ${vehicle.disp}Ltrs "),
            Text("Transmission:${vehicle.trany}"),
            Text("Drive:${vehicle.drive} "),
            Text("Engine:${vehicle.eng_dscr}")
          ],
        )
      ],
    ),
  );
}