# rk_coin

A flutter app demonstrating usage of smart contract for wallet applications.

## Requirements
- MataMask browser extension
- http://www.infura.io account (free)
- Balance in Rinkeby Test Network wallet (you will get it for free)

## Getting Started
- Firstly create MetaMask account, switch to Rinkeby Test Network & get some free balance in it. (Search on google)
- Copy the account address & assign it to "myAddress" variable in lib/Strings.dart file
- go to infura's dashboard and copy the client url (Make sure you copy rinkedby network's url)
- Now go to remix.ethereum.org & create new file copy the code from assets/smartContracts/rxcoin.sol to that file.
- compile & deploy the file (google it if you are new to this)
- copy contract address & name and change the value in Strings.dart
- to get the private key open MetaMask click account details then export private key done.!
- Build and run the app
