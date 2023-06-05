// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, Ownable {
  

 /*
    This struct contains the details of Premium User.
  */

    struct premiumUser {
        address addUser;
        uint256 globalLimit;
        bool isRegistered;
        string userRole;
        bool isVerified;
    }
/*
    This struct contains the details of Normal User.
  */
     struct normalUser {
        address addUser;
        uint256 globalLimit;
        bool isRegistered;
        string userRole;
    }
/*
    This struct contains the details of Phase.
  */
    struct phase {
        uint256 reservedLimit;
        bool isActive;
        uint256 premiumLimit;
        uint256 normalLimit;
        mapping(address => uint256) premiumUserBalance;
        mapping(address => uint256) normalUserBalance;
    }


      struct BulkNfts {
          uint id;
          string uri ;
      } 


    mapping(uint256 => phase) public phasesMapp; //This mapping is used to store the value of phase.
    mapping(address => premiumUser) public premiumUserMapp;//This mapping is used to store the value of primium user.
    mapping(address => normalUser) public normalUserMapp;//This mapping is used to store the value of normal userr.
    mapping(address => bool) public adminMapp;//This mapping is used for changing the address of admin.
// initialize the variable
    uint256 public maxMintingLimit;   
    uint256 public platformMintingLimit;
    uint256 public userMintingLimit;
    uint256 public currentPhase;
    bool isTransferable;
// This constructor is used for 
    constructor(uint256 _maxLimit, uint256 _platformLimit) ERC721("MyToken", "ZEE") {
        maxMintingLimit = _maxLimit;
        platformMintingLimit = _platformLimit;
        userMintingLimit = maxMintingLimit - platformMintingLimit;
    }

     /**
     * @dev registerUser is used to register User.
     * Requirement:
     * - Only  owner can call this function..
     * @param _add - its for user name.
     * @param _userLim -  its for user age. 
     * @param _role - its for user city.  
    */

 function registerUser(address _add, uint _userLim, string memory _role) public onlyOwner {
 // Check that the address is not null
    require(_add != address(0), "Null address is not allowed.");
   
 // Check that the address is not already registered as a premium user
    require(premiumUserMapp[_add].isRegistered == false, "User Already Registered as Premium");
   
// Check that the address is not already registered as an admin
    require(adminMapp[_add] == false, "User already registered as Admin");
    
// Check that the address is not already registered as a normal user
    require(normalUserMapp[_add].isRegistered == false, "User is already registered as normal");
    
 // If the role is "normal"
    if (keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("normal"))) {
        // Create a new normalUser instance and add it to the mapping
        normalUserMapp[_add] = normalUser(_add, _userLim, true, _role);
         // If the role is "premium"
    } else if (keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("premium"))) {
      // Create a new premiumUser instance and add it to the mapping
        premiumUserMapp[_add] = premiumUser(_add, _userLim, true, _role, false);
         // If the role is "admin"
    } else if (keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("admin"))) {
       // Mark the address as an admin in the admin mapping
        adminMapp[_add] = true;
        
    } else {
        require(false, "Incorrect Role");
        // If the role is not "normal", "premium", or "admin", throw an error
    }
}


 /* @param add address of  Premium user to  verified.
 * User Registration Required
 */
 function VerifiedPerm(address _add) public onlyOwner {
    // Check if the user is registered
    require(premiumUserMapp[_add].isRegistered == true, "User is not registered");
    // Check if the user is not already verified
    require(premiumUserMapp[_add].isVerified == false, "User is already active");
    
    // Set the user's verification status to true
    premiumUserMapp[_add].isVerified = true;
}

function CreatePhase(uint _PhaseReservedLim, uint PermiunReservedLim, uint NormalReservedLim) public onlyOwner {
    // Check if the current phase is not already active
    require(phasesMapp[currentPhase].isActive == false, "Phase already active");
    // Check if the given phase reserved limit is within the user minting limit
    require(_PhaseReservedLim < userMintingLimit, "User limit is exceeded");
    // Check if the current phase is not already created
    require(phasesMapp[currentPhase].reservedLimit == 0, "Phase already created");

    // Set the reserved, premium, and normal limits for the current phase
    phasesMapp[currentPhase].reservedLimit = _PhaseReservedLim;
    phasesMapp[currentPhase].premiumLimit = PermiunReservedLim;
    phasesMapp[currentPhase].normalLimit = NormalReservedLim;
}

// This function is used to check the phase is active
  
