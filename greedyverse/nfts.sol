pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import"@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";


interface IPancakeRouter01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

// File: contracts\interfaces\IPancakeRouter02.sol

pragma solidity >=0.6.2;

interface IPancakeRouter02 is IPancakeRouter01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}



contract greedyverseNfts is ERC1155, Ownable{
    using SafeMath for uint256;

    address payable public marketing_contestWallet;
    address payable public teamWallet;
    address payable public gameDevWallet;

    string public name = "GreedyVerseNFT";
    string public symbol = "GNFT";

    uint256[30] public maxNftsAmount = [90000, 30000, 1800000, 1800000, 60000, 60000, 48000, 48000, 27000, 30000, 90000, 30000, 8100, 13500, 21600, 120000, 180000, 21600, 240000, 120000, 7200, 8100, 9750, 30000, 120000, 30000, 240000, 480000, 120000, 60000];
    
    uint256[30] public mintedNftsAmount = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

// In Wei
    uint256[30] public nftMintPrice = [
        40000000000000000,
        120000000000000000,
        1500000000000000,
        1500000000000000,
        60000000000000000,
        60000000000000000,
        75000000000000000,
        75000000000000000,
        133333333333333330,
        120000000000000000,
        40000000000000000,
        120000000000000000,
        444444444444444400,
        266666666666666660,
        166666666666666660,
        30000000000000000,
        20000000000000000,
        166666666666666660,
        15000000000000000,
        30000000000000000,
        500000000000000000,
        444444444444444400,
        369230769230769250,
        120000000000000000,
        30000000000000000,
        120000000000000000,
        15000000000000000,
        7500000000000000,
        30000000000000000,
        156000000000000000
    ];

    uint256 public landMintingPrice = 120000000000000000;
    uint256 tax = 30000000000000000;

      //  uint256 public spMaxNftAmount_perNft = 40;
    //  uint256 public MaxStoneWall_per_player = 30;
    //  uint256 public MaxWoodWall_per_player = 30;
    //  uint256 public MaxLand_per_player = 5;
    //  uint256 public MaxDragon_per_player = 2;
    //  uint256 public MaxBabyDragon_per_player = 2;
    //  uint256 public MaxGolem_per_player = 3;
    //  uint256 public MaxGrandWarden_per_player = 3;
    //  uint256 public MaxDrone_per_player = 3;

    uint256[9] public max_nfts_amount = [40,30,30,5,2,2,3,3,3];


     address greedyverseToken = 0x732bfaFB57c940CEc3983c49000D1340d3F7BB39;

     IPancakeRouter02 public immutable pancakeswapV2Router;

     struct nftItem
        {
            uint256 totalHealth;
            uint256 amount;
        }

    mapping (address => mapping(uint256 => nftItem)) public holders;

    mapping (address => mapping(uint256 => uint256)) public singlePlayeramount;

    mapping(string => bool) public paymentConfirmations;

    // mapping(address => bool) isWhiteListed;

    mapping(address => uint256) public winnings;

    bool public Mint = false;
    bool public PublicMint = false;
    // bool public privateMint = false;
    // bool public firstLandMint = false;
    bool public LandMint = false;


    constructor() ERC1155("https://greedyverse.co/api/getNftMetaData.php?id={id}"){
      marketing_contestWallet = payable(0x39216B5e5fB7b08081eA0a107957d8C7AC197C25);
      teamWallet = payable(0x23f7E43F6Ada4f265f8184Ef842570b86fB8a367);
      gameDevWallet = payable(0xe2D4190c70A84EEF16f9490bA22C2f14Ec47fdc5);

      IPancakeRouter02 _pancakeswapV2Router = IPancakeRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
      pancakeswapV2Router = _pancakeswapV2Router;
    }

    // function addToWhiteList(address user) public onlyOwner{
    //     isWhiteListed[user] = true;
    // }

    //  function removeFromWhiteList(address user) public onlyOwner{
    //     isWhiteListed[user] = false;
    // }

    // function whiteListMint(uint256 id, uint256 amount) public payable{
    //     require(isWhiteListed[msg.sender], "!w");
    //     if(privateMint){
    //         _mint(id,amount,false);
    //     }else if(firstLandMint){
    //         _mint(id,amount,true);
    //     }
        
    // }
    
     function mintLand(uint256 amount) public payable{
         require(LandMint, "ExLc");
         uint256 id = 29;
       _mint(id,amount,true);
        
    }

     function revive(uint256 id, uint256 amount) public payable{
        require(msg.sender != address(0), "0a");
        require(msg.value >= (nftMintPrice[id].div(2)).mul(amount), "asm");

        holders[msg.sender][id].totalHealth = holders[msg.sender][id].totalHealth.add((nftMintPrice[id].div(2)).mul(amount));
    }

    function payWinnings(uint256[] memory player1destructionlist, uint256[] memory player2destructionlist, address player1, address player2, string memory battleID) public payable onlyOwner{
        uint256 TotalPlayer1payment = 0;
        uint256 TotalPlayer2payment = 0;
   
        for (uint i=0; i<player1destructionlist.length; i++) {
           TotalPlayer1payment = TotalPlayer1payment.add(nftMintPrice[player1destructionlist[i]].div(2)); 
           holders[player2][player1destructionlist[i]].totalHealth = holders[player2][player1destructionlist[i]].totalHealth.sub(nftMintPrice[player1destructionlist[i]].div(2));
        }

        for (uint i=0; i<player2destructionlist.length; i++) {
           TotalPlayer2payment = TotalPlayer2payment.add(nftMintPrice[player2destructionlist[i]].div(2)); 
           holders[player1][player1destructionlist[i]].totalHealth = holders[player1][player1destructionlist[i]].totalHealth.sub(nftMintPrice[player2destructionlist[i]].div(2));
        }

        winnings[player1] = winnings[player1].add(TotalPlayer1payment);

        winnings[player2] = winnings[player2].add(TotalPlayer2payment);

        paymentConfirmations[battleID] = true;
    } 


      function claimTokens() public payable {
       
       require(winnings[msg.sender] > 0, "0b");

         address[] memory path = new address[](2);
        path[0] = pancakeswapV2Router.WETH();
        path[1] = greedyverseToken;
        
        
        if(winnings[msg.sender] < 2000000000000000){

        (bool success1, ) = payable(msg.sender).call{value: winnings[msg.sender].sub(winnings[msg.sender].mul(tax))}("");
        require(success1);

        }
        else{
        pancakeswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: winnings[msg.sender].sub(winnings[msg.sender].mul(tax))}(
            0, 
            path, 
            msg.sender,
            block.timestamp + 15
        );
    }
        winnings[msg.sender] = 0;

        (bool success2, ) = marketing_contestWallet.call{value: winnings[msg.sender].mul(tax)}("");
        require(success2);

    }

        

      function mint(uint256 id, uint256 amount) public payable{
        require(PublicMint, "!s");
        _mint(id,amount,false);
    }

    function check_conditions(uint256 id, uint256 amount) private view returns(bool){
        if(id == 2){
             require((singlePlayeramount[msg.sender][id].add(amount) <= max_nfts_amount[2]));
         }else if(id == 3){
             require((singlePlayeramount[msg.sender][id].add(amount) <= max_nfts_amount[1]));
         }else if(id == 29){
             require((singlePlayeramount[msg.sender][id].add(amount) <= max_nfts_amount[3]));
         }else if(id == 20){
             require((singlePlayeramount[msg.sender][id].add(amount) <= max_nfts_amount[4]));
         }else if(id == 21){
             require((singlePlayeramount[msg.sender][id].add(amount) <= max_nfts_amount[5]));
         }else if(id == 22){
             require((singlePlayeramount[msg.sender][id].add(amount) <= max_nfts_amount[6]));
         }else if(id == 14){
             require((singlePlayeramount[msg.sender][id].add(amount) <= max_nfts_amount[7]));
         }else if(id == 8){
             require((singlePlayeramount[msg.sender][id].add(amount) <= max_nfts_amount[8]));
         }else{
             require((singlePlayeramount[msg.sender][id].add(amount) <= max_nfts_amount[0]));
         }
         return true;
    }

    function _mint(uint256 id, uint256 amount, bool landMinting) internal {
         require(Mint, "!s");
         require(msg.sender != address(0), "0a");
         require(mintedNftsAmount[id].add(amount) < maxNftsAmount[id], "au");
         if(!landMinting){
            require(msg.value >= nftMintPrice[id].mul(amount), "asm");
         }else{
            require(msg.value >= landMintingPrice.mul(amount), "asm");
         }
         require(check_conditions(id,amount),"");

         depositeProceeds(id);
         mintedNftsAmount[id] = mintedNftsAmount[id].add(amount);
        _mint(msg.sender, id, amount, "");
        singlePlayeramount[msg.sender][id] = singlePlayeramount[msg.sender][id].add(amount);

        holders[msg.sender][id].totalHealth = (holders[msg.sender][id].totalHealth).add((nftMintPrice[id].div(2)).mul(amount)) ;
        holders[msg.sender][id].amount = holders[msg.sender][id].amount.add(amount);
    }

    function depositeProceeds(uint256 id) private {

        if(id == 29){
        (bool success1, ) = marketing_contestWallet.call{value: msg.value.div(3)}("");
        require(success1);

        (bool success2, ) = teamWallet.call{value: msg.value.div(3)}("");
        require(success2);

        (bool success3, ) = gameDevWallet.call{value: msg.value.div(3)}("");
        require(success3);

        }else{
        (bool success2, ) = teamWallet.call{value: msg.value.div(2)}("");
        require(success2);
        }

        
    }

    function registerTransfer(address from, address to, uint256 id, uint256 amount)private{
         singlePlayeramount[from][id] = (singlePlayeramount[from][id]).sub(amount);
        singlePlayeramount[to][id] = (singlePlayeramount[to][id]).add(amount);

        holders[from][id].totalHealth = (holders[from][id].totalHealth).sub((nftMintPrice[id].div(2)).mul(amount));
        holders[from][id].amount = (holders[from][id].amount).sub(amount);
        holders[to][id].totalHealth = (nftMintPrice[id].div(2)).mul(amount);
        holders[to][id].amount = amount;
    }

    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes memory data) public override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "!owner||a"
        );
        require(check_conditions(id,amount));

        _safeTransferFrom(from, to, id, amount, data);

        registerTransfer(from, to, id, amount);
       
    }

    function safeBatchTransferFrom(address from,address to,uint256[] memory ids,uint256[] memory amounts,bytes memory data) public override{
        
        for(uint256 i = 0; i < ids.length;i++){


            require(
                    from == _msgSender() || isApprovedForAll(from, _msgSender()),
                    "!owner||a"
            );
            uint256 id = ids[i];
            uint256 amount = amounts[i];
            require(check_conditions(id,amount));

            registerTransfer(from, to, id, amount);

        }
        _safeBatchTransferFrom(from,to,ids,amounts,data);
    }


    function getPlayerNftAmount(address account, uint256 id) public view returns(uint256){
        return holders[account][id].amount;
    }

    function getPlayerNftTotalHealth(address account, uint256 id) public view returns(uint256){
        return holders[account][id].totalHealth;
    }

    function check_paymentConfirmations(string memory battleID) public view returns(bool){
        return paymentConfirmations[battleID];
    }

    function startMint() public onlyOwner{
        Mint = true;
    }

    function endMint() public onlyOwner{
        Mint = false;
    }

    //  function start_end_MintType(bool _privatemint, bool _PublicMint, bool _firstLandMint) public onlyOwner{
    //     PublicMint = _PublicMint;
    //     privateMint = _privatemint;
    //     firstLandMint = _firstLandMint;
    // }

    function start_end_MintType(bool _PublicMint, bool _LandMint, uint256 _landMintingPrice) public onlyOwner{
        PublicMint = _PublicMint;
        LandMint = _LandMint;
        if(_LandMint){
            landMintingPrice = _landMintingPrice;
        }
        nftMintPrice[29] = landMintingPrice;
    }

   
}
