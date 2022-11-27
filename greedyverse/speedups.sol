pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import"@openzeppelin/contracts/utils/math/SafeMath.sol";


contract speedups is  Ownable{
    using SafeMath for uint256;

    address payable public marketing_contestWallet;
    address payable public teamWallet;
    address payable public gameDevWallet;

    uint256 public speedUpTrainingAmount = 5000000000000000;
    uint256 public speedUpConstructionAmount = 5000000000000000;
    uint256 public twentyFourHourShield = 5000000000000000;

    mapping (address => mapping(string => bool))  public paymentConfirmations;

    constructor() {
      marketing_contestWallet = payable(0x39216B5e5fB7b08081eA0a107957d8C7AC197C25);
      teamWallet = payable(0x23f7E43F6Ada4f265f8184Ef842570b86fB8a367);
      gameDevWallet = payable(0xe2D4190c70A84EEF16f9490bA22C2f14Ec47fdc5);

    }

     function speedupTraining(string memory paymentID) public payable{
         require(msg.value >= speedUpTrainingAmount, "Amount too small");
         depositeProceeds();
         paymentConfirmations[msg.sender][paymentID] = true;
    }

      function speedupConstruction(string memory paymentID) public payable{
         require(msg.value >= speedUpConstructionAmount, "Amount too small");
         depositeProceeds();
         paymentConfirmations[msg.sender][paymentID] = true;
    }

    function twentyFourHourShield_payment(string memory paymentID) public payable{
         require(msg.value >= twentyFourHourShield, "Amount too small");
         depositeProceeds();
         paymentConfirmations[msg.sender][paymentID] = true;
    }

        function depositeProceeds() private {

        (bool success1, ) = marketing_contestWallet.call{value: msg.value.div(3)}("");
        require(success1);

        (bool success2, ) = teamWallet.call{value: msg.value.div(3)}("");
        require(success2);

        (bool success3, ) = gameDevWallet.call{value: msg.value.div(3)}("");
        require(success3);
 
    }

    function setSpeedUpTrainingAmount(uint256 _speedUpTrainingAmount)public onlyOwner{
        speedUpTrainingAmount = _speedUpTrainingAmount;
    }

    function setSpeedUpConstruction(uint256 _speedUpConstructionAmount)public onlyOwner{
        speedUpConstructionAmount = _speedUpConstructionAmount;
    }

    function setTwentyFourHourShield(uint256 _twentyFourHourShield)public onlyOwner{
        twentyFourHourShield = _twentyFourHourShield;
    }

    function get_paymentConfirmations(address account, string memory paymentID)public view returns(bool){
       return paymentConfirmations[account][paymentID];
    }

   
}

