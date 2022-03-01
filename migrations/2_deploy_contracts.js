const ItemManager = artifacts.require("./ItemManager.sol");
const Item = artifacts.require("./Item.sol");

module.exports = function (deployer) {

  // Deploy Item Manager contract
  await deployer.deploy(ItemManager);
  const itemManager = await ItemManager.deployed()
};
