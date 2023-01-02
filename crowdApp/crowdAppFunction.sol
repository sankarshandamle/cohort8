pragma solidity ^0.8.1;

import "./crowdAppData.sol";

contract crowdApp is crowdAppData {

    // a requstor will invoke the contract
    constructor () {
        
        requester = payable(msg.sender);
        currState = contractState.SETUP;    // state of the contract is initialized to the setup state

    }

    // only the requstor can broadcast the task
    function broadcastTask (string memory task, uint256 _workers, uint256 _choices, uint256 _amount, uint256 _epoch) 
        allowedWorkers(_workers) allowedChoices(_choices) checkCurrState(contractState.SETUP) isRequestor() 
            enoughBudget(_workers, _amount) public payable {
                budget = msg.value;
                noOfWorkers = _workers;
                noOfChoices = _choices;
                amountToBePaid = _amount;
                epochLength = _epoch;
                blockNumber = block.number; // starte the clock!

                emit taskEmit(task);
                currState = contractState.RESPONDING;   // state of the contract is changed to allow the workers to submit their responses
    }

    
    
    // function to allow workers to submit their response
    function submitresponse(uint256 _choice) checkCurrState(contractState.RESPONDING) public {
	    
        responses[msg.sender] = workerResponse(_choice,0);
    	workerCount++;

        // update the response count
        responseCount[_choice]+=1;

        // condition check to move to the next state
        if (workerCount >= noOfWorkers) {

            // get the winning choice
            for (uint256 i=0; i<noOfChoices; i++) {
                if (responseCount[i]>=maxFrequency) {
                    winner = i;
                    maxFrequency = responseCount[i];
                }
            }
            emit winnerDeclaration(winner,maxFrequency);

            currState = contractState.PAYMENTS;  // state of the contract is changed to allow the requstor to submit payments
            blockNumber = block.number;     // restart the clock!
            workerCount = 0;        // re-initialize
        }
        
        // give the requester back its money if the noOfWorkers do not meet the threshold till the deadline
        if (workerCount < noOfWorkers && block.number > blockNumber + epochLength) {
            currState = contractState.DONE;
            requester.transfer(amountToBePaid*noOfWorkers);
            workerCount=0;  // re-initialize
        }
    
    }
    
    // then we pay the workers
    function payWorkers(address _a) checkCurrState(contractState.PAYMENTS) isRequestor() public returns(bool) {

        if (responses[_a].response==winner) {
            payable(_a).transfer(amountToBePaid);   // pay
            budgetConsumed = budgetConsumed + amountToBePaid; // update the budget consumed
        }

        if (blockNumber + epochLength < block.number) {
            currState = contractState.DONE;
            blockNumber = block.number;     // restart the clock for another task!
        }
        return true;
    }
    
    // function to re-initialize all values for a new task
    function reinitValues() checkCurrState(contractState.DONE) isRequestor() public {
        uint256 remValue = budget - budgetConsumed;
        payable(requester).transfer(remValue); // first return the requstor the reamaining budget
        budget = 0;
        winner = 0;
        budgetConsumed = 0;
        maxFrequency = 0;
        workerCount = 0;
        currState = contractState.SETUP;    // changing the state of the contract to the setup phase for re-use
    }
    
} // contract ends
