//SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.7;

import "./@openzeppelin/contracts/access/Ownable.sol";
import "./@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract PiggyBank is Ownable{

    IERC20 token;    

    uint256 public minDateToWithdraw;
    uint256 public balance;
    
    /**
    * @notice this constructor defines the token and the initial minium date to withdraw this token.
    * @param _token defines the main token.
    * @param _minDateToWithdraw sets the minnium date to enable token withdrawn. 
    */
    constructor(address _token, uint256 _minDateToWithdraw){
        token = IERC20(_token);
        minDateToWithdraw = _minDateToWithdraw;
    }
        
    /**
     * @notice This function allows owner of the contract to withdraw their money once it reaches the minDateToWithdraw.          
     */
    function withdraw() external onlyOwner{        
        balance = token.balanceOf(address(this));
        require(block.timestamp >= minDateToWithdraw, "You are trying to withdraw before withdraw date.");        
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
     * @notice This function allows owner of the contract to increase minDateToWithdraw.
     * @param _minDateToWithdraw should be after than previous minDateToWithdraw.
     */
    function setMinDateToWithdraw(uint256 _minDateToWithdraw) external onlyOwner{
        require(_minDateToWithdraw > minDateToWithdraw, "New minDateToWithdraw is before the previous one.");
        minDateToWithdraw = _minDateToWithdraw;
    }

}
