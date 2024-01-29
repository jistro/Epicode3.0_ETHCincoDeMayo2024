-include .env

.PHONY: all

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

help:
	@echo ""
	@echo "--------------------------------|Cross Chain Solutions|--------------------------------"
	@echo ""
	@echo "----------------------------------------=Usage=----------------------------------------"
	@echo "  make install    Instala las dependencias necesarias para el proyecto"
	@echo "  make format     format code"
	@echo "  make anvil      run anvil"
	@echo "  make compile    compile contracts"
	@echo "---------------------------------------------------------------------------------------"
	@echo ""
	@echo "---------------------------------------=Deployers=-------------------------------------"
	@echo " make deployAxelar    Lanza los contratos para las testnets de AVAX y ARB usando axelar"
	@echo "---------------------------------------------------------------------------------------"


	
all: clean remove install update build 

install:
	@echo "█░Instalando dependencias░██████████████████████████████████████████████████████████████"
	@npm install
	@forge compile

format :; forge fmt

anvil :
	@echo "Starting Anvil, remember use another terminal to run tests"
	@anvil -m 'test test test test test test test test test test test junk' --steps-tracing

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

ARB_TESTNET_ARGS := --rpc-url $(RPC_URL_ARB_SEPOLIA) --private-key $(PRIVATE) --broadcast --verify --etherscan-api-key $(API_KEY_ARB) -vvvv
AVAX_TESTNET_ARGS := --rpc-url $(RPC_URL_AVAX_FUJI) --private-key $(PRIVATE) --broadcast --verify --verifier-url 'https://api.routescan.io/v2/network/testnet/evm/43113/etherscan' --etherscan-api-key "verifyContract" -vvvv


AMPLIFY_ARGS := --rpc-url $(RPC_URL_AMPLIFY) --private-key $(PRIVATE) --broadcast 
BULLETIN_ARGS := --rpc-url $(RPC_URL_BULLETIN) --private-key $(PRIVATE) --broadcast
CONDUIT_ARGS := --rpc-url $(RPC_URL_CONDUIT) --private-key $(PRIVATE) --broadcast


compile:
	forge compile

deployAxelar:
	@echo "--|Deployando solucion de Cross-Chain Axelar|------------------------------------------"
	@echo " "
	@echo "|Deployando en testnet AVAX|-----------------------------------------------------------"
	@forge script script/DeployAxelar.s.sol:DeployAxelar $(AVAX_TESTNET_ARGS)
	@echo "---------------------------------------------------------------------------------------"
	@echo " "
	@echo "|Deployando en testnet ARB|------------------------------------------------------------"
	@forge script script/DeployAxelar.s.sol:DeployAxelar $(ARB_TESTNET_ARGS)
	@echo "---------------------------------------------------------------------------------------"