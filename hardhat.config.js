require("@nomicfoundation/hardhat-toolbox");

module.exports = {
    solidity: "0.8.18", // Use a specific version without the caret (^) symbol
    networks: {
        hardhat: {},
        localhost: {
            url: "http://127.0.0.1:8545",
        },
    },
};
