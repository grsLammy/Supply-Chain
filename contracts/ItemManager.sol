// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "./Ownable.sol";
import "./Item.sol";

contract ItemManager is Ownable {

    struct S_Item {
        Item _item;
        uint _priceInWei;
        string _identifier;
        ItemManager.SupplyChainSteps _state;
        
    }
    mapping(uint => S_Item) public items;
    uint itemIndex;

    enum SupplyChainSteps {Created, Paid, Delivered}

    event SupplyChainStep(uint _itemIndex, uint _step,  address _itemAddress);

    function createItem(string memory _identifier, uint _priceInWei) public onlyOwner {
        Item item = new Item(this, _priceInWei, itemIndex);
        items[itemIndex]._item = item;
        items[itemIndex]._priceInWei = _priceInWei;
        items[itemIndex]._state = SupplyChainSteps.Created;
        items[itemIndex]._identifier = _identifier;
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state), address(item));
        itemIndex++;
    }

    function triggerPayment(uint _itemIndex) public payable {
        Item item = items[_itemIndex]._item;
        require(address(item) == msg.sender,"Only items are allowed to update themselves");
        require(items[_itemIndex]._priceInWei == msg.value,"Only full payments accepted");
        require(items[_itemIndex]._state == SupplyChainSteps.Created,"Item is further in the chain");
        
        
        items[_itemIndex]._state = SupplyChainSteps.Paid;
        emit SupplyChainStep(_itemIndex, uint(items[_itemIndex]._state), address(items[_itemIndex]._item));
    }

    function triggerDelivery(uint _itemIndex) public onlyOwner {
        require(items[_itemIndex]._state == SupplyChainSteps.Paid, "Item is further in the supply chain");
        items[_itemIndex]._state = SupplyChainSteps.Delivered;
        emit SupplyChainStep(_itemIndex, uint(items[_itemIndex]._state), address(items[_itemIndex]._item));
    }
}