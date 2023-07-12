const hre = require("hardhat");

async function main() {

  // url from where we can extract the metadata for a arts punk
  const metaURL = "ipfs://Qme5bYQH7wU5JBfMP3FLx4BLnY2uc7oe6rCqysBdVZS91c";

  // deploy the contract 
  const ArtContract = await hre.ethers.deployContract("ARTS",[
    metaURL
  ]);

  await ArtContract.waitForDeployment();

  // print the addresss of the contract
  console.log("ARTs PUNKS Contract Address:", ArtContract.target);



}


// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
