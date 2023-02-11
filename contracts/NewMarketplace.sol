/**
 * @author [author]
 * @email [example@mail.com]
 * @create date 2023-02-08 03:12:19
 * @modify date 2023-02-08 03:12:19
 * @desc [description]
 */

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@thirdweb-dev/contracts/marketplace/Marketplace.sol";

contract ChipInMarketPlace is Marketplace {
    constructor(
        string memory _name,
        string memory _symbol,
        address _royaltyRecipient,
        uint128 _royaltyBps
    ) Marketplace(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2) {}

    /// @dev Only lister role holders can create listings, when listings are restricted by lister address.
    bytes32 private constant LISTER_ROLE = keccak256("LISTER_ROLE");
    /// @dev Only assets from NFT contracts with asset role can be listed, when listings are restricted by asset address.
    bytes32 private constant ASSET_ROLE = keccak256("ASSET_ROLE");

    // enum NewListingType {
    //     Direct,
    //     Auction,
    //     ChipIn
    // }

    // struct NewListingParameters {
    //     address assetContract;
    //     uint256 tokenId;
    //     uint256 startTime;
    //     uint256 secondsUntilEndTime;
    //     uint256 quantityToList;
    //     address currencyToAccept;
    //     uint256 reservePricePerToken;
    //     uint256 buyoutPricePerToken;
    //     NewListingType listingType;
    // }

    // event NewOfferV2(
    //     uint256 indexed listingId,
    //     address indexed offeror,
    //     NewListingType indexed listingType,
    //     uint256 quantityWanted,
    //     uint256 totalOfferAmount,
    //     address currency
    // );

    // TODO: Test Old Listing Functionality
    // function createListing(ListingParameters memory _params) external override {
    //     revert("This old Listing functionality is deprecated");
    //     // ListingType
    // }

    // TODO: Add New Listing capability

    // function createChipIn(){

    // }
    // function createListingV1(NewListingParameters memory _params)
    //     external
    // // override
    // {
    //     // Get values to populate `Listing`.
    //     uint256 listingId = totalListings;
    //     totalListings += 1;

    //     address tokenOwner = _msgSender();
    //     TokenType tokenTypeOfListing = getTokenType(_params.assetContract);
    //     uint256 tokenAmountToList = getSafeQuantity(
    //         tokenTypeOfListing,
    //         _params.quantityToList
    //     );

    //     require(tokenAmountToList > 0, "QUANTITY");
    //     require(
    //         hasRole(LISTER_ROLE, address(0)) ||
    //             hasRole(LISTER_ROLE, _msgSender()),
    //         "!LISTER"
    //     );
    //     require(
    //         hasRole(ASSET_ROLE, address(0)) ||
    //             hasRole(ASSET_ROLE, _params.assetContract),
    //         "!ASSET"
    //     );

    //     uint256 startTime = _params.startTime;
    //     if (startTime < block.timestamp) {
    //         // do not allow listing to start in the past (1 hour buffer)
    //         require(block.timestamp - startTime < 1 hours, "ST");
    //         startTime = block.timestamp;
    //     }

    //     validateOwnershipAndApproval(
    //         tokenOwner,
    //         _params.assetContract,
    //         _params.tokenId,
    //         tokenAmountToList,
    //         tokenTypeOfListing
    //     );

    //     Listing memory newListing = Listing({
    //         listingId: listingId,
    //         tokenOwner: tokenOwner,
    //         assetContract: _params.assetContract,
    //         tokenId: _params.tokenId,
    //         startTime: startTime,
    //         endTime: startTime + _params.secondsUntilEndTime,
    //         quantity: tokenAmountToList,
    //         currency: _params.currencyToAccept,
    //         reservePricePerToken: _params.reservePricePerToken,
    //         buyoutPricePerToken: _params.buyoutPricePerToken,
    //         tokenType: tokenTypeOfListing,
    //         listingType: _params.listingType
    //     });

    //     listings[listingId] = newListing;

    //     // Tokens listed for sale in an auction are escrowed in Marketplace.
    //     if (newListing.listingType == ListingType.Auction) {
    //         require(
    //             newListing.buyoutPricePerToken >=
    //                 newListing.reservePricePerToken,
    //             "RESERVE"
    //         );
    //         transferListingTokens(
    //             tokenOwner,
    //             address(this),
    //             tokenAmountToList,
    //             newListing
    //         );
    //     }

    //     emit ListingAdded(
    //         listingId,
    //         _params.assetContract,
    //         tokenOwner,
    //         newListing
    //     );
    // }

    // TODO:
    // function updateListing(
    //     uint256 _listingId,
    //     uint256 _quantityToList,
    //     uint256 _reservePricePerToken,
    //     uint256 _buyoutPricePerToken,
    //     address _currencyToAccept,
    //     uint256 _startTime,
    //     uint256 _secondsUntilEndTime
    // ) external override onlyListingCreator(_listingId) {
    //     Listing memory targetListing = listings[_listingId];
    //     uint256 safeNewQuantity = getSafeQuantity(
    //         targetListing.tokenType,
    //         _quantityToList
    //     );
    //     bool isAuction = targetListing.listingType == ListingType.Auction;

    //     require(safeNewQuantity != 0, "QUANTITY");

    //     // Can only edit auction listing before it starts.
    //     if (isAuction) {
    //         require(block.timestamp < targetListing.startTime, "STARTED");
    //         require(_buyoutPricePerToken >= _reservePricePerToken, "RESERVE");
    //     }

    //     if (_startTime < block.timestamp) {
    //         // do not allow listing to start in the past (1 hour buffer)
    //         require(block.timestamp - _startTime < 1 hours, "ST");
    //         _startTime = block.timestamp;
    //     }

    //     uint256 newStartTime = _startTime == 0
    //         ? targetListing.startTime
    //         : _startTime;
    //     listings[_listingId] = Listing({
    //         listingId: _listingId,
    //         tokenOwner: _msgSender(),
    //         assetContract: targetListing.assetContract,
    //         tokenId: targetListing.tokenId,
    //         startTime: newStartTime,
    //         endTime: _secondsUntilEndTime == 0
    //             ? targetListing.endTime
    //             : newStartTime + _secondsUntilEndTime,
    //         quantity: safeNewQuantity,
    //         currency: _currencyToAccept,
    //         reservePricePerToken: _reservePricePerToken,
    //         buyoutPricePerToken: _buyoutPricePerToken,
    //         tokenType: targetListing.tokenType,
    //         listingType: targetListing.listingType
    //     });

    //     // Must validate ownership and approval of the new quantity of tokens for diret listing.
    //     if (targetListing.quantity != safeNewQuantity) {
    //         // Transfer all escrowed tokens back to the lister, to be reflected in the lister's
    //         // balance for the upcoming ownership and approval check.
    //         if (isAuction) {
    //             transferListingTokens(
    //                 address(this),
    //                 targetListing.tokenOwner,
    //                 targetListing.quantity,
    //                 targetListing
    //             );
    //         }

    //         validateOwnershipAndApproval(
    //             targetListing.tokenOwner,
    //             targetListing.assetContract,
    //             targetListing.tokenId,
    //             safeNewQuantity,
    //             targetListing.tokenType
    //         );

    //         // Escrow the new quantity of tokens to list in the auction.
    //         if (isAuction) {
    //             transferListingTokens(
    //                 targetListing.tokenOwner,
    //                 address(this),
    //                 safeNewQuantity,
    //                 targetListing
    //             );
    //         }
    //     }

    //     emit ListingUpdated(_listingId, targetListing.tokenOwner);
    // }

    // /// @dev Lets a listing's creator edit the listing's parameters.
    // function updateListing(
    //     uint256 _listingId,
    //     uint256 _quantityToList,
    //     uint256 _reservePricePerToken,
    //     uint256 _buyoutPricePerToken,
    //     address _currencyToAccept,
    //     uint256 _startTime,
    //     uint256 _secondsUntilEndTime
    // ) external override onlyListingCreator(_listingId) {
    //     Listing memory targetListing = listings[_listingId];
    //     uint256 safeNewQuantity = getSafeQuantity(
    //         targetListing.tokenType,
    //         _quantityToList
    //     );
    //     bool isAuction = targetListing.listingType == ListingType.Auction;

    //     require(safeNewQuantity != 0, "QUANTITY");

    //     // Can only edit auction listing before it starts.
    //     if (isAuction) {
    //         require(block.timestamp < targetListing.startTime, "STARTED");
    //         require(_buyoutPricePerToken >= _reservePricePerToken, "RESERVE");
    //     }

    //     if (_startTime < block.timestamp) {
    //         // do not allow listing to start in the past (1 hour buffer)
    //         require(block.timestamp - _startTime < 1 hours, "ST");
    //         _startTime = block.timestamp;
    //     }

    //     uint256 newStartTime = _startTime == 0
    //         ? targetListing.startTime
    //         : _startTime;
    //     listings[_listingId] = Listing({
    //         listingId: _listingId,
    //         tokenOwner: _msgSender(),
    //         assetContract: targetListing.assetContract,
    //         tokenId: targetListing.tokenId,
    //         startTime: newStartTime,
    //         endTime: _secondsUntilEndTime == 0
    //             ? targetListing.endTime
    //             : newStartTime + _secondsUntilEndTime,
    //         quantity: safeNewQuantity,
    //         currency: _currencyToAccept,
    //         reservePricePerToken: _reservePricePerToken,
    //         buyoutPricePerToken: _buyoutPricePerToken,
    //         tokenType: targetListing.tokenType,
    //         listingType: targetListing.listingType
    //     });

    //     // Must validate ownership and approval of the new quantity of tokens for diret listing.
    //     if (targetListing.quantity != safeNewQuantity) {
    //         // Transfer all escrowed tokens back to the lister, to be reflected in the lister's
    //         // balance for the upcoming ownership and approval check.
    //         if (isAuction) {
    //             transferListingTokens(
    //                 address(this),
    //                 targetListing.tokenOwner,
    //                 targetListing.quantity,
    //                 targetListing
    //             );
    //         }

    //         validateOwnershipAndApproval(
    //             targetListing.tokenOwner,
    //             targetListing.assetContract,
    //             targetListing.tokenId,
    //             safeNewQuantity,
    //             targetListing.tokenType
    //         );

    //         // Escrow the new quantity of tokens to list in the auction.
    //         if (isAuction) {
    //             transferListingTokens(
    //                 targetListing.tokenOwner,
    //                 address(this),
    //                 safeNewQuantity,
    //                 targetListing
    //             );
    //         }
    //     }

    //     emit ListingUpdated(_listingId, targetListing.tokenOwner);
    // }

    // /// @dev Lets a direct listing creator cancel their listing.
    // function cancelDirectListing(uint256 _listingId)
    //     external
    //     onlyListingCreator(_listingId)
    // {
    //     Listing memory targetListing = listings[_listingId];

    //     require(targetListing.listingType == ListingType.Direct, "!DIRECT");

    //     delete listings[_listingId];

    //     emit ListingRemoved(_listingId, targetListing.tokenOwner);
    // }

    struct ChipIn {
        // contract Details
        address contractAddress;
        uint256 tokenId;
        // NFT statuss
        uint256 priceToAcheive;
        uint256 amountRaised;
        // mapping For claiming
        bool ClaimedStart;
        bool inEscrowWallet;
        uint256 lockedPrice;
        uint256 lockDuration;
        uint256 sellPrice;
        // Maturity is==>1. Order Price -> True or fulfilled duration -> False
        bool maturity;
        // Prticipant -> AmountContributed
        // mapping(address => uint256) paticipantsDetails;
        // address[] participants;

        // NFTid ->
        // mapping(uint256 => mapping(address =>uint256 ))
    }

    struct chipInDetails {
        bool Status;
        //
        // Address=> AmountAdded
        mapping(address => uint256) AmountContributed;
        uint256 priceToAcheive;
        uint256 amountRaised;
        uint256 purchaseAmount;
    }

    // mapping(address => bool) OwnedByMarketPlace;

    // listingID->
    mapping(uint256 => chipInDetails) public chipInRecord;

    function createListing(ListingParameters memory _params) external override {
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
        if (newListing.listingType == ListingType.Auction) {
            require(
                newListing.buyoutPricePerToken >=
                    newListing.reservePricePerToken,
                "RESERVE"
            );
            transferListingTokens(
                tokenOwner,
                address(this),
                tokenAmountToList,
                newListing
            );
        }

        emit ListingAdded(
            listingId,
            _params.assetContract,
            tokenOwner,
            newListing
        );
    }

    function createListingWithChipInAllowed(
        ListingParameters memory _params,
        bool ChipInAllowed
    ) external {}

    function CreateChipIn(
        uint256 _listingId,
        address _buyFor,
        uint256 _quantityToBuy,
        address _currency,
        uint256 _totalPrice
    ) external payable nonReentrant onlyExistingListing(_listingId) {
        Listing memory targetListing = listings[_listingId];
        address payer = _msgSender();

        // Check whether the settled total price and currency to use are correct.
        require(
            _currency == targetListing.currency &&
                _totalPrice ==
                (targetListing.buyoutPricePerToken * _quantityToBuy),
            "!PRICE"
        );

        // executeSale(
        //     targetListing,
        //     payer,
        //     _buyFor,
        //     targetListing.currency,
        //     targetListing.buyoutPricePerToken * _quantityToBuy,
        //     _quantityToBuy
        // );
    }

    // -> Chip Created...
    // Relist Pay that why share of initiator is ....

    function FinalizeChipIn(
        Listing memory targetListing
    ) internal onlyExistingListing(targetListing.listingId) {
        {
            address payer = address(this);

            // Check whether the settled total price and currency to use are correct.
            // require(
            //     _currency == targetListing.currency &&
            //         _totalPrice ==
            //         (targetListing.buyoutPricePerToken * _quantityToBuy),
            //     "!PRICE"
            // );

            // executeSale(
            //     targetListing,
            //     payer,
            //     _buyFor,
            //     targetListing.currency,
            //     targetListing.buyoutPricePerToken * _quantityToBuy,
            //     _quantityToBuy
            // );

            // create a new Listing Now ...
        }
    }

    function buy(
        uint256 _listingId,
        address _buyFor,
        uint256 _quantityToBuy,
        address _currency,
        uint256 _totalPrice
    ) external payable override nonReentrant onlyExistingListing(_listingId) {
        Listing memory targetListing = listings[_listingId];
        address payer = _msgSender();

        // Check whether the settled total price and currency to use are correct.
        require(
            _currency == targetListing.currency &&
                _totalPrice ==
                (targetListing.buyoutPricePerToken * _quantityToBuy),
            "!PRICE"
        );

        executeSale(
            targetListing,
            payer,
            _buyFor,
            targetListing.currency,
            targetListing.buyoutPricePerToken * _quantityToBuy,
            _quantityToBuy
        );
    }

    function acceptOffer(
        uint256 _listingId,
        address _offeror,
        address _currency,
        uint256 _pricePerToken
    )
        external
        override
        nonReentrant
        onlyListingCreator(_listingId)
        onlyExistingListing(_listingId)
    {
        Offer memory targetOffer = offers[_listingId][_offeror];
        Listing memory targetListing = listings[_listingId];

        require(
            _currency == targetOffer.currency &&
                _pricePerToken == targetOffer.pricePerToken,
            "!PRICE"
        );
        require(targetOffer.expirationTimestamp > block.timestamp, "EXPIRED");

        delete offers[_listingId][_offeror];

        executeSale(
            targetListing,
            _offeror,
            _offeror,
            targetOffer.currency,
            targetOffer.pricePerToken * targetOffer.quantityWanted,
            targetOffer.quantityWanted
        );
    }

    /* -------------------------------------------------------------------------- */
    /*                                6FEB Approach                               */
    /* -------------------------------------------------------------------------- */
    // Escrow Wallet
    address escrowWalletAddress;

    // struct
    struct ChipInAsset {
        // contract Details
        address contractAddress;
        uint256 tokenId;
        // NFT statuss
        uint256 priceToAcheive;
        uint256 amountRaised;
        // mapping For claiming
        bool ClaimedStart;
        bool inEscrowWallet;
        uint256 lockedPrice;
        uint256 lockDuration;
        uint256 sellPrice;
        // Maturity is==>1. Order Price -> True or fulfilled duration -> False
        bool maturity;
        // Prticipant -> AmountContributed
        // mapping(address => uint256) paticipantsDetails;
        // address[] participants;

        // NFTid ->
        // mapping(uint256 => mapping(address =>uint256 ))
    }
    event ShareTransfered(address receiver, uint256 amount);

    function createListingWithChipInAllowed(
        ListingParameters memory _params
    ) external {
        this.createListing(_params);
    }

    function initializeChipIn(
        uint256 _listingId,
        address _intializer,
        address _currentPurchase,
        uint256 _pricePerToken,
        uint256 _lockedPrice,
        uint256 _lockDuration,
        uint256 _sellPrice
    ) external {
        Listing memory targetListing = listings[_listingId];
        // Only chipIns can be created on Listed
        require(targetListing.listingType == ListingType.Direct);
        // todo: check ChipedInAsset...
    }
}

// FIXME: My thinking
// User list with chipIn or Direct ChipIn..
// TODO: Cater the Following Conditions
// TODO: 1. if user has Chiped then cannot Update Listings....price?...Intializer updates new Price...
// TODO: If Time has Passed then User can Also Bidd.....multiSig thing
// TODO: refund Terms Define ....

// list & unlist // listing ID changed from
// validateOwnershipAndApproval check this function
// when Onwer Removes His Order from ChipIn who pays the Gas ???

// Many people Bought Together....
// After that
