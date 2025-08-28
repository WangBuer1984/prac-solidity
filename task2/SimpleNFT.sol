// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

// 导入 OpenZeppelin ERC721 合约
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// 导入 OpenZeppelin 的访问控制合约
import "@openzeppelin/contracts/access/Ownable.sol";
// 导入 OpenZeppelin 的计数器工具
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyNFT is ERC721, Ownable {
    // 使用计数器来管理 tokenId
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    
    // 存储每个 tokenId 对应的元数据 URI
    mapping(uint256 => string) private _tokenURIs;
    
    // 构造函数：设置 NFT 的名称和符号，并设置初始所有者
    constructor(string memory name, string memory symbol) ERC721(name, symbol) Ownable(msg.sender) {}
    
    // mintNFT 函数：允许用户铸造 NFT，并关联元数据链接
    function mintNFT(address to, string memory tokenURI) public onlyOwner returns (uint256) {
        // 获取当前 tokenId 并递增
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        
        // 铸造 NFT
        _safeMint(to, tokenId);
        
        // 设置 tokenURI
        _setTokenURI(tokenId, tokenURI);
        
        return tokenId;
    }
    
    // 重写 tokenURI 函数以返回存储的 URI
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        // 使用 ownerOf 来检查 token 是否存在，这会抛出错误如果 token 不存在
        ownerOf(tokenId);
        
        return _tokenURIs[tokenId];
    }
    
    // 内部函数：设置 tokenURI
    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal  {
        // 使用 ownerOf 来检查 token 是否存在
        ownerOf(tokenId);
        
        _tokenURIs[tokenId] = _tokenURI;
    }
    
    // 获取当前 tokenId 计数
    function getCurrentTokenId() public view returns (uint256) {
        return _tokenIdCounter.current();
    }
    
    // 检查 token 是否存在（如果需要的话）
    function tokenExists(uint256 tokenId) public view returns (bool) {
        try this.ownerOf(tokenId) returns (address) {
            return true;
        } catch {
            return false;
        }
    }
}