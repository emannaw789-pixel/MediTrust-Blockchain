// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MediTrust {
    address public regulator;

    enum Role { None, Manufacturer, Distributor, Pharmacy }

    struct Batch {
        uint256 batchId;
        string medicineName;
        address currentOwner;
        Role stage;
        bool isRecalled;
        uint256 scanCount;
    }

    mapping(uint256 => Batch) public batches;
    mapping(address => Role) public userRoles;

    event BatchRegistered(uint256 indexed batchId, string medicineName, address indexed manufacturer);
    event CustodyTransferred(uint256 indexed batchId, address indexed from, address indexed to, Role stage);
    event BatchRecalled(uint256 indexed batchId, address indexed regulator);
    event PackageScanned(uint256 indexed batchId, uint256 scanCount, bool isSuspicious);

    modifier onlyRegulator() {
        require(msg.sender == regulator, "Access Denied: Only DRAP Regulator allowed");
        _;
    }

    modifier onlyRole(Role _role) {
        require(userRoles[msg.sender] == _role, "Access Denied: Unauthorized role");
        _;
    }

    constructor() {
        regulator = msg.sender;
    }

    function assignRole(address _user, Role _role) external onlyRegulator {
        userRoles[_user] = _role;
    }

    function registerBatch(uint256 _batchId, string memory _medicineName) external onlyRole(Role.Manufacturer) {
        require(batches[_batchId].batchId == 0, "Batch ID already exists");
        batches[_batchId] = Batch(_batchId, _medicineName, msg.sender, Role.Manufacturer, false, 0);
        emit BatchRegistered(_batchId, _medicineName, msg.sender);
    }

    function transferCustody(uint256 _batchId, address _to, Role _nextStage) external {
        Batch storage b = batches[_batchId];
        require(b.batchId != 0, "Batch does not exist");
        require(b.currentOwner == msg.sender, "Only current owner can transfer custody");
        require(!b.isRecalled, "Transfer Blocked: Batch has been RECALLED!");
        b.currentOwner = _to;
        b.stage = _nextStage;
        emit CustodyTransferred(_batchId, msg.sender, _to, _nextStage);
    }

    function recallBatch(uint256 _batchId) external onlyRegulator {
        require(batches[_batchId].batchId != 0, "Batch does not exist");
        batches[_batchId].isRecalled = true;
        emit BatchRecalled(_batchId, msg.sender);
    }

    function verifyPackage(uint256 _batchId) external returns (
        string memory medicineName, address currentOwner, Role stage, bool isRecalled, uint256 scanCount, string memory alertMessage
    ) {
        Batch storage b = batches[_batchId];
        require(b.batchId != 0, "Error: Unregistered Package Code!");
        b.scanCount += 1;
        bool suspicious = b.scanCount > 1;
        emit PackageScanned(_batchId, b.scanCount, suspicious);
        string memory statusNote = "STATUS OK: Genuine Product";
        if (b.isRecalled) { statusNote = "DANGER: This batch has been RECALLED by DRAP!"; }
        else if (suspicious) { statusNote = "WARNING: Code scanned multiple times! Possible Counterfeit Copy."; }
        return (b.medicineName, b.currentOwner, b.stage, b.isRecalled, b.scanCount, statusNote);
    }
}
