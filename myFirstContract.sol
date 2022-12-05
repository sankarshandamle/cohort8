// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.5;       // specifying the compiler version


/* contract code is written within this */
contract myFirstContract {

    // declaring a string
    string data;

    // writing a function
    function submitData(string memory _d) public returns(bool) {
        data = _d;
        return true;
    }

    // writing a view functin
    function getData() public view returns(string memory) {
        return data;
    }

}
