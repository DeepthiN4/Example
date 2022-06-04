import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Future Builder'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<int> dataFuture;
  @override
  void initState(){
    super.initState();

    dataFuture = getData();
  }
  
  
  
  Future<int> getData() async{
    final result = await  http.get( 
      Uri.parse('https://randomnumberapi.com/api/v1.0/random'),

      );
      await Future.delayed(Duration(seconds: 3));
      final body =json.decode(result.body);
      int randomNumber = (body as List).first;

      return randomNumber;
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
       
        title: Text('Future Builder'
        ),
               
        ),
        floatingActionButton: FloatingActionButton( 
          child: Icon(Icons.refresh),
          onPressed: () => setState(() {
            dataFuture=getData();
          }),
        ),
        body: Center(
          child: FutureBuilder<int?>( 
            future: dataFuture,
            initialData: 5,
            builder: (context, snapshot){
              switch (snapshot.connectionState){
                case ConnectionState.waiting:
                  return /*snapshot.hasData
                  ? Text('${snapshot.data}')
                  :*/ Text('..Waiting  ');
                case ConnectionState.done:
                default:
                if (snapshot.hasError)
              {
                return Text('${snapshot.error}');
              } else if(snapshot.hasData){
               return Text('${snapshot.data}');
              }
              else{
              return const Text('No Data');
              }
            }
            }
        ),
      ),
      );
      
  }
}
