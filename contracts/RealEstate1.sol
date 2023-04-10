// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;
  // 12,Ali,22,inspector
contract RealEstate{

  /*
    This struct contains the details of land.
  */
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
 /*
    This struct contains the details of Seller.
  */

  struct Seller{
    
   string Name;
   uint Age;
   string City;
   uint256 CNIC;
   string Email;
   bool isVerified;
 }
/*
    This struct contains the details of Buyer.
  */
  struct Buyer{
   string Name;
   uint256 Age;
   string City;
   uint CNIC;
   string Email;
   bool isVerified;
 }
 /*
    This struct is contain the details of LandInspector.
  */
  struct LandInspectorDetail {
    uint Id;
    address landInspecterAddress;
    string Name;
    uint Age;
    string designation;
 }

  event Status( string message,address add);
//Mappings
  mapping (address => Seller) public sellerMapp; //This mapping is used to store the value of seller.
  mapping (address => Buyer) public buyerMapp; //This mapping is used to store the value of buyer.
  mapping (uint => landDetail) public landMapp; //This mapping is used to store the value of lands.
   
  
  

   LandInspectorDetail public landInspecter;  // this struct type variable store information of landinspector
   bytes data;  // this state variable for get responce from call function

    /*  This modifier is check  LandInspector  allowed  */
   modifier OnlyLandInspector() {
       require (landInspecter.landInspecterAddress == msg.sender,"Only LandInspector Allowed");
       _;
   }
/*  This modifier is check  LandInspector not  allowed  */
   modifier landInspectornotAllowed(){

       require (landInspecter.landInspecterAddress != msg.sender ,"landInspector not Allowed");
       _;
   }
//  This contstructor is used for adding the information of landInspecter.

   constructor(uint id,string memory name,uint age,string memory _designation){

       landInspecter.landInspecterAddress = msg.sender;
       landInspecter.Id = id;
       landInspecter.Name = name;
       landInspecter.Age = age;
       landInspecter.designation = _designation;
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
       require(sellerMapp[msg.sender].isVerified == false, "buyer not Allowed.");
      sellerMapp[msg.sender] = Seller ( _name,_age,_city,_cnic,_email,false );
     emit Status( "Seller Register Successfuly",msg.sender);
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
       require(buyerMapp[msg.sender].isVerified == false, "Seller not Allowed.");
       buyerMapp[msg.sender] = Buyer ( _name,_age,_city,_cnic,_email,false );
       emit Status( "Buyer Register Successfuly",msg.sender);
   }
  
       /*
     * @dev verifySeller is used to verify the seller.
     * Requirement:
     * - This function can be called by landInspector.
     * @param sellerAddress - it is for sellerAddress .
     * Emits a {Status} event.
    */

       function verifySeller(address sellerAddress) OnlyLandInspector  public {
        require(sellerMapp[sellerAddress].isVerified == false, "Seller is not verified");
         sellerMapp[sellerAddress].isVerified = true;
        emit Status( "Seller Verify Successfuly",msg.sender);
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
        emit Status( "Bayer Verify Successfuly",msg.sender);
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
       emit Status( "Land Register Successfuly",msg.sender);
   }
     /**
     * @dev verifyLand is used to check that land is verified or not.
     * @param landid - landid 
     * Emits a {Status} event.
    */

    function verifyLand(uint256 landid) public OnlyLandInspector {
       
         landMapp[landid].isVerified = true;
        emit Status( "Land Verify Successfuly" ,msg.sender);
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
        require(sellerMapp[msg.sender].isVerified == true, "seller is not register or verified");
       sellerMapp[msg.sender] =Seller ( _name,_age,_city,_cnic,_email,false);
       emit Status( "Seller Updated Successfuly",msg.sender);
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
      function updatebuyer ( string memory _name,
       uint _age,
       string  memory _city,
       uint _cnic,
       string memory _email 
       ) public {
         require(buyerMapp[msg.sender].isVerified == true, "buyer is not register or verified");
       buyerMapp[msg.sender] =Buyer ( _name,_age,_city,_cnic,_email,false);
       emit Status( "Buyer Updated Successfuly",msg.sender);
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
      function getLandDetails(uint256 _landid) public view returns(string memory,
      string memory,string memory,uint256,uint256,bool) {
       landDetail memory lands = landMapp[_landid];
       return (lands.Area,lands.City,lands.State,lands.LandPrice,lands.PropertyPID,lands.isVerified);

      }
      
     
      
       /**
     * @dev landOwner is used to check who is current owner of the land.
     * Requirement:
     * - This function can be called by anyone
     * @param _landid -  it is used to get land id.
  
    */

      function landOwner(uint256 _landid) public view returns(address) {
        return landMapp[_landid].owner;

      }
      /**
     * @dev buyLand is used to transfer the ownership  of the land.
     * Requirement:
     * - This function can be called by only if land is verified.
     * @param _landId -  for landId
     * Emits a {Status} event.
    */
     function buyLand(uint  _landId)public payable {
     require(buyerMapp[msg.sender].isVerified == false, "buyer is not verified or register");    
     require (landMapp[_landId].LandPrice < 0,"You have insufficient Balance");
     (bool success,bytes memory _data)=(landMapp[_landId].owner).call{value:msg.value,gas:2000}("");
     landMapp[_landId].owner = msg.sender;
     data =_data;
     require (success,"ether send successfully");
     emit Status( "Land sale successfuly",msg.sender);
     }
}