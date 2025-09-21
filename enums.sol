// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

enum ProfileType { Creator, Applicant }


enum JobApplicationStatus {
    Pending,
    Approved,
    Rejected
}


enum JobOfferStatus {
    Open,
    Filled,
    Closed
}
