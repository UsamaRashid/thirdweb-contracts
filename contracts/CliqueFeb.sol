/**
 * @author [author]
 * @email [example@mail.com]
 * @create date 2023-02-08 03:12:19
 * @modify date 2023-02-08 03:12:19
 * @desc [description]
 */

/* -------------------------------------------------------------------------- */
/*                                    Steps                                   */
/* -------------------------------------------------------------------------- */
/*                1. client creates Listing with chipIn allowed               */
/* -------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------- */
/*                    2. User come & Start Chip in an Asset                   */
/* -------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------- */
/*                    3. ChipIn is completed. & Funds Transfered to Onwer     */
/* -------------------------------------------------------------------------- */

/* -------------------------------------------------------------------------- */

// TODO:My thinking
// User list with chipIn or Direct ChipIn..
// TODO: Cater the Following Conditions
// TODO: 1. if user has Chiped then cannot Update Listings....price?...Intializer updates new Price...
// TODO: If Time has Passed then User can Also Bidd.....multiSig thing
// TODO: refund Terms Define ....

// -> Chip Created...
// Relist Pay that why share of initiator is ....

// list & unlist // listing ID changed from
// validateOwnershipAndApproval check this function
// when Onwer Removes His Order from ChipIn who pays the Gas ???

// Many people Bought Together....
// After that

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@thirdweb-dev/contracts/marketplace/Marketplace.sol";

