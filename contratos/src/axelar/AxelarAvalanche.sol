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

contract SenderReceiverAVAX is AxelarExecutable {
    struct MessageReceivedMetadata {
        string sourceChain;
        string sourceAddress;
        string message;
    }

    MessageReceivedMetadata messageReceivedMetadata;

    IAxelarGasService public immutable gasService;
    string public message;
    /**
     *  @notice El constructor de este contrato recibe como parámetro la dirección 
     *          del contrato AxelarGateway y la dirección del contrato 
     *          AxelarGasService para la red Arbirtrum.
     *          
     *          Para ver las direcciones de los contratos en Testnet, visitar:
     *          https://docs.axelar.dev/resources/testnet#evm-contract-addresses
     */
    constructor() AxelarExecutable(0xC249632c2D40b9001FE907806902f63038B737Ab) {
        gasService = IAxelarGasService(0xbE406F0189A0B4cf3A05C286473D23791Dd44Cc6);
    }

    /**
     *  @notice Este método envia un mensaje a la red de destino en este caso Arbitrum.
     *  @param destinationAddress  La dirección del contrato en la red de destino.
     *  @param message_            El mensaje a enviar.
     */
    function sendMessage(
        string calldata destinationAddress,
        string calldata message_
    ) external payable {
        bytes memory payload = abi.encode(message_);
        gasService.payNativeGasForContractCall{value: msg.value} (
            address(this),
            "arbitrum",
            destinationAddress,
            payload,
            msg.sender
        );

        gateway.callContract("arbitrum",destinationAddress,payload);
    }

    /**
     *  @notice Este método es llamado por el contrato AxelarGateway de la red de origen
     *          para ejecutar el payload recibido.
     *  @param sourceChain   La red de origen.
     *  @param sourceAddress La dirección del contrato en la red de origen.
     *  @param payload_      El payload recibido.
     */
    function _execute(
        string calldata sourceChain,
        string calldata sourceAddress,
        bytes calldata payload_
    ) internal override {
        messageReceivedMetadata = MessageReceivedMetadata({
            sourceChain: sourceChain,
            sourceAddress: sourceAddress,
            message: abi.decode(payload_, (string))
        });
    }

    function seeMessageReceivedMetadata() external view returns (MessageReceivedMetadata memory) {
        return messageReceivedMetadata;
    }
}