// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./enums.sol";

struct CreatorProfile {
    uint id;
    string email;
    string name;
    string tagline;
    string description;
    address creatorAddress;
    bool verified;
    ProfileType profileType;
    uint[] jobOfferIDs;
}

struct ApplicantProfile {
    uint id;
    address applicantAddress;
    string fullname;
    string email;
    string location;
    string bio;
    ProfileType profileType;
    uint[] applicationIDs;
}

struct JobOffer {
    uint id;
    string title;
    string description;
    uint compensation;
    CreatorProfile creator;
    JobApplication[] applications;
}


struct JobApplication {
    uint id;
    uint jobOfferId;
    string  coverLetter;
    ApplicantProfile applicant;
    JobApplicationStatus status;
}

