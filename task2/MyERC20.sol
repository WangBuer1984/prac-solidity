// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

// 导入 OpenZeppelin 的 IERC20 接口
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SimpleERC20 is IERC20 {
    // 代币基本信息
    string public name;
    string public symbol;
    uint8 public decimals;
    
    // 总供应量
    uint256 private _totalSupply;
    
    // 余额映射
    mapping(address => uint256) private _balances;
    
    // 授权映射 (owner => (spender => amount))
    mapping(address => mapping(address => uint256)) private _allowances;
    
    // 合约所有者
    address public owner;
    
    // 事件定义
    // event Transfer(address indexed from, address indexed to, uint256 value)  ;
    // event Approval(address indexed owner, address indexed spender, uint256 value) ;
    
    // 构造函数
    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 initialSupply) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        owner = msg.sender;
        
        // 初始铸造代币给合约部署者
        _mint(msg.sender, initialSupply);
    }
    
    // 查询总供应量
    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }
    
    // 查询账户余额
    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }
    
    // 转账功能
    function transfer(address to, uint256 value) external returns (bool) {
        require(to != address(0), "ERC20: transfer to the zero address");
        require(_balances[msg.sender] >= value, "ERC20: insufficient balance");
        
        _balances[msg.sender] -= value;
        _balances[to] += value;
        
        emit Transfer(msg.sender, to, value);
        return true;
    }
    
    // 授权功能
    function approve(address spender, uint256 value) external returns (bool) {
        _allowances[msg.sender][spender] = value;
        
        emit Approval(msg.sender, spender, value);
        return true;
    }
    
    // 查询授权额度
    function allowance(address _owner, address spender) external view returns (uint256) {
        return _allowances[_owner][spender];
    }
    
    // 代扣转账功能
    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(_balances[from] >= value, "ERC20: insufficient balance");
        require(_allowances[from][msg.sender] >= value, "ERC20: insufficient allowance");
        
        _balances[from] -= value;
        _balances[to] += value;
        _allowances[from][msg.sender] -= value;
        
        emit Transfer(from, to, value);
        return true;
    }
    
    // 增发代币功能（仅限合约所有者）
    function mint(address to, uint256 value) external {
        require(msg.sender == owner, "ERC20: only owner can mint");
        _mint(to, value);
    }
    
    // 内部铸造函数
    function _mint(address to, uint256 value) internal {
        require(to != address(0), "ERC20: mint to the zero address");
        
        _totalSupply += value;
        _balances[to] += value;
        
        emit Transfer(address(0), to, value);
    }
    

}