// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

//

contract wallet {
    address Owner;

    struct User {
        uint256 id;
        string name;
        uint256 balance;
        bool KycVerified;
    }

    mapping(address => User) public UsersList;
    mapping(address => uint256) public balances;
   event status(string,address);

   modifier onlyOwner(){
       require (msg.sender == Owner, "only owner impoved kyc");
       _;
   }
   
   constructor(){
       Owner= msg.sender;
   }

   // first we register the user
   function  registerUser( uint _id , string memory _name)  public { 
  UsersList[msg.sender] = User(_id,_name,4,false);
  emit status ("User has been Added",msg.sender);
   }

  // we approve the user adress
   function ApprovedUser( address _add) public onlyOwner {
       UsersList[_add].KycVerified= true;
   }
   

  // we check the is verified or not!
   function verifyUser() public view returns(bool){
    return UsersList[msg.sender].KycVerified ;

   }

     // we deposite the balance in the address
   function deposite() public payable{
     require(UsersList[msg.sender].KycVerified,"Kyc not approved");
     UsersList[msg.sender].balance += msg.value;

   }
     
     // this function is use to check the balance of contract
     function checkBlance() public view returns(uint){

       return UsersList[msg.sender].balance;
     }
       
       // in thic function we wtidraw the amount
     function withdraw(uint amount) public payable {
         require(UsersList[msg.sender].KycVerified,"Kyc not approved");
         require(balances[msg.sender] >= amount, "Insufficient balance.");
        UsersList [msg.sender].balance -=  amount;
        payable(msg.sender).transfer(amount);
       

     }

  // we tranfer amount to outof the contract address
     function transfer(address recipient, uint256 amount ) public {
         require(UsersList[msg.sender].KycVerified,"Kyc not approved");
         require(balances[msg.sender] >= amount, "Insufficient balance.");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;

     }

}
