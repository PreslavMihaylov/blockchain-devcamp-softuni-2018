var voting = require("./Voting.sol");

module.exports = function(deployer) {
    deployer.deploy(voting);
}
