// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

struct Sample {
    uint256 id;
    string sample_ipfs_url;
    string description;
    Label[] labels;
}

struct Label {
    uint256 id; // ID within the sample's labels array
    address labeler;
    string label_ipfs_url;
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
        string memory description
    ) public {
        counterId += 1;
        samples[counterId].id = counterId;
        samples[counterId].sample_ipfs_url = ipfs_url;
        samples[counterId].description = description;
        // labels is automatically an empty array
        emit SampleSubmitted(counterId, ipfs_url, description);
    }

    function submit_label(
        uint256 target_sample,
        string memory ipfs_url
    ) public {
        require(samples[target_sample].id != 0, "Sample does not exist");
        uint256 labelId = samples[target_sample].labels.length;
        samples[target_sample].labels.push(
            Label(labelId, msg.sender, ipfs_url)
        );
    }
}
