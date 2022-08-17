//SPDX-License-Identifier: Unlicense

// contracts/BuyMeACoffee.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

// Switch this to your own contract address once deployed, for bookkeeping!
// Example Contract Address on Goerli: 0x77701a42289bcf1834D217ffaA28CFD909b599c8

contract BuyMeACoffee is Ownable {
    uint256 public constant priceLargeCoffee = 0.003 ether;
    string public constant regularCoffee = "Regular Coffee";
    string public constant largeCoffee = "Large Coffee";

    // Event to emit when a Memo is created.
    event NewMemo(
        address indexed from,
        uint256 timestamp,
        string name,
        string message,
        string coffeesize
    );

    event WithdrawAddressTransferred(
        address indexed previousWithdrawAddress,
        address indexed newWithdrawAddress
    );

    address payable withdrawAddress;
    address payable _owner;

    // Memo struct.
    struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
        string coffeesize;
    }

    // Address of contract deployer. Marked payable so that
    // we can withdraw to this address later.

    // List of all memos received from coffee purchases.
    Memo[] memos;

    constructor() {
        // Store the address of the deployer as a payable address.
        // When we withdraw funds, we'll withdraw here.
        _owner = payable(msg.sender);
        withdrawAddress = payable(msg.sender);
    }

    modifier onlyWithdrawer() {
        require(msg.sender == withdrawAddress);
        _;
    }

    /**
     * @dev fetches all stored memos
     */
    function getMemos() public view returns (Memo[] memory) {
        return memos;
    }

    /**
     * @dev buy a coffee for owner (sends an ETH tip and leaves a memo)
     * @param _name name of the coffee purchaser
     * @param _message a nice message from the purchaser
     */
    function buyCoffee(string memory _name, string memory _message)
        public
        payable
    {
        // Must accept more than 0 ETH for a coffee.
        require(msg.value > 0, "can't buy coffee for free!");
        string memory _coffeesize = regularCoffee;

        // Add the memo to storage!
        memos.push(
            Memo(msg.sender, block.timestamp, _name, _message, _coffeesize)
        );

        // Emit a NewMemo event with details about the memo.
        emit NewMemo(msg.sender, block.timestamp, _name, _message, _coffeesize);
    }

    function buyLargeCoffee(string memory _name, string memory _message)
        public
        payable
    {
        // Must accept more than 0.003 ETH for a Largecoffee.
        require(
            msg.value >= priceLargeCoffee,
            "can't buy a large coffee for less than 0.003 ether!"
        );

        // set size of coffee
        string memory _coffeesize = largeCoffee;

        // Add the memo to storage!
        memos.push(
            Memo(msg.sender, block.timestamp, _name, _message, _coffeesize)
        );

        // Emit a NewMemo event with details about the memo.
        emit NewMemo(msg.sender, block.timestamp, _name, _message, _coffeesize);
    }

    function withdrawTipsToOwner() public onlyOwner {
        require(_owner.send(address(this).balance));
    }

    function withdrawTipsToSetWithdrawAddress() public onlyOwner {
        require(withdrawAddress.send(address(this).balance));
    }

    function withdrawTipsToOther(address payable _to, uint256 _amount)
        public
        onlyOwner
    {
        _to.transfer(_amount);
    }

    function _changeWithdrawAddress(address payable newWithdrawAddress)
        public
        onlyOwner
    {
        address oldWithdrawAddress = withdrawAddress;
        withdrawAddress = newWithdrawAddress;
        emit OwnershipTransferred(oldWithdrawAddress, newWithdrawAddress);
    }

    function getWithdrawAddress() public view virtual returns (address) {
        return withdrawAddress;
    }
}
/*


    function setWithdrawAddress(address payable newWithdrawAddress)
        public
        onlyOwner
    {
        withdrawAddress = newWithdrawAddress;
    } */
/**
 * @dev send the entire balance stored in this contract to the owner
 */
// This code, should not be limited to ownner.
// This code, should be set to owner, only owner can set new.
// Maybe use inspiration of setter and getter methods.
/*function withdrawTips() public {
        require(owner.send(address(this).balance));
    }*/

/*

    function withdrawTips() external onlyWithdrawer {
        _withdraw();
    }

    function setWithdrawAddress(address newWithdrawAddress) public onlyOwner {
        _withdrawAddress = newWithdrawAddress;
    }

    function _withdraw() public onlyOwner {
        payable(_withdrawAddress).transfer(address(this).balance);
    }

    function getWithdrawAdress() public view returns (string memory) {
        return _withdrawAddress;
    }
}

*/
/*
    function withdrawTips() public _ownerOnly {
        require(withdrawAddress.send(address(this).balance));
        _withdraw();
    }
    


    function setWithdrawAdress(address _withdrawAddress)
        public
        payable
        _ownerOnly
    {
        withdrawAddress = _withdrawAddress;
    }
}

*/
/*


    
// Implementing a function to set the withdraw address.
    // Must only be set by the owner of the contract.
    

    // Add this to constructor
    address withdrawAddress = owner;



}
*/