function ActivePhase() public onlyOwner {
    // Check if the current phase is not already active
    require(phasesMapp[currentPhase].isActive == false, "Phase is already active");
    // Check if the premium limit for the current phase is set (phase is created)
    require(phasesMapp[currentPhase].premiumLimit != 0, "Phase is not created");

    // Activate the current phase
    phasesMapp[currentPhase].isActive = true;
}
// This function is used to check the phase is not Active
function DeactivatePhase() public onlyOwner {
    // Check if the current phase is active
    require(phasesMapp[currentPhase].isActive == true, "Phase not active");
    // Check if the premium limit for the current phase is set (phase is created)
    require(phasesMapp[currentPhase].premiumLimit != 0, "Phase not created");

    // Deactivate the current phase
    phasesMapp[currentPhase].isActive = false;
    // Move to the next phase
    currentPhase++;
}

// This function used to mint the NFT
    function safeMint(address to, uint256 tokenId , string memory uri)public{
      // Check if the user is registered as a premium or normal user
      require(premiumUserMapp[msg.sender].isRegistered ||  normalUserMapp[msg.sender].isRegistered , "Registration Required"); 
      // Check if the current phase is active and created
      require(phasesMapp[currentPhase].isActive ," Phase not Active or Created!");
      // Check if the global user minting limit is available
      require(userMintingLimit > 0 , " Gloabl User Mint Limit  Exceed!  ");
       // Check if the phase's reserved limit is available
      require(phasesMapp[currentPhase].reservedLimit >  0  , " Phase Resrved Limit Exceed");
   
        if(premiumUserMapp[msg.sender].isRegistered){
          // Check if the premium user is verified
         require(premiumUserMapp[msg.sender].isVerified, "Permium User NOT verified"); 
          // Check if the premium user's global limit is not exceeded
         require(balanceOf(msg.sender) < premiumUserMapp[msg.sender].globalLimit , " Permium User  Gloabl Limit EXCEED"  );
         // Check if the phase's premium limit for the user is available
         require(phasesMapp[currentPhase].premiumLimit  > phasesMapp[currentPhase].premiumUserBalance[msg.sender], " Permiun  User Phase Limit Exceed!"  )  ;                                                
            phasesMapp[currentPhase].premiumUserBalance[msg.sender]++;
        }   
        else{
        require(balanceOf(msg.sender) <  normalUserMapp[msg.sender].globalLimit , " Normal User  Gloabl Limit EXCEED"  );
         require(phasesMapp[currentPhase].normalLimit  > phasesMapp[currentPhase].normalUserBalance[msg.sender], "  Normal User Phase Limit Exceed!"  )  ;                                                
        phasesMapp[currentPhase].normalUserBalance[msg.sender]++;

        }    
      
       userMintingLimit--;
       phasesMapp[currentPhase].reservedLimit--; 


        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
       
    }


 // Function to bulk mint multiple tokens
function BulkMints(string[] memory uri, uint[] memory tokenid, address[] memory to) public {
   
    // Check if the input arrays have valid lengths
    require(uri.length == tokenid.length && tokenid.length == to.length, "Please Enter Valid LENGTH");
    
    // Check if the sender is a registered premium or normal user
    require(premiumUserMapp[msg.sender].isRegistered || normalUserMapp[msg.sender].isRegistered, "Registration Required");
    
    // Check if the current phase is active
    require(phasesMapp[currentPhase].isActive, "Phase not Active or Created!");
    
    // Check if the global user minting limit allows for the requested number of mints
    require(userMintingLimit - uri.length > 0, "Global User Mint Limit Exceeded!");
    
    // Check if the current phase's reserved limit allows for the requested number of mints
    require(phasesMapp[currentPhase].reservedLimit - uri.length > 0, "Phase Reserved Limit Exceeded");

    for (uint i = 0; i < uri.length; i++) {
        if (premiumUserMapp[msg.sender].isRegistered) {
            // Check if the premium user is verified
            require(premiumUserMapp[msg.sender].isVerified, "Premium User NOT verified");
            
            // Check if the premium user's global limit allows for the additional mint
            require(balanceOf(msg.sender) + (uri.length - i) < premiumUserMapp[msg.sender].globalLimit, "Premium User Global Limit Exceeded");
            
            // Check if the current phase's premium limit allows for the additional mint
            require(phasesMapp[currentPhase].premiumLimit > phasesMapp[currentPhase].premiumUserBalance[msg.sender] + (uri.length - i), "Premium User Phase Limit Exceeded");
            
            phasesMapp[currentPhase].premiumUserBalance[msg.sender]++;
        } else {
            // Check if the normal user's global limit allows for the additional mint
            require(balanceOf(msg.sender) + (uri.length - i) < normalUserMapp[msg.sender].globalLimit, "Normal User Global Limit Exceeded");
            
            // Check if the current phase's normal limit allows for the additional mint
            require(phasesMapp[currentPhase].normalLimit > phasesMapp[currentPhase].normalUserBalance[msg.sender] + (uri.length - i), "Normal User Phase Limit Exceeded");
            
            phasesMapp[currentPhase].normalUserBalance[msg.sender]++;
        }

        userMintingLimit--;
        phasesMapp[currentPhase].reservedLimit--;

        // Mint the token and set its URI
        _safeMint(to[i], tokenid[i]);
        _setTokenURI(tokenid[i], uri[i]);
    }
}

    // Function to allow the admin to mint multiple tokens   
 function AdminMint(string[] memory uri, uint[] memory tokenid) public {
    // Check if the input arrays have valid lengths
    require(uri.length == tokenid.length, "Please Enter Valid length");
    // Check if the sender is the admin
    require(adminMapp[msg.sender], "only admin Allowed");
    // Check if the platform minting limit allows for the requested number of mints
    require(platformMintingLimit > 0, "Platform Minting Limit Exceeded");

    for (uint i = 0; i < uri.length; i++) {
        // Mint the token and set its URI
        _safeMint(msg.sender, tokenid[i]);
        _setTokenURI(tokenid[i], uri[i]);
        
        // Decrease the platform minting limit
        platformMintingLimit--;
    }
}

    
    
  // Function to update the global limit for a user
  function UpdateGloabalLimit(address _add, uint limit) public onlyOwner {
    // Check if the user's balance is less than the specified limit
    require(balanceOf(_add) < limit, "Limit should be greater than the balance");

    if (premiumUserMapp[_add].isRegistered) {
        // If the user is registered as a premium user, update their global limit
        premiumUserMapp[_add].globalLimit = limit;
    } else if (normalUserMapp[_add].isRegistered) {
        // If the user is registered as a normal user, update their global limit
        normalUserMapp[_add].globalLimit = limit;
    } else {
        // If the user is not registered as a normal or premium user, throw an error
        require(false, "User Not Registered as Normal or Premium");
    }
}

 // Function to update the reserved limit for the current phase
