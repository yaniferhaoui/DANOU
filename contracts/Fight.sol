pragma solidity ^0.7.0;

import "./DANOU.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Fight {

    struct Game {
        address player1;
        uint256 animalPlayer1; 

        uint256 bet;
        bool exists;
        bool done;
    }

    mapping (uint256=>Game) private games;
    uint256 private counter = 0;
    DANOU private danou = new DANOU();

    // constructor() public {
    //     danou = new DANOU();
    // }

    function proposeToFight(uint256 tokenId) public payable {
        require(danou.isOwnerOf(tokenId) == true, "You must be the owner of the NFT !");
        Game memory game = Game(msg.sender, tokenId, msg.value, true, false);
        games[counter] = game;
        counter += 1;
    }

    function agreeToFight(uint256 game_index, uint256 tokenId) public payable {
        require(danou.isOwnerOf(tokenId) == true, "You must be the owner of the NFT !");
        Game memory game = games[game_index];
        require(game.exists == true, "The game doesn't exist !");
        require(msg.value == game.bet, "The bet doesn't match with the value sent !");
        require(!game.done, "Challenge already done !");

        if (tokenId > game.animalPlayer1) {
            danou.deadAnimal(game.animalPlayer1);
            msg.sender.transfer(game.bet);
        } else {
            danou.deadAnimal(tokenId);
            msg.sender.transfer(game.bet);
        }
        game.done = true;
    }
} 