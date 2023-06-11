// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.7.5;


contract SimpleAuction {
    
    uint auctionEnd;
    address public highestBidder;
    uint public highestBid;
    
    // Allowed withdrawals of previous bids
    mapping(address => uint) pendingReturns;

    // Set to true at the end, disallows any change
    bool ended;

    // Events that will be fired on changes.
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    constructor (uint _biddingTime) { 
        auctionEnd = block.timestamp + _biddingTime;        // unix epoch: 1 Jan 1970, 00:00:00 UTC
    } // seconds passed from the unix epoch to when this block was mined

    function bid() public payable {
        require (msg.value > highestBid);
        if (highestBid != 0) {
            pendingReturns[highestBidder] = pendingReturns[highestBidder]+ highestBid;
        }
        highestBidder = msg.sender;
        highestBid = msg.value;
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    function withdraw() public returns (bool) {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            pendingReturns[msg.sender] = 0;
            if (!msg.sender.send(amount)) { // payeeAddress.send(amount)
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true; 
    }

    function getFunds() view public returns(uint) {
        return address(this).balance;  // accountAddress.balance
    }

    function EndAuction() public {
        // 1. Conditions
        require (!ended); // this function has already been called
        // 2. Effects
        ended = true;
        emit AuctionEnded(highestBidder, highestBid);
    }
    
}
