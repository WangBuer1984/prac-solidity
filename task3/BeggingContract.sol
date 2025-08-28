// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
contract BeggingContract{

    address payable public  owner;
    mapping (address => uint256) public donations;
    uint256 public totalDonations;
     // 捐赠时间限制
    uint256 public donationStartTime;
    uint256 public donationEndTime;
    bool isDonationPeriodActive = false;

    event DonationReceived(address indexed donor,uint256 amount,uint256 timestamp);
    error WithdrawFail();
      // 回退函数：防止直接向合约地址发送以太币
   receive() external payable { 

   }

    constructor(uint256 _donationStartTime, uint256 _donationEndTime) payable {
        require(_donationStartTime < _donationEndTime, "Start time must be before end time");
        require(_donationEndTime > block.timestamp, "End time must be in the future");
        
        donationStartTime = _donationStartTime;
        donationEndTime = _donationEndTime;
        isDonationPeriodActive = true;
        owner = payable (msg.sender);
        
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "only owner can!");
        _;
    }

    modifier checkDonationTime(){
        require(donationStartTime < donationEndTime, "Start time must be before end time");
        require(donationEndTime > block.timestamp, "End time must be in the future");
        _;
    }

    function donate(uint256 amount_) external payable checkDonationTime{
        require(amount_>0,"amount must be greater than 0");
        donations[msg.sender] += amount_;
        emit DonationReceived(msg.sender,amount_,block.timestamp);
    }

    function withdraw() external onlyOwner{
        uint256 balance = address(this).balance;
        require(balance>0,"no token");
        (bool success,) = owner.call{value:balance}("");
        if(!success){
            revert WithdrawFail();
        }
    }

    // 查询函数：获取特定地址的捐赠金额
    function getDonation(address donor) external view returns (uint256) {
        return donations[donor];
    }
    
    // 获取合约当前余额
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
    
  
}