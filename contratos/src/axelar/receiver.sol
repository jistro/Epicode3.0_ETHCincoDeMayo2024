// SPDX-License-Identifier: CC-BY-NC-4.0
pragma solidity ^0.8.0;

/**
 *  @title Ejemplo de cross-chain messaging con Axelar
 *  @author jistro.avax
 *  @notice Este contrato es un ejemplo de como enviar y recibir mensajes entre
 *         dos redes distintas usando Axelar.
 *  @dev Este contrato es un ejemplo y no debe ser usado en producción.
 */

import { AxelarExecutable } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol';
import { IAxelarGateway } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol';
import { IAxelarGasService } from '@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol';
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";

contract ReceiverAVAX is AxelarExecutable, Ownable {

    struct SourceMetadata {
        string sourceAddress;
        string sourceChain;
    }
    
    SourceMetadata sourceMetadata;

    IAxelarGasService public immutable gasService;

    string public message;

    constructor(address initialOwner, address gateway_, address gasService_)
        AxelarExecutable(gateway_)
        Ownable(initialOwner)
    {
        gasService = IAxelarGasService(gasService_);
    }

    function _execute(
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload_
    ) internal override {
        if (!Strings.equal(sourceChain, sourceMetadata.sourceChain) && !Strings.equal(sourceAddress, sourceMetadata.sourceAddress)) {
            revert("invalid source chain or address");
        }

        message = abi.decode(payload_, (string));
    }

    function seeMessageReceivedMetadata() external view returns (string memory) {
        return message;
    }
}
