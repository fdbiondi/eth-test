pragma solidity >=0.4.21 <0.7.0;
pragma experimental ABIEncoderV2;

contract MultiSigWallet {
    /**
     * Payable modifier
     * function buy(uint quantity) payable {
     *   // check amount
     *   require(msg.value > 100);
     *   // payment accepted
     * }
     *
     * // user send funds without call a method
     * // called when ether is sent without calling a method
     * function () payable {
     *   require(msg.value > 100);
     * }
     *
     * Check balance account
     *
     * address addr = msg.sender;
     * // Get balance
     * uint accountBalance = addr.balance;
     * // Contract's balance
     * address(this).balance
     *
     * Send payment
     *
     * address addr = ...;
     * // reverts exec if fails
     * addr.transfer(1000); // weis not ether -> recommended!
     *
     * // returns false if fails
     * bool succeeded = add.send(1000);
     * // Should check return value!
     * // unsafe and should be avoided
     *
     */

    uint minApprovers;

    address beneficiary;
    address owner;

    mapping(address => bool) approvedBy;
    mapping(address => bool) isApprover;
    uint approvalsNum;

    constructor(
        // list of approvers that can approve or reject a transaction from the multisigwallet
        address[] _approvers,
        // min number of approvers that should approve a tx to pass through
        uint _minApprovers,
        // account which the contract will pay all the funds if the tx is approved by the min number of approvers
        address _beneficiary
    ) public payable {
        require(
            _minApprovers <= _approvers.length,
            "Required number of approvers should be less than number of approvers"
        );

        minApprovers = _minApprovers;
        beneficiary = _beneficiary;
        owner = msg.sender;

        for (uint i = 0; i < _approvers.length; i++) {
            address approver = _approvers[i];
            isApprover[approver] = true;
        }
    }

    function approve() public {}

    function reject() public {
        require(isApprover[msg.sender], "Not an approver");

        selfdestruct(owner);
    }
}
