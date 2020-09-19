import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fluid_slider/flutter_fluid_slider.dart';
import 'package:http/http.dart';
import 'package:rk_coin/Strings.dart';
import 'package:web3dart/web3dart.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Client httpClient;
  Web3Client ethClient;
  String txnHash;
  var myData;

  double screenHeight, screenWidth;
  bool data = false;
  double myAmount = 0;

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(clientUrl, httpClient);
//    myAddress from Strings.dart
    getBalance(myAddress);
  }

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("assets/abi.json");
    // contractAddress & name from strings.dart
    final contract = DeployedContract(ContractAbi.fromJson(abi, contractName),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);
    return result;
  }

  Future<void> getBalance(String targetAddress) async {
//    EthereumAddress address = EthereumAddress.fromHex(targetAddress);
    List<dynamic> result = await query("getBalance", []);
    myData = result[0];
    data = true;
    setState(() {});
  }

  Future<String> submit(String functionName, List<dynamic> args) async {
    data = false;
    setState(() {});
//    privateKey from Strings.dart
    final credentials = EthPrivateKey.fromHex(privateKey);
    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
            contract: contract, function: ethFunction, parameters: args),
        fetchChainIdFromNetworkId: true);
    txnHash = result;
    data = true;
    setState(() {});
    return result;
  }

  Future<String> deposit() async {
    var bigAmount = BigInt.from(myAmount);
    var response = await submit("depositBalance", [bigAmount]);
    print('deposited');
    return response;
  }

  Future<String> withdraw() async {
    var bigAmount = BigInt.from(myAmount);
    var response = await submit("withdrawBalance", [bigAmount]);
    print('withdrawn');
    return response;
  }

  Widget buildNewBody() {
    return SafeArea(
      child: Stack(
        overflow: Overflow.visible,
        children: [
//          for background
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            height: screenHeight / 3.5,
            width: double.infinity,
          ),
//          all other UI
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: screenHeight / 10),
            child: Column(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$Rk Coin',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: screenHeight / 4,
                  width: screenWidth / 1.2,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Balance:',
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 10),
                        data
                            ? Text(
                                '$myData ETH',
                                style: TextStyle(
                                    fontSize: 38, fontWeight: FontWeight.bold),
                              )
                            : CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      FluidSlider(
                        value: myAmount,
                        min: 0,
                        max: 100,
                        onChanged: (value) {
                          setState(() {
                            print(value);
                            myAmount = value;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton.icon(
                            onPressed: () {
                              setState(() {
                                data = false;
                              });
                              getBalance(myAddress);
                            },
                            icon: Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                            textColor: Colors.white,
                            label: Text('Refresh'),
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          FlatButton.icon(
                            onPressed: () => deposit(),
                            icon: Icon(
                              Icons.call_made,
                              color: Colors.white,
                            ),
                            textColor: Colors.white,
                            label: Text('Deposit'),
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          FlatButton.icon(
                            onPressed: () => withdraw(),
                            textColor: Colors.white,
                            icon: Icon(
                              Icons.call_received,
                              color: Colors.white,
                            ),
                            label: Text('Withdraw'),
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          )
                        ],
                      ),
                      txnHash != null
                          ? Text(
                              txnHash,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            )
                          : Container()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('rk_Coin'),
        centerTitle: true,
      ),
      body: buildNewBody(),
    );
  }
}
