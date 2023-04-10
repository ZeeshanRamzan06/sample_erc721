
// SPDX-License-Identifier: GPL-3.0

pragma solidity   ^0.8.0;

contract SamplecONTRUCTR {

 struct InspectorDetail {
     uint ID ;
     address LandInspectorAddress;
     string Name ;
 } 

 InspectorDetail public landispector;

 constructor(uint id , string memory name){
     landispector.ID = id;
     landispector.LandInspectorAddress = msg.sender;
     landispector.Name = name;
 }


   function getname()  public view returns(string memory _name){
       return landispector.Name;
   } 


}