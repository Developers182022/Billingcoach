import 'dart:math' as math;
import 'dart:math';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:stacked_bar_chart/stacked_bar_chart.dart';

import '../models/Profit.dart';
import 'HomePage.dart';
import 'login/Login.dart';
class saleApp extends StatelessWidget {
  const saleApp({Key? key}) : super(key: key);

  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            // Remove the debug banner
            debugShowCheckedModeBanner: false,
            title: 'DashBoard',
            theme: ThemeData(//primarySwatch: Color(25, 25, 25),
                primaryColor: Colors.black,
                brightness: Brightness.light,
                primaryColorDark:Colors.white ),
            darkTheme: ThemeData(//primarySwatch: Color(25, 25, 25),
                primaryColor: Colors.white,
                brightness: Brightness.dark,
                primaryColorDark:Colors.black ),
            themeMode: ThemeMode.system,
            home: const HomePage(),
          );
        });
  }
}

enum LegendShape { circle, rectangle }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin{
  Map<String, double>  dataMap={};
  final legendLabels = <String, String>{
    "Flutter": "Flutter legend",
    "React": "React legend",
    "Xamarin": "Xamarin legend",
    "Ionic": "Ionic legend",
  };
  int randomNumber = Random().nextInt(2);

  List<Color> colors = [
    Color(0xff4d504d),
    Color(0xff6b79a6),
    Color(0xffd6dcd6),
    Color(0xff779b73),
    Color(0xffa9dda5),
    Color(0xff9aaced),
  ];
  String userid="";
  Future<void> getuserdetails() async {
    try{
    AuthUser user= await Amplify.Auth.getCurrentUser();
    setState((){userid= user.userId;});
     final Profits = await Amplify.DataStore.query(Profit.classType,
         where: Profit.USER_I.eq(user.userId));

     for(int i=0; i<Profits.length; i++){
       Map<String, double> gg= {Profits[i].profit.toString(): double.parse(Profits[i].profit.toString())} ;
        dataMap.addEntries(gg.entries);
     }
     print(dataMap);
    }catch(e){
      runApp(LoginScreen());
    }

  }

  @override
  void initState() {
    getuserdetails();
    super.initState();
    colors.shuffle();
  }


  final colorList = <Color>[
    const Color(0xfffdcb6e),
    const Color(0xff0984e3),
    const Color(0xfffd79a8),
    const Color(0xffe17055),
    const Color(0xff6c5ce7),
  ];

  final gradientList = <List<Color>>[
    [
      const Color.fromRGBO(223, 250, 92, 1),
      const Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      const Color.fromRGBO(129, 182, 205, 1),
      const Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      const Color.fromRGBO(175, 63, 62, 1.0),
      const Color.fromRGBO(254, 154, 92, 1),
    ]
  ];
  ChartType? _chartType = ChartType.disc;
  bool _showCenterText = true;
  double? _ringStrokeWidth = 32;
  double? _chartLegendSpacing = 32;

  bool _showLegendsInRow = false;
  bool _showLegends = true;
  bool _showLegendLabel = false;

  bool _showChartValueBackground = true;
  bool _showChartValues = true;
  bool _showChartValuesInPercentage = false;
  bool _showChartValuesOutside = false;

  bool _showGradientColors = false;

  LegendShape? _legendShape = LegendShape.rectangle;
  LegendPosition? _legendPosition = LegendPosition.right;
  var year;
  int key = 0;

