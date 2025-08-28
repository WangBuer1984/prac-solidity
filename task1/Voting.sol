// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
contract Voting{
    mapping (string => uint256) public voteMapping;
    string[] public candidates;

    
    function vote(string memory candidate) public {
        
       if(voteMapping[candidate] == 0){
            candidates.push(candidate);
       }
       voteMapping[candidate] += 1;
    }

    //一个getVotes函数，返回某个候选人的得票数
    //一个resetVotes函数，重置所有候选人的得票数

    function getVotes(string memory candidate) public view returns (uint256) {
        return voteMapping[candidate];
    }

    function resetVotes() public {
        for (uint256 i = 0;i<candidates.length;i++){
            voteMapping[candidates[i]] = 0;
        }
    }
}