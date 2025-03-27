// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

struct Sample {
    uint256 id;
    string sample_ipfs_url;
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

    // sample id --> sample
    // mapping(uint256 => string) private sampleIdToIpfsUrlAndType;

    // // label id --> label
    // mapping(uint256 => (string, address)) private sampleIdToIpfsUrlAndType;

    // // sample id --> many label ids
    // mapping(uint256 => uint256[]) private sampleIdToLabelIds;

    // given new sample, return
    event SampleSubmitted(int sample_id, string ipfs_url, string description);

    constructor() {}

    function label() public pure returns (string memory) {
        return "Labeler";
    }

    function submit_sample(
        string ipfs_url,
        string description
    ) public pure returns (int memory) {
        // increment counter
        counterId += 1;

        // store sample

        Sample storage newSample = samples[counterId];
        newSample.id = counterId;
        newSample.sample_ipfs_url = ipfs_url;

        emit SampleSubmitted(int(counterId), ipfs_url, description);
    }

    function submit_label(
        int target_sample,
        string ipfs_url,
        int x,
        int y
    ) external pure returns (int memory) {
        // store label
        sampleIdToIpfsUrlAndType[target_sample] = ipfs_url;
    }
}
