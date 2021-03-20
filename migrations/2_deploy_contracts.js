var DANOU = artifacts.require("DANOU");
var Fight = artifacts.require("Fight");

module.exports = function(deployer) {
deployer.deploy(DANOU);
deployer.deploy(Fight);
};

