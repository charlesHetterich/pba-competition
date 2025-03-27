// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

struct Sample {
    // the unique identifier of the sample
    uint256 id;
    // the IPFS URL of the sample
    string sample_ipfs_url;
    // a description of the labeling task for the given sample
    string description;
    // a number of blocks
    uint256 submission_period;
    // the block number when the sample was submitted
    uint256 submission_block;
    // the labels for the sample
    Label[] labels;
}

struct Label {
    uint256 id; // ID within the sample's labels array
    address labeler;
    uint256 url_hash;
    string ipfs_url;
}

contract Labeler {
    uint256 private counterId = 0;

    mapping(uint256 => Sample) public samples;

    event SampleSubmitted(
        uint256 sample_id,
        string ipfs_url,
        string description
    );

    constructor() {}

    function label() public pure returns (string memory) {
        return "Labeler";
    }

    function submit_sample(
        string memory ipfs_url,
        string memory description,
        uint256 submission_period
    ) public {
        counterId += 1;
        samples[counterId].id = counterId;
        samples[counterId].sample_ipfs_url = ipfs_url;
        samples[counterId].description = description;
        samples[counterId].submission_block = block.number;
        samples[counterId].submission_period = submission_period;

        // labels is automatically an empty array
        emit SampleSubmitted(counterId, ipfs_url, description);
    }

    function submit_label(uint256 target_sample, uint256 ipfs_url_hash) public {
        require(samples[target_sample].id != 0, "Sample does not exist");
        require(
            block.number - samples[target_sample].submission_block <
                samples[target_sample].submission_period,
            "Submission period has expired"
        );

        uint256 labelId = samples[target_sample].labels.length;
        samples[target_sample].labels.push(
            Label(labelId, msg.sender, ipfs_url_hash, "")
        );
    }

    // on block submission_block + submission_period, the labeler reveals the url to their label.
    // we validate the sent url with the previously sent hash, and set the url if it matches
    function reveal_label(
        uint256 target_sample,
        uint256 target_label,
        string memory ipfs_url
    ) public {
        require(samples[target_sample].id != 0, "Sample does not exist");
        require(
            samples[target_sample].labels[target_label].labeler == msg.sender,
            "Only the labeler can reveal the label"
        );

        // Compute the hash of the provided URL
        bytes32 computedHash = keccak256(abi.encodePacked(ipfs_url));

        // Validate the hash matches the previously submitted hash
        require(
            computedHash ==
                bytes32(samples[target_sample].labels[target_label].url_hash),
            "Provided URL does not match the previously submitted hash"
        );

        // Set the IPFS URL if the hash matches
        samples[target_sample].labels[target_label].ipfs_url = ipfs_url;
    }

    function distribute_reward() public {
        // . . .
    }
}
