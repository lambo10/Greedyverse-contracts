pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import"@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


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

    uint256 public maxLand = 200000000000000000000000;

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

     address greedyverseToken_addr = 0x8850D2c68c632E3B258e612abAA8FadA7E6958E5;
     address busd_contract_address = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
     IERC20 public greedyverse_token = IERC20(greedyverseToken_addr);
     IERC20 public busd_token = IERC20(busd_contract_address);
     

     IPancakeRouter02 public immutable pancakeswapV2Router;

     struct nftItem
        {
            uint256 totalHealth;
            uint256 amount;
        }

    mapping (address => mapping(uint256 => nftItem)) public holders;

    mapping (address => mapping(uint256 => uint256)) public singlePlayeramount;

    mapping (address => mapping(string => mapping(uint256 => uint256)))  public paymentConfirmations;

    mapping (address => mapping(uint256 => uint256))  public current_purchase_balances;

    mapping (address => mapping(address => mapping(string => bool))) public battleReqs;

    mapping (address => bool)  public battles;

    

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

    function buyBusd() public payable {
        address[] memory path = new address[](2);
        path[0] = pancakeswapV2Router.WETH();
        path[1] = busd_contract_address;
        
        pancakeswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}(
            0, 
            path, 
            address(this),
            block.timestamp + 15
        );
    }

    function getBNBtoBusdPrice(uint256 bnbvalue)private view returns(uint256){
        address[] memory ao_path = new address[](2);
        ao_path[0] = busd_contract_address;
        ao_path[1] = pancakeswapV2Router.WETH();
        return uint256(pancakeswapV2Router.getAmountsIn(bnbvalue, ao_path)[0]);
    }

    function makeMintPayment(uint256 id) public payable{
    
        uint256 amoutOut = getBNBtoBusdPrice(msg.value);
        require(amoutOut >= nftMintPrice[id]);
        buyBusd();
        current_purchase_balances[msg.sender][id] = current_purchase_balances[msg.sender][id].add(uint256(amoutOut));
        
    }
    
    //  function mintLand(uint256 amount) public{
    //      require(LandMint);
    //      uint256 id = 29;
    //    _mint(id,amount,true);
    // }

    function dispatch_busd_Funds(address to,uint256 amount)private{
        busd_token.transfer(to, amount);
    }

     function revive(uint256 id, uint256 amount) public payable{
        require(msg.sender != address(0));
        uint256 amoutOut = getBNBtoBusdPrice(msg.value);
        uint256 wkr_nftMintPrice = nftMintPrice[id];
        require(amoutOut >= wkr_nftMintPrice.mul(amount));
        buyBusd();
        holders[msg.sender][id].totalHealth = holders[msg.sender][id].totalHealth.add(wkr_nftMintPrice.mul(amount));
    }

    function start_end_battle(address opponent, string memory battleID, bool startBattle)public {
        address player = msg.sender;
        battleReqs[player][opponent][battleID] = startBattle;
        bool opponentBattleReq = battleReqs[opponent][player][battleID];
        if((startBattle && opponentBattleReq) || (!startBattle && !opponentBattleReq)){
            battles[player] = startBattle;
            battles[opponent] = startBattle;
        }
        
    }


    function payWinnings(uint256 id, uint256 amount, address player1, address player2, string memory battleID)public onlyOwner{
        
        uint256 wkr_nftMintPrice = nftMintPrice[id];
        uint256 wkr_nftMintPrice_m_a = wkr_nftMintPrice.mul(amount);
        holders[player2][id].totalHealth = holders[player2][id].totalHealth.sub(wkr_nftMintPrice_m_a);
      
        winnings[player1] = winnings[player1].add(wkr_nftMintPrice_m_a);

        paymentConfirmations[player1][battleID][id] = wkr_nftMintPrice_m_a;
  
    }


    function approveBusdExpenditure() public onlyOwner{
        busd_token.approve(0x10ED43C718714eb63d5aA57B78B54704E256024E, 1000000000000000000000000);
    }


    function claimTokens() public {

       uint256 playerWinnings = winnings[msg.sender];
       require(playerWinnings > 0);
   
        address[] memory path = new address[](2);
        path[0] = busd_contract_address;
        path[1] = greedyverseToken_addr;
        
        pancakeswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            playerWinnings,
            0,
            path, 
            msg.sender,
            block.timestamp + 15
        );
      

        winnings[msg.sender] = winnings[msg.sender].sub(playerWinnings);

    }

        

      function mint(uint256 id, uint256 amount) public {
        require(PublicMint || LandMint);
        if(LandMint){
            _mint(29,amount);
        }else if(PublicMint){
            _mint(id,amount);
        }
        
    }


    function check_conditions(uint256 id, uint256 amount) private view returns(bool){
        uint256 singlePlayeramount_sunit = singlePlayeramount[msg.sender][id].add(amount);
        if(id == 2){
             require((singlePlayeramount_sunit <= max_nfts_amount[2]));
         }else if(id == 3){
             require((singlePlayeramount_sunit <= max_nfts_amount[1]));
         }else if(id == 29){
             require((singlePlayeramount_sunit <= max_nfts_amount[3]));
         }else if(id == 20){
             require((singlePlayeramount_sunit <= max_nfts_amount[4]));
         }else if(id == 21){
             require((singlePlayeramount_sunit <= max_nfts_amount[5]));
         }else if(id == 22){
             require((singlePlayeramount_sunit <= max_nfts_amount[6]));
         }else if(id == 14){
             require((singlePlayeramount_sunit <= max_nfts_amount[7]));
         }else if(id == 8){
             require((singlePlayeramount_sunit <= max_nfts_amount[8]));
         }else{
             require((singlePlayeramount_sunit <= max_nfts_amount[0]));
         }
         return true;
    }

        function _mint(uint256 id, uint256 amount) internal {
         require(Mint);
         require(msg.sender != address(0));
         uint256 paymentAmount = current_purchase_balances[msg.sender][id];
         uint256 itemPrice = 0;
         uint256 playerMnftA = mintedNftsAmount[id].add(amount);
         uint256 nftMintPrice_s = nftMintPrice[id];
         require(playerMnftA < maxNftsAmount[id]);

            uint256 nftMprice = nftMintPrice_s.mul(amount);
            require(paymentAmount >= nftMprice);
            itemPrice = nftMprice;
       
         require(check_conditions(id,amount));

          if(id == 29){
        uint256 value_div3 = itemPrice;
        dispatch_busd_Funds(marketing_contestWallet, value_div3);
        dispatch_busd_Funds(teamWallet, value_div3);
        dispatch_busd_Funds(gameDevWallet, value_div3);
        }
         mintedNftsAmount[id] = playerMnftA;
        _mint(msg.sender, id, amount, "");

        current_purchase_balances[msg.sender][id] = paymentAmount.sub(itemPrice);

        singlePlayeramount[msg.sender][id] = singlePlayeramount[msg.sender][id].add(amount);

        holders[msg.sender][id].totalHealth = (holders[msg.sender][id].totalHealth).add((nftMintPrice_s).mul(amount));
        holders[msg.sender][id].amount = holders[msg.sender][id].amount.add(amount);
    }

    function registerTransfer(address from, address to, uint256 id, uint256 amount)private{
         singlePlayeramount[from][id] = (singlePlayeramount[from][id]).sub(amount);
        singlePlayeramount[to][id] = (singlePlayeramount[to][id]).add(amount);

        holders[from][id].totalHealth = (holders[from][id].totalHealth).sub((nftMintPrice[id]).mul(amount));
        holders[from][id].amount = (holders[from][id].amount).sub(amount);
        holders[to][id].totalHealth = (nftMintPrice[id]).mul(amount);
        holders[to][id].amount = amount;
    }

    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes memory data) public override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender())
        );
        require(check_conditions(id,amount));
        require(!battles[from]);

        _safeTransferFrom(from, to, id, amount, data);

        registerTransfer(from, to, id, amount);
       
    }

    function safeBatchTransferFrom(address from,address to,uint256[] memory ids,uint256[] memory amounts,bytes memory data) public override{
        
        for(uint256 i = 0; i < ids.length;i++){


            require(
                    from == _msgSender() || isApprovedForAll(from, _msgSender())
            );
            uint256 id = ids[i];
            uint256 amount = amounts[i];
            require(check_conditions(id,amount));
            require(!battles[from]);

            registerTransfer(from, to, id, amount);

        }
        _safeBatchTransferFrom(from,to,ids,amounts,data);
    }


    // function getPlayerNftAmount(address account, uint256 id) public view returns(uint256){
    //     return holders[account][id].amount;
    // }

    function getPlayerNftTotalHealth(address account, uint256 id) public view returns(uint256){
        return holders[account][id].totalHealth;
    }

    function check_paymentConfirmations(string memory battleID, uint256 id, address player) public view returns(uint256){
        return paymentConfirmations[player][battleID][id];
    }

    function start_end_MintType(bool _mintValue, bool _PublicMint, bool _LandMint) public onlyOwner{
        Mint = _mintValue;
        PublicMint = _PublicMint;
        LandMint = _LandMint; 
    }

    function setMintPrice(uint256 id, uint256 amount) public onlyOwner{
        nftMintPrice[id] = amount;
    }

    function setNftsMintableAmount(uint256 id, uint256 amount)public onlyOwner{
        if(id == 29){
            require(amount <= maxLand);
        }
        maxNftsAmount[id] = amount;
    }

   
}
