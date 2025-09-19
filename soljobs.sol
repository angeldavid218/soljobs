// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./structs.sol";
import "./constants.sol";

/**
 * @title SolJobs
 * @dev Create, apply and award remote jobs on the blockchain
 */

contract SolJobs {
    address private manager;

    mapping (address => CreatorProfile) public creatorProfiles; 
    mapping (address => ApplicantProfile) public applicantProfiles;

    uint internal numberOfCreatorProfiles;
    uint internal numberOfApplicantProfiles;

    mapping (string => bool) private creatorEmails;
    mapping (string => bool) private applicantEmails;

    mapping (address => bool) private creatorAddresses;
    mapping (address => bool) private applicantAddresses;

    uint numberOfJobsCreated;
    mapping (uint => JobOffer) public jobOffers;

    uint numberOfApplications;
    mapping (uint => JobApplication) public jobApplications;



    constructor() {
        manager = msg.sender;
    }

    modifier accountIsUnique(string calldata _email) {
        require(creatorEmails[_email] == false && applicantEmails[_email] == false, emailAlreadyExistsMsg);
        require(creatorAddresses[msg.sender] == false && applicantAddresses[msg.sender] == false, addressAlreadyExistsMsg);

        _;
    }

    modifier callerHasCreatorProfile(address _address) {
        require(creatorAddresses[_address] == true, callerHasNoCreatorProfile);
        _;
    }

    modifier callerHasApplicantProfile(address _address) {
        require(applicantAddresses[_address] == true, callerHasNoApplicantProfile);
        _;
    }


    event CreatorProfileCreated(uint newCreatorID);
    event ApplicantProfileCreated(uint newApplicantID);
    event JobCreated(uint newJobID);
    event ApplicationSubmitted(uint applicationID);

    function createCreatorProfile(
        string calldata _name,
        string calldata _email,
        string calldata _description,
        string calldata _tagline
    ) accountIsUnique(_email) external {
        uint creatorID = ++numberOfCreatorProfiles;

        CreatorProfile storage profile = creatorProfiles[msg.sender];
        profile.id = creatorID;
        profile.name = _name;
        profile.email = _email;
        profile.description = _description;
        profile.tagline = _tagline;

        // add to emails and addresses list
        creatorEmails[_email] = true;
        creatorAddresses[msg.sender] = true;

        // defaults
        profile.verified = false;
        profile.profileType = ProfileType.Creator;
        profile.creatorAddress = msg.sender;

        emit CreatorProfileCreated(creatorID);
    }

    function createApplicantProfile(
        string calldata _fullname,
        string calldata _email,
        string calldata _location,
        string calldata _bio
    ) external accountIsUnique(_email) {
        uint applicantID = ++numberOfApplicantProfiles;

        ApplicantProfile storage profile = applicantProfiles[msg.sender];
        profile.id = applicantID;
        profile.fullname = _fullname;
        profile.email = _email;
        profile.location = _location;
        profile.bio = _bio;
        
        // add to emails and addresses list
        applicantEmails[_email] = true;
        applicantAddresses[msg.sender] = true;

        // defaults
        profile.profileType = ProfileType.Applicant;
        profile.applicantAddress = msg.sender;

        emit ApplicantProfileCreated(applicantID);
    }

    function createJobOffer(
        string calldata title,
        string calldata description,
        uint compensation
    ) external callerHasCreatorProfile(msg.sender) {
        uint jobID = ++numberOfJobsCreated;
        JobOffer storage job = jobOffers[jobID];
        job.id = jobID;
        job.title = title;
        job.description = description;
        job.compensation = compensation;
        
        CreatorProfile memory creator = creatorProfiles[msg.sender];
        job.creator = creator;


        
        emit JobCreated(jobID);
    }

    function applyForAJob(
        uint jobID,
        string calldata coverLetter
    ) external callerHasApplicantProfile(msg.sender) {
        uint applicationID = ++numberOfApplications;

        JobOffer storage jobOffer = jobOffers[jobID];

        JobApplication storage jobApplication = jobApplications[applicationID];
        jobApplication.id = applicationID;
        jobApplication.jobOfferId = jobID;
        jobApplication.coverLetter = coverLetter;
        jobApplication.applicant = applicantProfiles[msg.sender];
        jobApplication.status = JobApplicationStatus.Pending;

        jobOffer.applications.push(jobApplication);
        
        emit ApplicationSubmitted(applicationID);


    }
        

}