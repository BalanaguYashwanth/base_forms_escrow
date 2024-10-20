// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract FormsEscrow {

    struct FormItem {
        string uid;
        string formId;
        uint256 budget;
        uint256 cost_per_response;
        uint32 start_date;
        uint32 end_date;
        string name;
    }

    struct FormOwner {
        address ownerAddress;
        FormItem[] forms;
    }

    address payable public platformOwner;
    mapping(address => FormOwner) public formOwners;
    mapping(address => mapping(string => FormItem)) public formItems;

    constructor() {
        platformOwner = payable(msg.sender);
    }

    modifier onlyPlatformOwner() {
        require(msg.sender == platformOwner, "Not eligible");
        _;
    }

    modifier checkBudget(uint256 budget, uint256 cpr) {
        require(budget >= cpr, "Not enough budget");
        _;
    }

    function createForm(
        string calldata _name,
        string calldata _formId,
        uint256 cpr,
        uint32 endDate,
        uint32 startDate,
        address ownerAddress,
        string calldata uid
    ) public payable {
        uint256 budget = msg.value;

        // Add the form to the owner's array of forms
        formOwners[ownerAddress].ownerAddress = ownerAddress;
        formOwners[ownerAddress].forms.push(FormItem({
            uid: uid,
            name: _name,
            formId: _formId,
            budget: budget,
            cost_per_response: cpr,
            start_date: startDate,
            end_date: endDate
        }));

        // Also store the form in the formItems mapping for easy lookup
        formItems[ownerAddress][_formId] = FormItem({
            uid: uid,
            name: _name,
            formId: _formId,
            budget: budget,
            cost_per_response: cpr,
            start_date: startDate,
            end_date: endDate
        });
    }

    function reward(
        address _to,
        address ownerAddress,
        string calldata formId
    ) public onlyPlatformOwner checkBudget(
        formItems[ownerAddress][formId].budget,
        formItems[ownerAddress][formId].cost_per_response
    ) {
        (bool sent, ) = _to.call{value: formItems[ownerAddress][formId].cost_per_response}("");
        require(sent, "Failed to transfer reward");

        formItems[ownerAddress][formId].budget -= formItems[ownerAddress][formId].cost_per_response;
    }

    function getFormsByOwner(address ownerAddress) public view returns (FormItem[] memory) {
        return formOwners[ownerAddress].forms;
    }
}
