// SPDX-License-Identifier: CC-BY-NC-4.0
pragma solidity ^0.8.0;

/**
 *  @title Ejemplo de cross-chain messaging con Axelar
 *  @author jistro.eth
 *  @notice Este contrato es un ejemplo de como enviar y recibir mensajes entre
 *         dos redes distintas usando Axelar.
 *  @dev Este contrato es un ejemplo y no debe ser usado en producción.
 */
import { AxelarExecutable } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol';
import { IAxelarGateway } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol';
import { IAxelarGasService } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol';

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract SenderARB is AxelarExecutable, Ownable {
    
    struct DestinationMetadata {
        string destinationAddress;
        string destinationChain;
    }
    
    DestinationMetadata destinationMetadata;

    IAxelarGasService public immutable gasService;

    constructor(address initialOwner, address gateway_, address gasService_)
        AxelarExecutable(gateway_)
        Ownable(initialOwner)
    {
        gasService = IAxelarGasService(gasService_);
    }

    function _setDestinationMetadata(
        string memory _destinationAddress,
        string memory _destinationChain
    ) external onlyOwner {
        destinationMetadata.destinationAddress = _destinationAddress;
        destinationMetadata.destinationChain = _destinationChain;
    }

    function sendMessage(
        string calldata message_
    ) external payable {
        bytes memory payload = abi.encode(message_);
        gasService.payNativeGasForContractCall{value: msg.value} (
            address(this),
            destinationMetadata.destinationChain,
            destinationMetadata.destinationAddress,
            payload,
            msg.sender
        );
        gateway.callContract(
            destinationMetadata.destinationChain,
            destinationMetadata.destinationAddress,
            payload
        );
    }
}
