// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";

import { SenderReceiverAVAX } from "../src/axelar/AxelarAvalanche.sol";
import { SenderReceiverARB } from "../src/axelar/AxelarArbitrum.sol";

contract DeployAxelar is Script {


    function run() public {
        vm.startBroadcast(msg.sender);
        if (block.chainid ==  43113){ //if is Avalanche Testnet
            console2.log("deployin in Avalanche Testnet");
            SenderReceiverAVAX senderReceiverAVAX = new SenderReceiverAVAX();
            console2.log("senderReceiverAVAX address: ", address(senderReceiverAVAX));
        } else if (block.chainid == 421614){ // if is Arbitrum Testnet
            console2.log("deployin in Arbirtrum Testnet");
            SenderReceiverARB senderReceiverARB = new SenderReceiverARB();
            console2.log("senderReceiverARB address: ", address(senderReceiverARB));
        } else {
            console2.log("Error: chain not supported");
            revert();
        }
    }
}