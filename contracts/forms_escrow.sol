// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract FormsEscrow{

    struct Escrow {
        string formId;
        uint256 budget;
        uint256 cost_per_response;
        uint256 funds_to_distribute;
        uint32 start_date;
        uint32 end_date;
        string name;
        address creator;
    }

    address payable public owner;
    mapping(address => Escrow) public EscrowList;


     constructor() {
        owner = payable(msg.sender);
    }

    modifier checkOwner() {
        require(msg.sender == owner, "Not eligible");
        _;
    }

    modifier checkHasFunds(uint256 currentBudget, uint256 cpr) {
        require(currentBudget >= cpr, "Not enough funds");
        _;
    }

    function CreateEscrow(
        string calldata _name,
        string calldata _formId,
        uint256 cpr,
        uint256 funds_to_distribute,
        uint32 endDate,
        uint32 startDate,
        address creator,
        address UID
    ) public payable {
            uint budget = msg.value;

            EscrowList[UID]  = Escrow({
                name: _name,
                formId: _formId,
                budget: budget,
                cost_per_response: cpr,
                funds_to_distribute: funds_to_distribute,
                start_date: startDate,
                end_date: endDate,
                creator: creator
            });

    }

    function reward(address _to, address escrowId) 
    public 
    checkOwner 
    checkHasFunds(EscrowList[escrowId].funds_to_distribute, EscrowList[escrowId].cost_per_response) {
        EscrowList[escrowId].funds_to_distribute = EscrowList[escrowId].funds_to_distribute - EscrowList[escrowId].cost_per_response;
        (bool sent, ) = _to.call{value: EscrowList[escrowId].cost_per_response}("");
        require(sent, "Failed to transfer reward");
    }

      function getEscrowById(address escrowId) public view returns (Escrow memory) {
        return EscrowList[escrowId];
    }

    function getContractTotalAmount() public view returns (uint256) {
        uint256 amount = address(this).balance;
        return amount;
    }

}