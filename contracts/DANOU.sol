pragma solidity ^0.7.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract DANOU is ERC721 {

    struct Profile {
        string firstname;
        string lastname;
        uint16 age;
        string kind;
        bool exists;
    }

    struct Auction {
        address beneficiary;
        uint256 endTime;
        uint256 highestBid;
        address highestBidder;
        bool claimed;
        bool bidClaimed;
    }

    // Events that will be emitted on changes.
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);
    
    mapping (address=>bool) private breeder;
    mapping (uint256=>Profile) private profiles;
    mapping (uint256=>Auction[]) private auctions;
    mapping (address=>uint256) private pendingReturns;
    uint256 private counter = 0;

    constructor() ERC721("DANOU", "DAN") public {
        // _safeMint(msg.sender, 0);
    }

    function declareAnimal(string memory firstname, string memory lastname, uint16 age, string memory kind) public {
        require(breeder[msg.sender] == true);
        _safeMint(msg.sender, counter);
        profiles[counter] = Profile(firstname, lastname, age, kind, true);
        counter += 1;
    }

    function registerBreeder() public {
        breeder[msg.sender] = true;
    }

    function deadAnimal(uint256 tokenId) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "You must be the owner !");
        _burn(tokenId);
    }

    function breedAnimal(uint256 tokenId1, uint256 tokenId2) public {
        require(_isApprovedOrOwner(msg.sender, tokenId1), "You must be the owner !");
        require(_isApprovedOrOwner(msg.sender, tokenId2), "You must be the owner !");

        Profile memory profile1 = profiles[tokenId1];
        Profile memory profile2 = profiles[tokenId2];

        declareAnimal(profile1.firstname, profile2.lastname, profile1.age, profile2.kind);
    }

    function createAuction(uint256 tokenId) public {
        //require(_isApprovedOrOwner(msg.sender, tokenId), "You must be the owner !");
        Auction[] storage local_auctions = auctions[tokenId];
        uint256 length = local_auctions.length;
        require(length == 0 || local_auctions[length-1].claimed == true, "Last auction still not claimed !");

        uint256 endTime = block.timestamp + 2 days;
        auctions[tokenId].push(Auction(msg.sender, endTime, 0, msg.sender, false, false));
        _transfer(msg.sender, address(this), tokenId);
    }

    function bidOnAuction(uint256 tokenId) public payable {
        Auction[] storage local_auctions = auctions[tokenId];
        uint256 length = local_auctions.length;
        require(length == 0, "No auction exists !");
        Auction memory auction = local_auctions[local_auctions.length-1];
        require(block.timestamp <= auction.endTime, "Auction already ended !");
        require(auction.highestBid < msg.value, "There already is a higher bid !");

        if (auction.highestBid != 0) {
            pendingReturns[auction.highestBidder] += auction.highestBid;
        }

        auction.highestBidder = msg.sender;
        auction.highestBid = msg.value;
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    // Claim the NFT
    function claimAuction(uint256 tokenId) public {
        Auction[] storage local_auctions = auctions[tokenId];
        uint256 length = local_auctions.length;
        require(length == 0, "No auction exists !");
        Auction memory auction = local_auctions[local_auctions.length-1];
        require(block.timestamp > auction.endTime, "Auction is not already ended !");
        require(msg.sender == auction.highestBidder, "You are not the highest bidder !");
        require(!auction.claimed, "claimAuction has already been called.");

        auction.claimed = true;
        emit AuctionEnded(auction.highestBidder, auction.highestBid);
        _transfer(address(this), auction.highestBidder, tokenId);
    }

    // Claim the BID
    function claimBid(uint256 tokenId, uint256 auction_index) public {
        Auction[] memory local_auctions = auctions[tokenId];
        uint256 length = local_auctions.length;
        require(length == 0, "No auction exists !");
        Auction memory auction = local_auctions[auction_index];
        require(block.timestamp > auction.endTime, "Auction is not already ended !");
        require(msg.sender == auction.beneficiary, "You are not the Beneficiary !");
        require(!auction.bidClaimed, "claimBid has already been called.");

        auction.bidClaimed = true;
        //Transfer(address(this), auction.beneficiary, auction.highestBid);
        msg.sender.transfer(auction.highestBid);
    }

    /// Withdraw a bid that was overbid.
    function withdraw() public returns (bool) {
        //Auction memory auction = auctions[tokenId][auction_index];
        uint256 amount = pendingReturns[msg.sender];
        if (amount > 0) {
            // It is important to set this to zero because the recipient
            // can call this function again as part of the receiving call
            // before `send` returns.
            pendingReturns[msg.sender] = 0;

            if (!msg.sender.send(amount)) {
                // No need to call throw here, just reset the amount owing
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }

    function isOwnerOf(uint256 tokenId) public view returns (bool) {
        return _isApprovedOrOwner(msg.sender, tokenId);
    }
} 