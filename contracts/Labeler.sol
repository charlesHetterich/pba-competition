// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

struct Sample {
    uint256 id;
    string sample_ipfs_url;
    string description;
    Label[] labels;
}

struct Label {
    uint256 id;
    address labeler;
    string label_ipfs_url;
}

contract Labeler {
    uint256 private counterId = 0;

    mapping(uint256 => Sample) public samples;

    // given new sample, return
    event SampleSubmitted(int sample_id, string ipfs_url, string description);

    constructor() {}

    function label() public pure returns (string memory) {
        return "Labeler";
    }

    function submit_sample(
        string memory ipfs_url,
        string memory description
    ) public {
        // increment counter
        counterId += 1;

        Sample memory newSample = Sample(
            counterId,
            ipfs_url,
            description,
            new Label[](0)
        );
        samples[counterId] = newSample;

        emit SampleSubmitted(int(counterId), ipfs_url, description);
    }

    function submit_label(
        uint256 target_sample,
        string memory ipfs_url
    ) public {
        // store label
        samples[target_sample].labels.push(
            Label(counterId, msg.sender, ipfs_url)
        );
    }
}
