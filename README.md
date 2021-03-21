![Logo of Ethereum](ethereum-logo.png)

[DANOU NFT](https://ropsten.etherscan.io/address/0xC775dd6BD7307b6F139125CF9Fc7Eb040c11640E) - Ropsten Etherscan
========

Your hard work is about to become easier with **DANOU NFT**

It ain't much, but it's honest work.

DANOU Contract : https://ropsten.etherscan.io/address/0xC775dd6BD7307b6F139125CF9Fc7Eb040c11640E
FIGTH Contract : https://ropsten.etherscan.io/address/0x696078592C0E204ddD918fbf6207675B6aeC3c0b

Teacher DANOU NFT wallet : https://ropsten.etherscan.io/token/0xC775dd6BD7307b6F139125CF9Fc7Eb040c11640E?a=0x6e5329026eb58d6242a2633871a063464b098c7a

Setup et configuration
--------
* Installation de truffle : **sudo apt install truffle**
* Installation de openzeppelin : **npm install openzeppelin-solidity**
* Compilation et deploiement du SC : https://www.trufflesuite.com/tutorials/robust-smart-contracts-with-openzeppelin#compiling-and-deploying-the-smart-contract
* Création de l'environement : mkdir DANOU && cd DANOU
* Initialisation : truffle init
* Création du smart contract DANI Token : touch contracts/DANOU.sol
* Modification du deploy contract et migration vers ganache : https://www.trufflesuite.com/tutorials/robust-smart-contracts-with-openzeppelin#compiling-and-deploying-the-smart-contract
* Modification du trufflue-config : https://www.trufflesuite.com/tutorials/using-infura-custom-provider

Avant la migration
--------
* npm install @openzeppelin/contracts
* npm install @truffle/hdwallet-provider
* truffle compile
* truffle migrate –network ropsten

Utilisation et vérification
--------
* Utiliser https://mycrypto.com/
* Ajouter allowedUser admin
* Ajouter allowedUser future recipient
* Allow spent with spender the future recipient, call with the admin addresse
* Approve admin to send funds

Sources :
--------
- [Truffle Suite](https://www.trufflesuite.com)
- [Mycrypto.com](https://mycrypto.com/) 
- [Ropsten etherscan](https://ropsten.etherscan.io) 

Credits - ESILV :
--------
- Jean Daniel Adrien
- Yani Ferhaoui
