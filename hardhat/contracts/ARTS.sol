// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ARTS is ERC721Enumerable, Ownable{
    
    //Converts a uint256 to its ASCII string representation.
    using Strings for uint256;

    // this will store a NFTs base metadata URI 
    string _baseTokenURI;

    // price of the one nft
    uint256 public _price = 0.1 ether;

    //_paused is uded to pause the contract in case of any malicious activity
    bool public _paused;

    //total number of TOkenids minted
    uint256 public tokenIDs;

    // max number of ART punks
    uint256 public maxTokenIDs = 5;

    modifier onlyWhenNotPaused{
        require(!_paused , "Contract is currently Paused");
        _;
    }


    constructor(string memory baseURI) ERC721("ART Punks", "ATP"){
        _baseTokenURI = baseURI;
    }

    // allows an user to mint 1 NFT per transaction.
    function Mint() public payable onlyWhenNotPaused{

        require(tokenIDs < maxTokenIDs, "Exceed maximum ART Punk Supply");
        require(msg.value >= _price , "eSent is not Correct!");
        tokenIDs = tokenIDs +1; 

        //  mint the nft to the user
        _safeMint(msg.sender, tokenIDs);        
    }

    //  @dev _baseURI overrides the Openzeppelin's ERC721 implementation which by default
    // * returned an empty string for the baseURI

    function _baseURI() internal view virtual override returns (string memory){
        return _baseTokenURI;
    }

     /**
    * @dev tokenURI overrides the Openzeppelin's ERC721 implementation for tokenURI function
    * This function returns the URI from where we can extract the metadata for a given tokenId
    */
   function tokenURI(uint256 tokenId) public view virtual override returns(string memory){
    require(_exists(tokenId), "ERC721Metadata: URI for Nonexistent token");
    
    string memory baseURI = _baseURI();

    // Here it checks if the length of the baseURI is greater than 0, if it is return the baseURI and attach
    // the tokenId and `.json` to it so that it knows the location of the metadata json file for a given
    // tokenId stored on IPFS
    // If baseURI is empty return an empty string

    return bytes(baseURI).length> 0 ?
    string(abi.encodePacked(baseURI,tokenId.toString(), ".json")) : 
    "";
   }

   function setPaused(bool val) public onlyOwner { 
    _paused  = val;
   }

   // withdraw sends all the ether in the contract to the owner of the contract
   function withdraw() public onlyOwner{
    address _owner  = owner();
    uint256 amount  = address(this).balance;
    (bool sent, ) = _owner.call{value: amount}("");
    require(sent, "failed to withdraw!");
   }

   receive() external payable{}
   fallback() external payable{}

}