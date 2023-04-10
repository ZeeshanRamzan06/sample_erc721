// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;
  // 12,Ali,22,inspector
contract RealEstate{

  // we creat all struct of project
  struct landDetail{
    uint landId;
    string Area;
    string City;
    string State;
    uint LandPrice;
    uint PropertyPID;
    bool isVerified;
    address owner;
    
 }

  struct Seller{
    
   string Name;
   uint Age;
   string City;
   uint256 CNIC;
   string Email;
   bool isVerified;
  //  address sellerAddress; 
 }

  struct Buyer{
   
   string Name;
   uint256 Age;
   string City;
   uint CNIC;
   string Email;
   bool isVerified;
  //  address buyerAddress;
 }
  struct LandInspectorDetail {
    uint Id;
    address landInspecterAddress;
    string Name;
    uint Age;
    string designation;
 }

  event Status(address add, string message);
// mappings
   mapping (uint => landDetail) public landMapp;
   mapping (address => Buyer) public buyerMapp;
   mapping (address => Seller) public sellerMapp;
  

   LandInspectorDetail public landInspecter;
   bytes public data;
    
// contstructor
   constructor(uint id,string memory name,uint age,string memory _designation){

       landInspecter.landInspecterAddress = msg.sender;
       landInspecter.Id = id;
       landInspecter.Name = name;
       landInspecter.Age = age;
       landInspecter.designation = _designation;
   }

   modifier OnlyLandInspector() {
       require (landInspecter.landInspecterAddress == msg.sender,"Only LandInspector Allowed");
       _;
   }

   modifier landInspectornotAllowed(){

       require (landInspecter.landInspecterAddress != msg.sender ,"landInspector not Allowed");
       _;
   }

  
  
   
  /**
     * @dev sellerReg is used to register Seller.
     * Requirement:
     * - This function can be called by Seller.
     * @param _name - its for user name.
     * @param _age -  its for user age. 
     * @param _city - its for user city.  
     * @param _cnic -  its for user cnic.
     * @param _email - its for userr email.
     * Emits a {Status} event.
    */

    function sellerReg( string memory _name,
     uint _age,
     string  memory _city,
     uint _cnic,
     string memory _email
     
  ) public landInspectornotAllowed {
       require(buyerMapp[msg.sender].isVerified == false, "buyer not Allowed.");
      sellerMapp[msg.sender] = Seller ( _name,_age,_city,_cnic,_email,false);
     emit Status(msg.sender, "Seller Register Successfuly");
  }
/**
     * @dev buyerReg is used to register Buyer.
     * Requirement:
     * - This function can be called by Buyer.
     * @param _name - its for user name.
     * @param _age -  its for user age. 
     * @param _city - its for user city.  
     * @param _cnic -  its for user cnic.
     * @param _email - its for userr email.
     * Emits a {Status} event.
    */
      function buyerReg(string memory _name,
      uint _age,
      string  memory _city,
      uint _cnic,
      string memory _email
     
      ) public landInspectornotAllowed  {
      require(sellerMapp[msg.sender].isVerified == false, "Seller not Allowed.");
       buyerMapp[msg.sender] = Buyer ( _name,_age,_city,_cnic,_email,false);
       emit Status(msg.sender, "Buyer Register Successfuly");
   }
  
       /**
     * @dev verifySeller is used to verify the seller.
     * Requirement:
     * - This function can be called by landInspector.
     * @param sellerAddress - it is for sellerAddress .
     * Emits a {Status} event.
    */

       function verifySeller(address sellerAddress) OnlyLandInspector  public {
        require(sellerMapp[sellerAddress].isVerified == false, "Seller is not verified");
         sellerMapp[sellerAddress].isVerified = true;
        emit Status(msg.sender, "Seller Verify Successfuly");
       }
       
       /**
     * @dev verifybuyer is used to verify the Buyer.
     * Requirement:
     * - This function can be called by landInspector.
     * @param buyerAddress -it is for buyerAddress 
     * Emits a {Status} event.
    */
        function verifybuyer(address buyerAddress) OnlyLandInspector  public {
        require(buyerMapp[buyerAddress].isVerified == false, "buyer is not verified");
         buyerMapp[buyerAddress].isVerified = true;
        emit Status(msg.sender, "Bayer Verify Successfuly");
       }
       /**
     * @dev landReg is used to register Land.
     * Requirement:
     * - This function can be called by Seller.
     * @param _landId - it is used for landId. 
     * @param area -  it i used for land area. 
     * @param city -it is used for  city or location. 
     * @param state - it is for state.
     * @param landPrice -  it is for adding  landPrice.
     * @param PropertyPID -  its for adding PropertyPID.
     * Emits a {Status} event.
    */

      function landReg(uint _landId,
      string memory area,
      string memory city,
      string memory state,
      uint landPrice,
      uint PropertyPID
      )public {
      require(sellerMapp[msg.sender].isVerified == false, "Seller not verified.");
       landMapp[_landId] = landDetail(_landId,area,city,state,landPrice,PropertyPID,false,msg.sender);
       emit Status(msg.sender, "Land Register Successfuly");
   }
     /**
     * @dev verifyLand is used to check that land is verified or not.
     * @param landid - landid 
     * Emits a {Status} event.
    */

    function verifyLand(uint256 landid) public OnlyLandInspector {
       
         landMapp[landid].isVerified = true;
        emit Status(msg.sender, "Land Verify Successfuly");
       }

      /**
     * @dev updateSeller is used to update the seller details.
     * Requirement:
     * - This function can be called only if seller is register and verified.
     * @param _name - _name 
     * @param _age -  _age 
     * @param _city - _city  
     * @param _cnic -  _cnic
     * @param _email -  _email
     * Emits a {Status} event.
    */
       function updateSeller( string memory _name,
        uint _age,
        string  memory _city,
        uint _cnic,
        string memory _email
        ) public {
        require(buyerMapp[msg.sender].isVerified == false, "buyer is not register or verified");
       sellerMapp[msg.sender] =Seller ( _name,_age,_city,_cnic,_email,false);
       emit Status(msg.sender, "Seller Updated Successfuly");
     }

      /**
     * @dev updatebuyer is used to update the Buyer details.
     * Requirement:
     * - This function can be called only if Buyer is register and verified.
     * @param _name -  for name 
     * @param _age - for  age 
     * @param _city -for  city  
     * @param _cnic - for cnic
     * @param _email - for  email
     * Emits a {Status} event.
    */
      function updatebuyer( string memory _name,
       uint _age,
       string  memory _city,
       uint _cnic,
       string memory _email 
       ) public {
        require(sellerMapp[msg.sender].isVerified == false, "buyer is not register or verified");
       buyerMapp[msg.sender] =Buyer ( _name,_age,_city,_cnic,_email,false);
       emit Status(msg.sender, "Buyer Updated Successfuly");
     }
       /**
     * @dev sellerIsVerfied is used to check that seller is verified or not.
     * @param isSellerAddress - for used to checke seller is verified or not. 
    */
       function sellerIsVerfied(address isSellerAddress) public view returns(bool){
        
           return sellerMapp[isSellerAddress].isVerified;
      
       }
        /**
     * @dev buyerIsVerfied is used to check that buyer is verified or not.
     * @param isbuyerAddress - isbuyerAddress 
    */
        function buyerIsVerfied(address isbuyerAddress) public view returns(bool){
        
           return buyerMapp[isbuyerAddress].isVerified;
       }

   /**
     * @dev getLandDetails is used to get All details of Land.
     * Requirement:
     * - This function can be called by anyone
    */
      function getLandDetails(uint256 landid) public view returns(string memory,
      string memory,string memory,uint256,uint256,bool) {
       landDetail memory lands = landMapp[landid];
       return (lands.Area,lands.City,lands.State,lands.LandPrice,lands.PropertyPID,lands.isVerified);

      }
      
     
      
       /**
     * @dev landOwner is used to check who is current owner of the land.
     * Requirement:
     * - This function can be called by anyone
     * @param landid -  landid
    */

      function landOwner(uint256 landid) public view returns(address) {
        return landMapp[landid].owner;

      }
      /**
     * @dev buyLand is used to transfer the ownership  of the land.
     * Requirement:
     * - This function can be called by only if land is verified.
     * @param _landId -  for landId
     * Emits a {Status} event.
    */
     function buyLand(uint  _landId)public payable {
     require (landMapp[_landId].LandPrice > 0 ether,"You have insufficient Balance");
     (bool success,bytes memory _data)=(landMapp[_landId].owner).call{value:msg.value,gas:2000}("");
     landMapp[_landId].owner = msg.sender;
     data =_data;
     require (success,"ether send successfully");
     emit Status(msg.sender, "Land sale successfuly");
     }
}