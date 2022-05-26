// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Lottery {
    address public manager;
    address payable[] public players;

    constructor() {
        manager = msg.sender;
    }

    function enter() public payable {
        require(
            msg.value > .01 ether,
            "A minimum payment of .01 ether must be sent to enter the lottery"
        );

        players.push(payable(msg.sender));
    }

    function random() private view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(block.difficulty, block.number, players)
                )
            );
    }

    function pickWinner() public onlyOwner {
        uint256 index = random() % players.length;

        address contractAddress = address(this);

        players[index].transfer(contractAddress.balance);

        players = new address payable[](0);
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    modifier onlyOwner() {
        require(
            msg.sender == manager,
            "Only the lottery owner can call this function."
        );
        _;
    }
}