function UpdateReservedLimit(uint _lim) public onlyOwner {
    // Check if the current phase is active
    require(phasesMapp[currentPhase].isActive, "Phase Not Active");
    // Check if the specified limit is greater than the current reserved limit
    require(_lim > phasesMapp[currentPhase].reservedLimit, "Limit greater than reserved limit");

    // Update the reserved limit for the current phase
    phasesMapp[currentPhase].reservedLimit = _lim;
}
    



// Internal function to transfer the ownership of an NFT
function _transfer(address from, address to, uint256 tokenId) internal override(ERC721) {
    // Check if transfers are currently allowed
    require(isTransferable, "Transfer Deactivated");

    // Call the _transfer function from the parent contract to perform the transfer
    super._transfer(from, to, tokenId);
}

 // Function to allow transfers of NFTs
    function AllowTransfer() public onlyOwner {
    // Check if transfers are already allowed
    require(!isTransferable, "Already Allowed");

    // Set the transferability flag to true, allowing transfers
    isTransferable = true;
}



     
 // Function to update the URIs of multiple NFTs in bulk
 function UpdatesHashes(BulkNfts[] memory DataArray) public {
    for (uint i = 0; i < DataArray.length; i++) {
        // Check if the caller is the owner of the NFT
        if (ownerOf(DataArray[i].id) == msg.sender) {
            // Update the URI of the NFT
            _setTokenURI(DataArray[i].id, DataArray[i].uri);
        }
    }
}


// Function to fetch the NFTs owned by a specific address
function FetchNfts(address _add) public view returns (BulkNfts[] memory) {
    // Check if the address has a non-zero balance
    require(balanceOf(_add) > 0, "Invalid Balance");

    // Create an array to store the fetched NFTs
    BulkNfts[] memory nftsArray = new BulkNfts[](balanceOf(_add));

    for (uint i = 0; i < balanceOf(_add); i++) {
        // Retrieve the ID and URI of each NFT owned by the address
        uint id = tokenOfOwnerByIndex(_add, i);
        string memory uri = tokenURI(id);
        
        // Store the NFT in the array
        nftsArray[i] = BulkNfts(id, uri);
    }

    // Return the array of fetched NFTs
    return nftsArray;
}


// Function to pause the contract and disable certain operations
    function pause() public onlyOwner {
        _pause();
    }
// Function to unpause the contract and enable operations
    function unpause() public onlyOwner {
        _unpause();
    }



    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    
// Internal function to burn (destroy) an NFT
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }
// Function to retrieve the URI of an NFT
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

// Function to check if a contract supports a given interface
   function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC721, ERC721Enumerable, ERC721URIStorage)
    returns (bool)
{
    return super.supportsInterface(interfaceId);
}

}