// TODO: FOR EVERY DEPLOYMENT
// 1. Change address in  Marketplace constructor
contract ChipInMarketPlace is Marketplace {
    constructor(
        string memory _name,
        string memory _symbol,
        address _royaltyRecipient,
        uint128 _royaltyBps
    ) Marketplace(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2) {}

    function contractURI() external view override returns (string memory) {}

    enum CHIPINSTATUS {
        CHIPIN_PROGRESS,
        CHIPIN_RELISTED,
        CHIPIN_COMPLETE
    }

    enum CHIPIN_WITHDRAW_STATUS {
        MATURED,
        WITHDRAWN_AVAILABLE,
        SOLD
    }

    struct ChipIn {
        // NFT statuss
        CHIPINSTATUS currentStatus;
        // mapping For claiming
        uint256 priceToAcheive;
        uint256 amountRaised;
        // Lock Duration & Price
        uint256 lockedPrice;
        // Resell Price Set by Initiator
        uint256 lockDuration;
        uint256 ResellPrice;
        // Paricipants Details
        address[] participants;
        // Prticipant -> AmountContributed
        mapping(address => ShareDeatil) ShareDeatils;
    }

    struct ShareDeatil {
        uint256 AmountContributed;
        CHIPIN_WITHDRAW_STATUS currentWithDrawStatus;
    }
    // listing Id -> CHipIn Deatils
    mapping(uint256 => ChipIn) ChipInDetails;
    mapping(uint256 => bool) chipInAllowed;

    // todo:     // / Can be combined into one code to save Gass
    // CATER: Mutliple ChipIns Can be Created ..... otherwise NFT STUCK
    /// @dev Only lister role holders can create listings, when listings are restricted by lister address.
    bytes32 private constant LISTER_ROLE = keccak256("LISTER_ROLE");
    /// @dev Only assets from NFT contracts with asset role can be listed, when listings are restricted by asset address.
    bytes32 private constant ASSET_ROLE = keccak256("ASSET_ROLE");

    // TODO: // checks for if Chip is already created or not?
    // TODO: // checks for if ERC TOKENS are already listed?

    //25200 seconds = 1week
    uint256 public minChipEndTime = 25200;

    function setminChipEndTime(
        uint256 _minChipEndTime
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        minChipEndTime = _minChipEndTime;
    }

    function updateListing(
        uint256 _listingId,
        uint256 _quantityToList,
        uint256 _reservePricePerToken,
        uint256 _buyoutPricePerToken,
        address _currencyToAccept,
        uint256 _startTime,
        uint256 _secondsUntilEndTime
    ) external override {
        require(
            chipInAllowed[_listingId] == false,
            "Listing with ChipIn functionality are not Allowed to be edited."
        );
        super.updateListing(
            _listingId,
            _quantityToList,
            _reservePricePerToken,
            _buyoutPricePerToken,
            _currencyToAccept,
            _startTime,
            _secondsUntilEndTime
        );
    }

    function createListingWithChipIn(
        ListingParameters memory _params
    ) external {
        // Can only List Item for ChipIn with
        require(
            _params.listingType == ListingType.Direct,
            "CHIP_IN_ONLY_DIRECT_LISTING"
        );
        // Require EndTime to be altease be a 1 week //25200 seconds = 1week
        require(
            (_params.secondsUntilEndTime - block.timestamp) > minChipEndTime,
            "<CHIPIN_END_TIME"
        );
        // Get values to populate `Listing`.
        uint256 listingId = totalListings;
        totalListings += 1;

        address tokenOwner = _msgSender();
        TokenType tokenTypeOfListing = getTokenType(_params.assetContract);
        uint256 tokenAmountToList = getSafeQuantity(
            tokenTypeOfListing,
            _params.quantityToList
        );

        require(tokenAmountToList > 0, "QUANTITY");
        require(
            hasRole(LISTER_ROLE, address(0)) ||
                hasRole(LISTER_ROLE, _msgSender()),
            "!LISTER"
        );
        require(
            hasRole(ASSET_ROLE, address(0)) ||
                hasRole(ASSET_ROLE, _params.assetContract),
            "!ASSET"
        );

        uint256 startTime = _params.startTime;
        if (startTime < block.timestamp) {
            // do not allow listing to start in the past (1 hour buffer)
            require(block.timestamp - startTime < 1 hours, "ST");
            startTime = block.timestamp;
        }

        validateOwnershipAndApproval(
            tokenOwner,
            _params.assetContract,
            _params.tokenId,
            tokenAmountToList,
            tokenTypeOfListing
        );

        Listing memory newListing = Listing({
            listingId: listingId,
            tokenOwner: tokenOwner,
            assetContract: _params.assetContract,
            tokenId: _params.tokenId,
            startTime: startTime,
            endTime: startTime + _params.secondsUntilEndTime,
            quantity: tokenAmountToList,
            currency: _params.currencyToAccept,
            reservePricePerToken: _params.reservePricePerToken,
            buyoutPricePerToken: _params.buyoutPricePerToken,
            tokenType: tokenTypeOfListing,
            listingType: _params.listingType
        });

        listings[listingId] = newListing;

        // Tokens listed for sale in an auction are escrowed in Marketplace.
        // if (newListing.listingType == ListingType.Auction) {
        // }
        require(
            newListing.buyoutPricePerToken == newListing.reservePricePerToken,
            "RESERVE"
        );
        //TODO:
        // LOGIC OF RELISTIN HERE
        transferListingTokens(
            tokenOwner,
            address(this),
            tokenAmountToList,
            newListing
        );

        emit ListingAdded(
            listingId,
            _params.assetContract,
            tokenOwner,
            newListing
        );
    }

    function IntializeChipIn(
        uint256 _listingId,
        uint256 _quantityWanted,
        address _currency,
        uint256 _pricePerToken,
        uint256 _expirationTimestamp,
        uint256 _resellAmountToList
    ) external payable {
        require(
            ChipInDetails[_listingId].participants.length == 0,
            "ChipIn already Initialized"
        );

        Listing memory targetListing = listings[_listingId];

        require(
            targetListing.endTime > block.timestamp &&
                targetListing.startTime < block.timestamp,
            "inactive listing."
        );

        // Both - (1) offers to direct listings, and (2) bids to auctions - share the same structure.
        Offer memory newOffer = Offer({
            listingId: _listingId,
            offeror: _msgSender(),
            quantityWanted: _quantityWanted,
            currency: _currency,
            pricePerToken: _pricePerToken,
            expirationTimestamp: _expirationTimestamp
        });

        require(
            targetListing.listingType == ListingType.Direct,
            "Cannot chipIn in Auction Based Listing"
        );
        if (targetListing.listingType == ListingType.Auction) {
            // A bid to an auction must be made in the auction's desired currency.
            require(
                newOffer.currency == targetListing.currency,
                "must use approved currency to bid"
            );

            // A bid must be made for all auction items.
            newOffer.quantityWanted = getSafeQuantity(
                targetListing.tokenType,
                targetListing.quantity
            );

            handleBid(targetListing, newOffer);
        }
        if (targetListing.listingType == ListingType.Direct) {
            // Prevent potentially lost/locked native token.
            require(msg.value == 0, "no value needed");

            // Offers to direct listings cannot be made directly in native tokens.
            newOffer.currency = _currency == CurrencyTransferLib.NATIVE_TOKEN
                ? nativeTokenWrapper
                : _currency;
            newOffer.quantityWanted = getSafeQuantity(
                targetListing.tokenType,
                _quantityWanted
            );

            handleOffer(targetListing, newOffer);
        }
    }

    function offer(
        uint256 _listingId,
        uint256 _quantityWanted,
        address _currency,
        uint256 _pricePerToken,
        uint256 _expirationTimestamp
    ) external payable override nonReentrant onlyExistingListing(_listingId) {
        // Listing memory targetListing = listings[_listingId];
        // require(
        //     targetListing.endTime > block.timestamp &&
        //         targetListing.startTime < block.timestamp,
        //     "inactive listing."
        // );
        // // Both - (1) offers to direct listings, and (2) bids to auctions - share the same structure.
        // Offer memory newOffer = Offer({
        //     listingId: _listingId,
        //     offeror: _msgSender(),
        //     quantityWanted: _quantityWanted,
        //     currency: _currency,
        //     pricePerToken: _pricePerToken,
        //     expirationTimestamp: _expirationTimestamp
        // });
        // if (targetListing.listingType == ListingType.Auction) {
        //     // A bid to an auction must be made in the auction's desired currency.
        //     require(
        //         newOffer.currency == targetListing.currency,
        //         "must use approved currency to bid"
        //     );
        //     // A bid must be made for all auction items.
        //     newOffer.quantityWanted = getSafeQuantity(
        //         targetListing.tokenType,
        //         targetListing.quantity
        //     );
        //     handleBid(targetListing, newOffer);
        // } else if (targetListing.listingType == ListingType.Direct) {
        //     // Prevent potentially lost/locked native token.
        //     require(msg.value == 0, "no value needed");
        //     // Offers to direct listings cannot be made directly in native tokens.
        //     newOffer.currency = _currency == CurrencyTransferLib.NATIVE_TOKEN
        //         ? nativeTokenWrapper
        //         : _currency;
        //     newOffer.quantityWanted = getSafeQuantity(
        //         targetListing.tokenType,
        //         _quantityWanted
        //     );
        //     handleOffer(targetListing, newOffer);
        // }
    }

    /// @dev Processes a new offer to a direct listing.
    function handleOffer(
        Listing memory _targetListing,
        Offer memory _newOffer
    ) internal override {
        require(
            _newOffer.quantityWanted <= _targetListing.quantity &&
                _targetListing.quantity > 0,
            "insufficient tokens in listing."
        );

        validateERC20BalAndAllowance(
            _newOffer.offeror,
            _newOffer.currency,
            _newOffer.pricePerToken * _newOffer.quantityWanted
        );

        offers[_targetListing.listingId][_newOffer.offeror] = _newOffer;

        emit NewOffer(
            _targetListing.listingId,
            _newOffer.offeror,
            _targetListing.listingType,
            _newOffer.quantityWanted,
            _newOffer.pricePerToken * _newOffer.quantityWanted,
            _newOffer.currency
        );
    }
}
// TODO:
// withdraw from ChipIns
