// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

struct Seller {
    string name;
    uint age;
    string city;
    string CNIC;
    string email;
    bool isVerified;
}

struct Buyer {
    string name;
    uint age;
    string city;
    string CNIC;
    string email;
    bool isVerified;
}

struct Land {
    uint landId;
    uint area;
    string city;
    string state;
    uint landPrice;
    uint propertyPID;
    address currentOwner;
    bool isVerified;
}

struct LandInspector {
    uint id;
    string name;
    uint age;
    string designation;
}
mapping(address => Seller) public sellerMapping;
mapping(address => Buyer) public buyerMapping;
mapping(uint => Land) public landMapping;
mapping(address => LandInspector) public inspectorMapping;

function registerSeller(string memory _name, uint _age, string memory _city, string memory _CNIC, string memory _email) public {
    require(!sellerMapping[msg.sender].isVerified, "Seller already verified");
    Seller memory seller = Seller(_name, _age, _city, _CNIC, _email, true);
    sellerMapping[msg.sender] = seller;
}

function verifySeller(address _sellerAddress) public {
    require(inspectorMapping[msg.sender].designation == "LandInspector", "Only Land Inspector can verify sellers");
    require(!sellerMapping[_sellerAddress].isVerified, "Seller already verified");
    sellerMapping[_sellerAddress].isVerified = true;
}

function addLand(uint _landId, uint _area, string memory _city, string memory _state, uint _landPrice, uint _propertyPID) public {
    require(sellerMapping[msg.sender].isVerified, "Seller not verified");
    Land memory land = Land(_landId, _area, _city, _state, _landPrice, _propertyPID, msg.sender, false);
    landMapping[_landId] = land;
}

function verifyLand(uint _landId) public {
    require(inspectorMapping[msg.sender].designation == "LandInspector", "Only Land Inspector can verify lands");
    require(sellerMapping[landMapping[_landId].currentOwner].isVerified, "Seller not verified");
    landMapping[_landId].isVerified = true;
}

function registerBuyer(string memory _name, uint _age, string memory _city, string memory _CNIC, string memory _email) public {
    require(!buyerMapping[msg.sender].isVerified, "Buyer already verified");
    Buyer memory buyer = Buyer(_name, _age, _city, _CNIC, _email, false);
    buyerMapping[msg.sender] = buyer;
}

function verifyBuyer(address _buyerAddress) public {
    require(inspectorMapping[msg.sender].designation == "LandInspector", "Only Land Inspector can verify buyers");
    require(!buyerMapping[_buyerAddress].isVerified, "Buyer already verified");
    buyerMapping[_buyerAddress].isVerified = true;
}
