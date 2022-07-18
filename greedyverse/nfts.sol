pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import"@openzeppelin/contracts/utils/math/SafeMath.sol";

contract greedyverseNfts is ERC1155, Ownable{
    using SafeMath for uint256;

    address payable public gameContract;
    address payable public teamWallet;

    uint256[30] public maxNftsAmount = [45000, 15000, 1200000, 1200000, 30000, 30000, 24000, 24000, 9000, 15000, 45000, 15000,
                                2700, 4500, 3600, 60000, 90000, 3600, 120000, 60000, 2400, 2700, 2400, 15000, 60000,
                                15000, 120000, 240000, 60000,30000];
    
    uint256[30] public mintedNftsAmount = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    uint256[30] public nftMintPrice = [86000000000000010,258000000000000000,3225000000000000,3225000000000000,129000000000000000,129000000000000000,161250000000000000,161250000000000000,430000000000000050,258000000000000000,86000000000000010,258000000000000000,1433333333333333300,860000000000000100,1075000000000000200,64500000000000000,43000000000000003,1075000000000000200,32250000000000000,64500000000000000,1612500000000000000,1433333333333333300,1612500000000000000,258000000000000000,64500000000000000,258000000000000000,32250000000000000,16125000000000000,64500000000000000,387000000000000000];

     uint256 public spMaxNftAmount_perNft = 30;
     uint256 public MaxStoneWall_per_player = 30;
     uint256 public MaxWoodWall_per_player = 30;
     uint256 public MaxLand_per_player = 5;


    mapping (address => mapping(uint256 => uint256)) public singlePlayeramount;

    mapping(address => bool) isWhiteListed;

    bool public Mint = false;
    bool public PublicMint = false;


    constructor() ERC1155("https://greedyverse.co/api/getNftMetaData.php?id={id}"){
      gameContract = payable(0x08dA4Adffca7B2B7b819042052C13fF8D059a620);
      teamWallet = payable(0x86D4d40af737A5914F06C834316D207b29908714);
    }

    function addToWhiteList(address user) public onlyOwner{
        isWhiteListed[user] = true;
    }

     function removeFromWhiteList(address user) public onlyOwner{
        isWhiteListed[user] = false;
    }

    function whiteListMint(uint256 id, uint256 amount) public payable{
        require(!PublicMint, "Private mint is ended");
        require(isWhiteListed[msg.sender], "Address not whitelisted for minting");
        _mint(id,amount);
    }

      function mint(uint256 id, uint256 amount) public payable{
        require(PublicMint, "Public mint has not started");
        _mint(id,amount);
    }

    function _mint(uint256 id, uint256 amount) internal {
         require(Mint, "Minting has not started");
         require(msg.sender != address(0), "Cannot mint to a zero address");
         require(mintedNftsAmount[id].add(amount) < maxNftsAmount[id], "Mint amount not available");
         require(msg.value >= nftMintPrice[id].mul(amount), "Amount too small to mint nft");
         if(id == 2){
             require((singlePlayeramount[msg.sender][id].add(amount) <= MaxWoodWall_per_player), "You can not mint more than 30 wood walls");
         }else if(id == 3){
             require((singlePlayeramount[msg.sender][id].add(amount) <= MaxStoneWall_per_player), "You can not mint more than 30 stone walls");
         }else if(id == 29){
             require((singlePlayeramount[msg.sender][id].add(amount) <= MaxLand_per_player), "You can not mint more than 5 land");
         }else{
             require((singlePlayeramount[msg.sender][id].add(amount) <= spMaxNftAmount_perNft), "You can not mint more than 30 of any NFT");
         }
         depositeProceeds();
         mintedNftsAmount[id] = mintedNftsAmount[id].add(amount);
        _mint(msg.sender, id, amount, "");
        singlePlayeramount[msg.sender][id] = singlePlayeramount[msg.sender][id].add(amount);
    }

    function depositeProceeds() private {
        (bool success1, ) = gameContract.call{value: msg.value.div(2)}("");
        require(success1, "Failed to deposite to gameContract");
        (bool success2, ) = teamWallet.call{value: msg.value.div(2)}("");
        require(success2, "Failed to team wallet");
    }

    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes memory data) public override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "ERC1155: caller is not token owner nor approved"
        );
         if(id == 2){
             require((singlePlayeramount[to][id].add(amount) <= MaxWoodWall_per_player), "No address can own more than 30 wood walls");
         }else if(id == 3){
             require((singlePlayeramount[to][id].add(amount) <= MaxStoneWall_per_player), "No address can own more than 30 stone walls");
         }else if(id == 29){
             require((singlePlayeramount[to][id].add(amount) <= MaxLand_per_player), "No address can own more than 5 land");
         }else{
             require((singlePlayeramount[to][id].add(amount) <= spMaxNftAmount_perNft), "No address can own more than 30 of any NFT");
         }
        _safeTransferFrom(from, to, id, amount, data);
        singlePlayeramount[from][id] = singlePlayeramount[from][id] - amount;
        singlePlayeramount[to][id] = singlePlayeramount[to][id] + amount;
    }

    function safeBatchTransferFrom(address from,address to,uint256[] memory ids,uint256[] memory amounts,bytes memory data) public override{
        
        for(uint256 i = 0; i < ids.length;i++){


            require(
                    from == _msgSender() || isApprovedForAll(from, _msgSender()),
                    "ERC1155: caller is not token owner nor approved"
            );
            uint256 id = ids[i];
            uint256 amount = amounts[i];
         if(id == 2){
             require((singlePlayeramount[to][id].add(amount) <= MaxWoodWall_per_player), "No address can own more than 30 wood walls");
         }else if(id == 3){
             require((singlePlayeramount[to][id].add(amount) <= MaxStoneWall_per_player), "No address can own more than 30 stone walls");
         }else if(id == 29){
             require((singlePlayeramount[to][id].add(amount) <= MaxLand_per_player), "No address can own more than 5 land");
         }else{
             require((singlePlayeramount[to][id].add(amount) <= spMaxNftAmount_perNft), "No address can own more than 30 of any NFT");
         }
        }
        _safeBatchTransferFrom(from,to,ids,amounts,data);
    }

    function getPlayerNftCount(address account, uint256 id) public view returns(uint256){
        return singlePlayeramount[account][id];
    }


    function startMint() public onlyOwner{
        Mint = true;
    }

    function endMint() public onlyOwner{
        Mint = false;
    }

     function starPrivatetMint() public onlyOwner{
        PublicMint = true;
    }

    function endPrivatetMint() public onlyOwner{
        PublicMint = false;
    }
}
