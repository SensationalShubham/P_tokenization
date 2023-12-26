-include .env

deploy:
	forge script script/deployERC721.s.sol --rpc-url $(RPC_URL) --broadcast --private-key $(PRIVATE_KEY)
	