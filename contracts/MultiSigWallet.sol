pragma solidity >=0.4.21 <0.7.0;
pragma experimental ABIEncoderV2;

contract MultiSigWallet {
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

    function approve() public {
        require(isApprover[msg.sender], "Not an approver");

        if (!approvedBy[msg.sender]) {
            approvalsNum++;
            approvedBy[msg.sender] = true;
        }

        if (approvalsNum == minApprovers) {
            beneficiary.send(address(this).balance);

            selfdestruct(owner);
        }

    }

    function reject() public {
        require(isApprover[msg.sender], "Not an approver");

        selfdestruct(owner);
    }
}
