pragma solidity ^0.5.5;

import "./KaseiCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
// Added portion to attempt capped crowdsale
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
// Added portion to attempt timed crowdsale
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";

contract KaseiCoinCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale {
    
    constructor(
        uint rate,
        address payable wallet,
        KaseiCoin token,
        uint256 cap, // max amount of wei allowed to be raised
        uint256 OpenTime, // start time
        uint256 CloseTime // end time
        
    ) Crowdsale(rate, wallet, token)
      CappedCrowdsale(cap)
      TimedCrowdsale(OpenTime,CloseTime)
    public {
    }
}

contract KaseiCoinCrowdsaleDeployer {
    address public kasei_token_address;
    address public kasei_crowdsale_address;

    constructor(
        string memory name,
        string memory symbol,
        address payable wallet,
        uint256 cap, // max amount of wei allowed to be raised
        uint256 OpenTime, // start time
        uint256 CloseTime // end time
    )
    public 
    {
        KaseiCoin token = new KaseiCoin(name, symbol, 0);
        kasei_token_address = address(token);
        KaseiCoinCrowdsale kasei_crowdsale = new KaseiCoinCrowdsale(1, wallet, token, cap, OpenTime, CloseTime);
        kasei_crowdsale_address = address(kasei_crowdsale);
        token.addMinter(kasei_crowdsale_address);
        token.renounceMinter();
    }
}