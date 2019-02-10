var CardGame = artifacts.require("./CardGame.sol");

module.exports = function(deployer) {
  deployer.deploy(CardGame);
};
