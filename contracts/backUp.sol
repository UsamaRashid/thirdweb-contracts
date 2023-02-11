// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract BackUp {
    struct ChipIn {
        // contract Details
        uint256 chipIn_Id;
        address assetContract;
        uint256 tokenId;
        address tokenOwner;
        // NFT statuss
        uint256 startTime;
        uint256 endTime;
        uint256 quantity;
        address currency;
        uint256 reservePricePerToken;
        uint256 buyoutPricePerToken;
        TokenType tokenType;
        ListingType listingType;
        // mapping For claiming
        uint256 priceToAcheive;
        uint256 amountRaised;
        CHIPINSTATUS currentStatus;
        uint256 lockedPrice;
        uint256 lockDuration;
        uint256 sellPrice;
        // Maturity is==>1. Order Price -> True or fulfilled duration -> False
        bool maturity;
        address initialOwner;
        // mapping(address => uint256) paticipantsDetails;
        address[] participants;
        // Prticipant -> AmountContributed
        mapping(address => uint256) amountContributed;
        /// FROM LISTING

        // listingId
        // tokenOwner
        // assetContract
        // tokenId
        // startTime
        // endTime
        // quantity
        // currency
        // reservePricePerToken
        // buyoutPricePerToken
        // tokenType
        // listingType
    }
}
