// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;
   
    // send ether with three methods

contract sendether {
    bytes public data;
    mapping(address => uint256) public balance;

   //1- using transfer method;
    function sendEtherwtihTransfer(address payable _addr) public payable{

    _addr.transfer(msg.value);
    }

   // 2- using send method;
    function sendetherwithSend(address payable to) public payable{

    require (balance[to] < 3 ether,"Your Account Limit Reached");
    bool sent = to.send(msg.value);
    balance[to] +=msg.value;
    require (sent,"failed to send Ether");
    }

   //3- using call method;
   function sendetherwithCall(address payable _to)public payable {

  (bool success,bytes memory _data)=_to.call{value:msg.value,gas:2000}("");
  data =_data;
  require (success,"ether send successfully");



   }

    }








