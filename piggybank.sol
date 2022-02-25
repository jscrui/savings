//SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.7;

import "./@openzeppelin/contracts/access/Ownable.sol";
import "./@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract PiggyBank is Ownable{

    IERC20 token;    

    uint256 public minBalanceToWithdraw;
    uint256 public balance;
    
    /**
    * @notice this constructor defines the token and the initial minium balance to withdraw this token.
    * @param _token defines the main token.
    * @param _minBalanceToWithdraw sets the minnium balance of token to be withdrawn. 
    */
    constructor(address _token, uint256 _minBalanceToWithdraw){
        token = IERC20(_token);
        minBalanceToWithdraw = _minBalanceToWithdraw;
    }
        
    /**
     * @notice This function allows owner of the contract to withdraw their money once it reaches the minBalanceToWithdraw.          
     */
    function withdraw() external onlyOwner{        
        balance = token.balanceOf(address(this));
        require(balance >= minBalanceToWithdraw, "Contract Balance is not enought.");        
        token.transfer(msg.sender, balance);
    }

    /**
    * @notice This function allows owner of the contract to withdraw other tokens that are not the main one, for example BNB 
    * if the contract is to save the BUSD Token. 
    * @param _token should be the token address to withdraw. 
    */
    function withdrawEmergency(address _token) external onlyOwner{
        IERC20 emergencyToken;
        emergencyToken = IERC20(_token);
        require(emergencyToken != token, "You are trying to withdraw the main Token.");        
        uint256 emergencyBalance = emergencyToken.balanceOf(address(this));
        emergencyToken.transfer(msg.sender, emergencyBalance);
    }

    /**
     * @notice This function allows owner of the contract to increase minBalanceToWithdraw.
     * @param _minBalanceToWithdraw should be higher than previous minBalanceToWithdraw.
     */
    function setMinBalanceToWithdraw(uint256 _minBalanceToWithdraw) external onlyOwner{
        require(_minBalanceToWithdraw > minBalanceToWithdraw, "New minBalanceToWithdraw is less than previous one.");
        minBalanceToWithdraw = _minBalanceToWithdraw;
    }

}
