// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
contract MyAtm{

uint256 private pin;
uint256 private balance;
bool public  inAccess;
error loginfail();

constructor(uint256 _pin){
   pin =_pin;
   balance = 2000;

}
  function signIn(uint pass) public returns(string memory ){
      if(pin == pass){
          inAccess= true; 
          return "login successfully";
      }else{
          revert loginfail();
      }
  }

  function withDraw(uint256 amount) public {
      if(inAccess){

require (balance > amount, "Insufficient balance");
require ( amount > 500,"Minimum withdraw is 501 ");
              
          balance -= amount;
          
  }
  else{revert loginfail();
   }
  }

   function Deposit(uint256 amount) public {
      if(inAccess){

     require (amount >= 1000, "Minimum deposit 1000");
              
          balance += amount;
          
  }
   }
}