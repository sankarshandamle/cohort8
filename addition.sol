// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.5;       // specifying the compiler version


/* contract code is written within this */
contract Add {

    // declaring three integers
    uint256 x;
    uint256 y;
    uint256 sum;

    // writing a function
    function submitNumbers(uint256 _a, uint256 _b) public returns(bool) {
        x = _a;
        y = _b;
        sum = x+y;
        return true;
    }

    // writing a view functin
    function getSum() public view returns(uint256) {
        return sum;
    }

}
