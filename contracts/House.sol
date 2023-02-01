/**
 *Submitted for verification at polygonscan.com on 2022-10-22
*/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  function getRoundData(uint80 _roundId)
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

interface IERC20Permit {
    /**
     * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
     * given ``owner``'s signed approval.
     *
     * IMPORTANT: The same issues {IERC20-approve} has related to transaction
     * ordering also apply here.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `deadline` must be a timestamp in the future.
     * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
     * over the EIP712-formatted function arguments.
     * - the signature must use ``owner``'s current nonce (see {nonces}).
     *
     * For more information on the signature format, see the
     * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
     * section].
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /**
     * @dev Returns the current nonce for `owner`. This value must be
     * included whenever a signature is generated for {permit}.
     *
     * Every successful call to {permit} increases ``owner``'s nonce by one. This
     * prevents a signature from being used multiple times.
     */
    function nonces(address owner) external view returns (uint256);

    /**
     * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
     */
    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}

library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}

library SafeERC20 {
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
        }
    }

    function safePermit(
        IERC20Permit token,
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal {
        uint256 nonceBefore = token.nonces(owner);
        token.permit(owner, spender, value, deadline, v, r, s);
        uint256 nonceAfter = token.nonces(owner);
        require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            // Return data is optional
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}

interface IHouse {
    function placeBet(address player, uint amount, address token, uint winnableAmount) payable external;
    function settleBet(address player, address token, uint playedAmount, uint winnableAmount, bool win) external;
    function refundBet(address player, address token, uint amount, uint winnableAmount) external;
}

contract PriceInfo is Ownable {
    struct PriceFeedInfo {
        AggregatorV3Interface priceFeed;
        int latestUSDPrice;
        uint lastPriceFeedRequest;
        uint decimals;
    }

    mapping(address => PriceFeedInfo) public supportedPriceFeed;

    // Game methods
    function addPriceFeedToken(address token, address aggregatorV3Interface, uint tokenDecimals) external onlyOwner {
        supportedPriceFeed[token] = PriceFeedInfo({
            priceFeed: AggregatorV3Interface(aggregatorV3Interface),
            latestUSDPrice: 0,
            lastPriceFeedRequest: 0,
            decimals: tokenDecimals
        });
    }

    function removePriceFeedToken(address token) external onlyOwner {
        delete supportedPriceFeed[token];
    }

    function updateUSDTokenPrice(PriceFeedInfo storage priceFeedInfo) internal {
        if (block.timestamp - priceFeedInfo.lastPriceFeedRequest >= 900) {
            (
                /*uint80 roundID*/,
                int price,
                /*uint startedAt*/,
                /*uint timeStamp*/,
                /*uint80 answeredInRound*/
            ) = priceFeedInfo.priceFeed.latestRoundData();
            priceFeedInfo.latestUSDPrice = price;
            priceFeedInfo.lastPriceFeedRequest = block.timestamp;
        }
    }

    function tokenAmountToMaticConverter(address token, int amount) public returns(int) {
        if (token == address(0)) {
            return amount;
        }

        PriceFeedInfo storage priceFeedInfo = supportedPriceFeed[token];
        if (address(priceFeedInfo.priceFeed) == address(0)) {
            // this token doesn't support conversion
            return 0;
        }
        
        updateUSDTokenPrice(priceFeedInfo);

        PriceFeedInfo storage maticTokenInfo = supportedPriceFeed[address(0)];
        updateUSDTokenPrice(maticTokenInfo);

        return ((amount * priceFeedInfo.latestUSDPrice) / maticTokenInfo.latestUSDPrice) * int(10 ** uint(maticTokenInfo.decimals - priceFeedInfo.decimals));
    }
}

contract House is ReentrancyGuard, IHouse, PriceInfo {
    using SafeERC20 for IERC20;

    bool public houseLive = true;
    uint public lockedInRewards;
    uint128 public nftHoldersProfitBP = 6000;
    uint128 public polyflipRewardsMaticRatio = 5;
    address public polyflipAddress = 0x6Fdba1A4f28D7077Cfd3080f70C13020BC5B5865;

    mapping(address => bool) private addressAdmin;
    mapping(address => uint) public playerBalance;

    struct TokenInfo {
        uint maxProfitRatio;
        uint lockedInBets;
        int profit;
    }

    address[] public addressSupportedTokens;
    mapping(address => TokenInfo) public supportedToken;

    // Events
    event Donation(address indexed player, uint amount);
    event BalanceClaimed(address indexed player, uint amount);
    event RewardsDistributed(uint nPlayers, uint amount);

    fallback() external payable { emit Donation(msg.sender, msg.value); }
    receive() external payable { emit Donation(msg.sender, msg.value); }

    modifier admin {
        require(addressAdmin[msg.sender] == true, "You are not an admin");
        _;
    }

    modifier isHouseLive {
        require(houseLive == true, "House not live");
        _;
    }

    // Getter
    function balance(address token) public view returns (uint) {
        if (token == address(0)) {
            return address(this).balance;
        }
        return IERC20(token).balanceOf(address(this));
    }

    function polyflipBalance() public view returns (uint) {
        return IERC20(polyflipAddress).balanceOf(address(this));
    }

    function balanceAvailableForBet(address token) public view returns (uint) {
        return balance(token) - supportedToken[token].lockedInBets - (token == address(0) ? lockedInRewards : 0);
    }

    // max profit per token, ratio custom per token
    function maxProfit(address token) public view returns (uint) {
        uint ratio = supportedToken[token].maxProfitRatio;
        require(ratio > 0, "Token not supported");
        return balanceAvailableForBet(token) / ratio;
    }

    // Setter
    function toggleHouseLive() external onlyOwner {
        houseLive = !houseLive;
    }

    function setPolyflipRewardsMaticRatio(uint128 _polyflipRewardsMaticRatio) external onlyOwner {
        polyflipRewardsMaticRatio = _polyflipRewardsMaticRatio;
    }

    function setNftHoldersProfitBP(uint128 _nftHoldersProfitBP) external onlyOwner {
        nftHoldersProfitBP = _nftHoldersProfitBP;
    }

    function setMaxProfitRatio(address token, uint ratio) external onlyOwner {
        require(supportedToken[token].maxProfitRatio != 0, "Token not supported");
        require(ratio != 0, "Ratio cannot be 0");
        supportedToken[token].maxProfitRatio = ratio;
    }

    function setPolyflipAddress(address _polyflipAddress) external onlyOwner {
        polyflipAddress = _polyflipAddress;
    }

    // Methods
    function addAdmin(address _address) external onlyOwner {
        addressAdmin[_address] = true;
    }

    function removeAdmin(address _address) external onlyOwner {
        addressAdmin[_address] = false;
    }

    // Game methods
    function addSupportedToken(address token, uint128 ratio) external onlyOwner {
        require(ratio != 0, "Ratio cannot be 0");
        supportedToken[token] = TokenInfo({
            maxProfitRatio: ratio,
            profit: 0,
            lockedInBets: 0
        });

        for (uint i = 0; i < addressSupportedTokens.length; i++) {
            if (addressSupportedTokens[i] == token) {
                return;
            }
        }
        addressSupportedTokens.push(token);
    }

    function removeSupportedToken(address token) external onlyOwner {
        delete supportedToken[token];
        for (uint i = 0; i < addressSupportedTokens.length; i++) {
            if (addressSupportedTokens[i] == token) {
                addressSupportedTokens[i] = addressSupportedTokens[addressSupportedTokens.length - 1];
                addressSupportedTokens.pop();
                return;
            }
        }
    }

    function getPolyflipRewards(address token, uint amount) public returns (uint) {
        return uint(tokenAmountToMaticConverter(token, int(amount))) * polyflipRewardsMaticRatio;
    }

    function placeBet(address player, uint amount, address token, uint winnableAmount) payable external isHouseLive admin nonReentrant {
        require(winnableAmount <= maxProfit(token), "MaxProfit violation");
        uint polyflipRewards = getPolyflipRewards(token, amount);
        require(polyflipRewards <= polyflipBalance(), "Not enough polyflip tokens");
        if (token == address(0)) {
            require(amount == msg.value, "Not right amount sent");
        }
        else {
            IERC20(token).safeTransferFrom(player, address(this), amount);
        }
        
        supportedToken[token].lockedInBets += winnableAmount;
        if (polyflipRewards > 0) {
            IERC20(polyflipAddress).safeTransfer(player, polyflipRewards);
        }
    }

    function settleBet(address player, address token, uint playedAmount, uint winnableAmount, bool win) external isHouseLive admin nonReentrant {
        // salvarsi l'attuale profit
        supportedToken[token].lockedInBets -= winnableAmount;
        if (win == true) {
            supportedToken[token].profit -= int(winnableAmount) - int(playedAmount);
            // mandare soldi per token
            sendMoney(player, token, winnableAmount);
        }
        else {
            supportedToken[token].profit += int(playedAmount);
        }
    }

    function sendMoney(address player, address token, uint amount) private {
        if (token == address(0)) {
            payable(player).transfer(amount);
        }
        else {
            IERC20(token).safeTransfer(player, amount);
        }
    }

    // specificare token
    function payPlayer(address player, address token, uint amount) external isHouseLive admin nonReentrant {
        require(amount <= maxProfit(token), "MaxProfit violation");
        sendMoney(player, token, amount);
    }

    function sendPolyflipTokens(address player, uint amount) external isHouseLive admin nonReentrant {
        require(amount <= polyflipBalance(), "Not enough polyflip tokens");
        IERC20(polyflipAddress).safeTransfer(player, amount);
    }

    function refundBet(address player, address token, uint amount, uint winnableAmount) external isHouseLive admin nonReentrant {
        supportedToken[token].lockedInBets -= winnableAmount;
        sendMoney(player, token, amount);
    }

    function addPlayerRewards(address player, uint amount) external onlyOwner {
        require(amount <= balanceAvailableForBet(address(0)), "Amount exceeds limit");
        playerBalance[player] += amount;
        lockedInRewards += amount;
    }

    function claimBalance() external isHouseLive nonReentrant {
        uint gBalance = playerBalance[msg.sender];
        require(gBalance > 0, "No funds to claim");
        payable(msg.sender).transfer(gBalance);
        playerBalance[msg.sender] = 0;
        lockedInRewards -= gBalance;
        emit BalanceClaimed(msg.sender, gBalance);
    }

    function distributeNftHoldersRewards(address[] memory addresses) external onlyOwner {
        uint nHolders = addresses.length;
        int nftHoldersRewardsToDistribute;
        for (uint i = 0; i < addressSupportedTokens.length; i++) {
            address token = addressSupportedTokens[i];
            int profit = supportedToken[token].profit;
            if (token != address(0)) {
                profit = tokenAmountToMaticConverter(token, profit);
            }
            nftHoldersRewardsToDistribute += profit;
            supportedToken[token].profit = 0;
        }

        if (nftHoldersRewardsToDistribute <= 0) {
            emit RewardsDistributed(nHolders, 0);
            return;
        }

        uint actualRewardsToDistribute = (uint(nftHoldersRewardsToDistribute) * nftHoldersProfitBP / 10000);
        uint singleReward = actualRewardsToDistribute / nHolders;
        for (uint i = 0; i < nHolders; i++) {
            playerBalance[addresses[i]] += singleReward;
        }
        
        lockedInRewards += actualRewardsToDistribute;
        emit RewardsDistributed(nHolders, actualRewardsToDistribute);
    }

    function withdrawFunds(address payable beneficiary, uint withdrawAmount) external onlyOwner {
        require(withdrawAmount <= address(this).balance, "Withdrawal exceeds limit");
        beneficiary.transfer(withdrawAmount);
    }

    function withdrawPolyflipFunds(address beneficiary, uint withdrawAmount) external onlyOwner {
        require(withdrawAmount <= polyflipBalance(), "Polyflip token withdrawal exceeds limit");
        IERC20(polyflipAddress).safeTransfer(beneficiary, withdrawAmount);
    }

    function withdrawCustomTokenFunds(address beneficiary, uint withdrawAmount, address token) external onlyOwner {
        require(withdrawAmount <= IERC20(token).balanceOf(address(this)), "Withdrawal exceeds limit");
        IERC20(token).safeTransfer(beneficiary, withdrawAmount);
    }
}