  @override
  Widget build(BuildContext context) {
    final chart = PieChart(
      key: ValueKey(key),
      dataMap: dataMap,
      animationDuration: const Duration(milliseconds: 800),
      chartLegendSpacing: _chartLegendSpacing!,
      chartRadius: math.min(MediaQuery.of(context).size.width / 3.2, 300),
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: _chartType!,
      centerText: _showCenterText ? "HYBRID" : null,
      legendLabels: _showLegendLabel ? legendLabels : {},
      legendOptions: LegendOptions(
        showLegendsInRow: _showLegendsInRow,
        legendPosition: _legendPosition!,
        showLegends: _showLegends,
        legendShape: _legendShape == LegendShape.circle
            ? BoxShape.circle
            : BoxShape.rectangle,
        legendTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: _showChartValueBackground,
        showChartValues: _showChartValues,
        showChartValuesInPercentage: _showChartValuesInPercentage,
        showChartValuesOutside: _showChartValuesOutside,
      ),
      ringStrokeWidth: _ringStrokeWidth!,
      emptyColor: Colors.grey,
      gradientList: _showGradientColors ? gradientList : null,
      emptyColorGradient: const [
        Color(0xff6c5ce7),
        Colors.blue,
      ],
      baseChartColor: Colors.transparent,
    );
    final settings = SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.all(12),
        child: Column(
          children: [
            SwitchListTile(
              value: _showGradientColors,
              title: const Text("Show Gradient Colors"),
              onChanged: (val) {
                setState(() {
                  _showGradientColors = val;
                });
              },
            ),
            ListTile(
              title: Text(
                'Pie Chart Options'.toUpperCase(),
                style: Theme.of(context).textTheme.overline!.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              title: const Text("chartType"),
              trailing: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButton<ChartType>(
                  value: _chartType,
                  items: const [
                    DropdownMenuItem(
                      value: ChartType.disc,
                      child: Text("disc"),
                    ),
                    DropdownMenuItem(
                      value: ChartType.ring,
                      child: Text("ring"),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _chartType = val;
                    });
                  },
                ),
              ),
            ),
            ListTile(
              title: const Text("ringStrokeWidth"),
              trailing: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButton<double>(
                  value: _ringStrokeWidth,
                  disabledHint: const Text("select chartType.ring"),
                  items: const [
                    DropdownMenuItem(
                      value: 16,
                      child: Text("16"),
                    ),
                    DropdownMenuItem(
                      value: 32,
                      child: Text("32"),
                    ),
                    DropdownMenuItem(
                      value: 48,
                      child: Text("48"),
                    ),
                  ],
                  onChanged: (_chartType == ChartType.ring)
                      ? (val) {
                    setState(() {
                      _ringStrokeWidth = val;
                    });
                  }
                      : null,
                ),
              ),
            ),
            SwitchListTile(
              value: _showCenterText,
              title: const Text("showCenterText"),
              onChanged: (val) {
                setState(() {
                  _showCenterText = val;
                });
              },
            ),
            ListTile(
              title: const Text("chartLegendSpacing"),
              trailing: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButton<double>(
                  value: _chartLegendSpacing,
                  disabledHint: const Text("select chartType.ring"),
                  items: const [
                    DropdownMenuItem(
                      value: 16,
                      child: Text("16"),
                    ),
                    DropdownMenuItem(
                      value: 32,
                      child: Text("32"),
                    ),
                    DropdownMenuItem(
                      value: 48,
                      child: Text("48"),
                    ),
                    DropdownMenuItem(
                      value: 64,
                      child: Text("64"),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _chartLegendSpacing = val;
                    });
                  },
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Legend Options'.toUpperCase(),
                style: Theme.of(context).textTheme.overline!.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SwitchListTile(
              value: _showLegends,
              title: const Text("showLegends"),
              onChanged: (val) {
                setState(() {
                  _showLegends = val;
                });
              },
            ),
            SwitchListTile(
              value: _showLegendsInRow,
              title: const Text("showLegendsInRow"),
              onChanged: (val) {
                setState(() {
                  _showLegendsInRow = val;
                });
              },
            ),
            SwitchListTile(
              value: _showLegendLabel,
              title: const Text("showLegendLabels"),
              onChanged: (val) {
                setState(() {
                  _showLegendLabel = val;
                });
              },
            ),
            ListTile(
              title: const Text("legendShape"),
              trailing: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButton<LegendShape>(
                  value: _legendShape,
                  items: const [
                    DropdownMenuItem(
                      value: LegendShape.circle,
                      child: Text("BoxShape.circle"),
                    ),
                    DropdownMenuItem(
                      value: LegendShape.rectangle,
                      child: Text("BoxShape.rectangle"),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _legendShape = val;
                    });
                  },
                ),
              ),
            ),
            ListTile(
              title: const Text("legendPosition"),
              trailing: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownButton<LegendPosition>(
                  value: _legendPosition,
                  items: const [
                    DropdownMenuItem(
                      value: LegendPosition.left,
                      child: Text("left"),
                    ),
                    DropdownMenuItem(
                      value: LegendPosition.right,
                      child: Text("right"),
                    ),
                    DropdownMenuItem(
                      value: LegendPosition.top,
                      child: Text("top"),
                    ),
                    DropdownMenuItem(
                      value: LegendPosition.bottom,
                      child: Text("bottom"),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _legendPosition = val;
                    });
                  },
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Chart values Options'.toUpperCase(),
                style: Theme.of(context).textTheme.overline!.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SwitchListTile(
              value: _showChartValueBackground,
              title: const Text("showChartValueBackground"),
              onChanged: (val) {
                setState(() {
                  _showChartValueBackground = val;
                });
              },
            ),
            SwitchListTile(
              value: _showChartValues,
              title: const Text("showChartValues"),
              onChanged: (val) {
                setState(() {
                  _showChartValues = val;
                });
              },
            ),
            SwitchListTile(
              value: _showChartValuesInPercentage,
              title: const Text("showChartValuesInPercentage"),
              onChanged: (val) {
                setState(() {
                  _showChartValuesInPercentage = val;
                });
              },
            ),
            SwitchListTile(
              value: _showChartValuesOutside,
              title: const Text("showChartValuesOutside"),
              onChanged: (val) {
                setState(() {
                  _showChartValuesOutside = val;
                });
              },
            ),
          ],
        ),
      ),
    );
    return  DefaultTabController(
    length: 3,child: Scaffold(
      appBar: AppBar( backgroundColor: Theme.of(context).primaryColorDark,
          leading:TextButton(onPressed:(){ Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));},
              child:Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey,width: 1)),
                  padding:EdgeInsets.all(4),
                  child:Icon(Icons.arrow_back,color:Theme.of(context).primaryColor,))),
          bottom:TabBar(
                labelColor:Theme.of(context).primaryColor,
                indicatorColor: Theme.of(context).primaryColor,
                tabs:[
                  Tab(icon: Icon(Icons.pie_chart),),
                  Tab(icon: Icon(Icons.bar_chart_outlined),),
                  Tab(icon: Icon(Icons.auto_graph),),
                ]
            ),
          actions:[
          TextButton(onPressed:(){ Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));},
        child:Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey,width: 1)),
            padding:EdgeInsets.all(4),
            child:Icon(Icons.menu_open,color:Theme.of(context).primaryColor,))),
          ]
      ),
      body: TabBarView(
    children: [Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child:LayoutBuilder(
        builder: (_, constraints) {
          if (constraints.maxWidth >= 600) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child:dataMap.isNotEmpty? chart:Container(),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: settings,
                )
              ],
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 32,
                    ),
                    child: chart,
                  ),
                  settings,
                ],
              ),
            );
          }
        },
      ),
    ),
      Container(padding: EdgeInsets.only(left:10, right:10),
          child:SingleChildScrollView(child:Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Graph(
            GraphData(
              "My Graph",
              [
                GraphBar(
                  DateTime(year, 01),
                  [
                    GraphBarSection(100, color: colors[randomNumber]),
                    GraphBarSection(900, color: colors[randomNumber + 1]),
                    GraphBarSection(0, color: colors[randomNumber + 2]),
                    GraphBarSection(0, color: colors[randomNumber + 3]),
                  ],
                ),
                GraphBar(
                  DateTime(year, 02),
                  [
                    GraphBarSection(50, color: colors[randomNumber]), //second
                    GraphBarSection(501,
                        color: colors[randomNumber + 1]), //first
                    GraphBarSection(-100, color: colors[randomNumber + 2]),
                    GraphBarSection(-700, color: colors[randomNumber + 3]),
                  ],
                ),
                GraphBar(
                  DateTime(year, 03),
                  [
                    GraphBarSection(150, color: colors[randomNumber]),
                    GraphBarSection(800.22, color: colors[randomNumber + 1]),
                    GraphBarSection(-150, color: colors[randomNumber + 2]),
                    GraphBarSection(-550, color: colors[randomNumber + 3]),
                  ],
                ),
                GraphBar(
                  DateTime(year, 04),
                  [
                    GraphBarSection(750, color: colors[randomNumber]),
                    GraphBarSection(45, color: colors[randomNumber + 1]),
                    GraphBarSection(-50, color: colors[randomNumber + 2]),
                    GraphBarSection(-570, color: colors[randomNumber + 3]),
                  ],
                ),
                GraphBar(
                  DateTime(year, 5),
                  [
                    GraphBarSection(200, color: colors[randomNumber]),
                    GraphBarSection(670, color: colors[randomNumber + 1]),
                    GraphBarSection(-400, color: colors[randomNumber + 2]),
                    GraphBarSection(-50, color: colors[randomNumber + 3]),
                  ],
                ),
                GraphBar(
                  DateTime(year, 6),
                  [
                    GraphBarSection(200, color: colors[randomNumber]),
                    GraphBarSection(307, color: colors[randomNumber + 1]),
                    GraphBarSection(-309, color: colors[randomNumber + 2]),
                    GraphBarSection(-90, color: colors[randomNumber + 3]),
                  ],
                ),
                GraphBar(
                  DateTime(year, 7),
                  [
                    GraphBarSection(200, color: colors[randomNumber]),
                    GraphBarSection(350, color: colors[randomNumber + 1]),
                    GraphBarSection(-170, color: colors[randomNumber + 2]),
                    GraphBarSection(-500, color: colors[randomNumber + 3]),
                  ],
                ),
                GraphBar(
                  DateTime(year, 8),
                  [
                    GraphBarSection(200, color: colors[randomNumber]),
                    GraphBarSection(300, color: colors[randomNumber + 1]),
                    GraphBarSection(-300, color: colors[randomNumber + 2]),
                    GraphBarSection(-500, color: colors[randomNumber + 3]),
                  ],
                ),
                GraphBar(
                  DateTime(year, 9),
                  [
                    GraphBarSection(200, color: colors[randomNumber]),
                    GraphBarSection(390, color: colors[randomNumber + 1]),
                    GraphBarSection(-1000, color: colors[randomNumber + 2]),
                    GraphBarSection(-0, color: colors[randomNumber + 3]),
                  ],
                ),
                GraphBar(
                  DateTime(year, 10),
                  [
                    GraphBarSection(60, color: colors[randomNumber]),
                    GraphBarSection(700, color: colors[randomNumber + 1]),
                    GraphBarSection(-100, color: colors[randomNumber + 2]),
                    GraphBarSection(-500, color: colors[randomNumber + 3]),
                  ],
                ),
                GraphBar(
                  DateTime(year, 11),
                  [
                    GraphBarSection(200, color: colors[randomNumber]),
                    GraphBarSection(470, color: colors[randomNumber + 1]),
                    GraphBarSection(-700, color: colors[randomNumber + 2]),
                    GraphBarSection(-320, color: colors[randomNumber + 3]),
                  ],
                ),
                GraphBar(
                  DateTime(year, 12),
                  [
                    GraphBarSection(500, color: colors[randomNumber]),
                    GraphBarSection(500.0, color: colors[randomNumber + 1]),
                    GraphBarSection(-500.0, color: colors[randomNumber + 2]),
                    GraphBarSection(-500.0, color: colors[randomNumber + 3]),
                  ],
                ),
              ],
              Colors.white,
            ),
            yLabelConfiguration: YLabelConfiguration(
              labelStyle: TextStyle(
                color: Colors.grey,
                fontSize: 11,
              ),
              interval: 500,
              labelCount: 5,
              labelMapper: (num value) {
                return NumberFormat.compactCurrency(
                    locale: "en", decimalDigits: 0, symbol: "\$")
                    .format(value);
              },
            ),
            xLabelConfiguration: XLabelConfiguration(
              labelStyle: TextStyle(
                color: Colors.grey,
                fontSize: 11,
              ),
              labelMapper: (DateTime date) {
                return DateFormat("MMM yyyy").format(date);
              },
            ),
            netLine: NetLine(
              showLine: true,
              lineColor: Colors.blue,
              pointBorderColor: Colors.black,
              coreColor: Colors.white,
            ),
            graphType: GraphType.StackedRect,
            onBarTapped: (GraphBar bar) {
              print(bar.month);
              setState(() {});
            },
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                title: Text("Stack Value 1"),
                leading: Icon(Icons.account_balance_rounded),
                trailing: Icon(
                  Icons.circle,
                  color: colors[randomNumber + 1],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                title: Text("Stack Value 2"),
                leading: Icon(Icons.account_balance_rounded),
                trailing: Icon(
                  Icons.circle,
                  color: colors[randomNumber],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                title: Text("Stack Value 3"),
                leading: Icon(Icons.account_balance_rounded),
                trailing: Icon(
                  Icons.circle,
                  color: colors[randomNumber + 2],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                title: Text("Stack Value 4"),
                leading: Icon(Icons.account_balance_rounded),
                trailing: Icon(
                  Icons.circle,
                  color: colors[randomNumber + 3],
                ),
              ),
            ),
          ),
        ],
      ))),
      Container(padding: EdgeInsets.only(left:10, right:10),
          child: SingleChildScrollView(child:Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Graph(
            GraphData(
              "My Graph",
              [
                GraphBar(
                  DateTime(2020, 01),
                  [
                    GraphBarSection(100, color: colors[randomNumber]),
                    GraphBarSection(900, color: colors[randomNumber + 1]),
                    GraphBarSection(0, color: colors[randomNumber + 2]),
                    GraphBarSection(0, color: colors[randomNumber + 3]),
                  ],
                ),
                GraphBar(
                  DateTime(2020, 2),
                  [
                    GraphBarSection(50, color: colors[randomNumber]), //second
                    GraphBarSection(501,
                        color: colors[randomNumber + 1]), //first
                    GraphBarSection(-100, color: colors[randomNumber + 2]),
                    GraphBarSection(-700, color: colors[randomNumber + 3]),
                  ],
                ),
                GraphBar(
                  DateTime(2020, 3),
                  [
                    GraphBarSection(150, color: colors[randomNumber]),
                    GraphBarSection(800.22, color: colors[randomNumber + 1]),
                    GraphBarSection(-150, color: colors[randomNumber + 2]),
                    GraphBarSection(-550, color: colors[randomNumber + 3]),
                  ],
                ),
                GraphBar(
                  DateTime(2020, 4),
                  [
                    GraphBarSection(750, color: colors[randomNumber]),
                    GraphBarSection(45, color: colors[randomNumber + 1]),
                    GraphBarSection(-50, color: colors[randomNumber + 2]),
                    GraphBarSection(-570, color: colors[randomNumber + 3]),
                  ],
                ),
                GraphBar(
                  DateTime(2020, 5),
                  [
                    GraphBarSection(200, color: colors[randomNumber]),
                    GraphBarSection(670, color: colors[randomNumber + 1]),
                    GraphBarSection(-400, color: colors[randomNumber + 2]),
                    GraphBarSection(-50, color: colors[randomNumber + 3]),
                  ],
                ),
                GraphBar(
                  DateTime(2020, 6),
                  [
                    GraphBarSection(200, color: colors[randomNumber]),
                    GraphBarSection(307, color: colors[randomNumber + 1]),
                    GraphBarSection(-309, color: colors[randomNumber + 2]),
                    GraphBarSection(-90, color: colors[randomNumber + 3]),
                  ],
                ),
                GraphBar(
                  DateTime(2020, 7),
                  [
                    GraphBarSection(200, color: colors[randomNumber]),
                    GraphBarSection(350, color: colors[randomNumber + 1]),
                    GraphBarSection(-170, color: colors[randomNumber + 2]),
                    GraphBarSection(-500, color: colors[randomNumber + 3]),
                  ],
                ),
                GraphBar(
                  DateTime(2020, 8),
                  [
                    GraphBarSection(200, color: colors[randomNumber]),
                    GraphBarSection(300, color: colors[randomNumber + 1]),
                    GraphBarSection(-300, color: colors[randomNumber + 2]),
                    GraphBarSection(-500, color: colors[randomNumber + 3]),
                  ],
                ),
                GraphBar(
                  DateTime(2020, 9),
                  [
                    GraphBarSection(200, color: colors[randomNumber]),
                    GraphBarSection(390, color: colors[randomNumber + 1]),
                    GraphBarSection(-1000, color: colors[randomNumber + 2]),
                    GraphBarSection(-0, color: colors[randomNumber + 3]),
                  ],
                ),
                GraphBar(
                  DateTime(2020, 10),
                  [
                    GraphBarSection(60, color: colors[randomNumber]),
                    GraphBarSection(700, color: colors[randomNumber + 1]),
                    GraphBarSection(-100, color: colors[randomNumber + 2]),
                    GraphBarSection(-500, color: colors[randomNumber + 3]),
                  ],
                ),
                GraphBar(
                  DateTime(2020, 11),
                  [
                    GraphBarSection(200, color: colors[randomNumber]),
                    GraphBarSection(470, color: colors[randomNumber + 1]),
                    GraphBarSection(-700, color: colors[randomNumber + 2]),
                    GraphBarSection(-320, color: colors[randomNumber + 3]),
                  ],
                ),
                GraphBar(
                  DateTime(2020, 12),
                  [
                    GraphBarSection(500, color: colors[randomNumber]),
                    GraphBarSection(500.0, color: colors[randomNumber + 1]),
                    GraphBarSection(-500.0, color: colors[randomNumber + 2]),
                    GraphBarSection(-500.0, color: colors[randomNumber + 3]),
                  ],
                ),
              ],
              Colors.white,
            ),
            yLabelConfiguration: YLabelConfiguration(
              labelStyle: TextStyle(
                color: Colors.grey,
                fontSize: 11,
              ),
              interval: 500,
              labelCount: 5,
              labelMapper: (num value) {
                return NumberFormat.compactCurrency(
                    locale: "en", decimalDigits: 0, symbol: "\$")
                    .format(value);
              },
            ),
            xLabelConfiguration: XLabelConfiguration(
              labelStyle: TextStyle(
                color: Colors.grey,
                fontSize: 11,
              ),
              labelMapper: (DateTime date) {
                return DateFormat("MMM yyyy").format(date);
              },
            ),
            netLine: NetLine(
              showLine: true,
              lineColor: Colors.blue,
              pointBorderColor: Colors.black,
              coreColor: Colors.white,
            ),
            graphType: GraphType.LineGraph,
            onBarTapped: (GraphBar bar) {
              print(bar.month);
              setState(() {});
            },
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                title: Text("Stack Value 1"),
                leading: Icon(Icons.account_balance_rounded),
                trailing: Icon(
                  Icons.circle,
                  color: colors[randomNumber + 1],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                title: Text("Stack Value 2"),
                leading: Icon(Icons.account_balance_rounded),
                trailing: Icon(
                  Icons.circle,
                  color: colors[randomNumber],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                title: Text("Stack Value 3"),
                leading: Icon(Icons.account_balance_rounded),
                trailing: Icon(
                  Icons.circle,
                  color: colors[randomNumber + 2],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                title: Text("Stack Value 4"),
                leading: Icon(Icons.account_balance_rounded),
                trailing: Icon(
                  Icons.circle,
                  color: colors[randomNumber + 3],
                ),
              ),
            ),
          ),
        ],
      ))),
    ])
    )
    );
  }
}

class HomePage2 extends StatelessWidget  {
  HomePage2({Key? key}) : super(key: key);

  final dataMap = <String, double>{
    "Flutter": 5,
  };

  final colorList = <Color>[
    Colors.greenAccent,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body :PieChart(
          dataMap: dataMap,
          chartType: ChartType.ring,
          baseChartColor: Colors.grey[50]!.withOpacity(0.15),
          colorList: colorList,
          chartValuesOptions: const ChartValuesOptions(
            showChartValuesInPercentage: true,
          ),
          totalValue: 20,
        ),
    );
  }
}