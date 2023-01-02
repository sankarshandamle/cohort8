pragma solidity ^0.8.1;

contract crowdAppData {

    
    // structures which holds each worker's submission
    struct workerResponse {
       uint256 response;
       uint256 amountToBePaid;
    }

   // create a mapping between workers to their responses
   mapping(address => workerResponse) responses;

     

    // other variables

    address payable requester;   // address of the requester
    uint256 workerCount = 0;    // counter for the number of workers
    uint256[10] responseCount; // count array that keeps count of the number of times a response has been submitted
    uint256 budget; // amount sent by the requstor
    uint256 maxFrequency = 0;   // variable to decide the maximum responded response
    uint256 winner; // variable that holds the final winning response
    uint256 noOfWorkers = 0;    // variable that states how many workers are required
    uint256 noOfChoices = 0;    // variable that states the number of choices available for a task
    uint256 budgetConsumed = 0;     // interger to keep a tab on the budget used
    uint256 amountToBePaid = 0;
    uint256 epochLength = 0;    // integer that specifies how much time each state to last
    uint256 blockNumber = 0;    // integer that storest the previous state blockNumber

    
    // defining contract state
    enum contractState {SETUP, RESPONDING, PAYMENTS, DONE}     // enums to handle the contract state
    contractState currState;

    // events
    event taskEmit (string task);
    event winnerDeclaration (uint256 winner, uint256 maxFrequency);


    // modifiers

    modifier isRequestor() {
        require(msg.sender == requester, "access only to the requstor");
        _;
    }

    modifier enoughBudget(uint256 _noOfWorkers, uint256 _amountToPay) {
        require(msg.value >= _noOfWorkers*_amountToPay, "insufficient money deposited");
        _;
    }

    modifier checkCurrState(contractState state) {
        require(currState == state, "function not available at this state");
        _;
    }

    modifier allowedChoices(uint256 x) {
        require(x < 10, "more than 10 choices not allowed");
        _;
    }

    modifier allowedWorkers(uint256 y) {
        require(y < 100, "more than 100 workers not allowed");
        _;
    }
    
} // contract ends
