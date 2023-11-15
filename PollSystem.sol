// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0;

contract Poll {
    event Received(address, uint256);
    event Debug(address);
    struct Option {
        bool flag; // 선택지의 활성화 비활성화 flag
        string name; // 선택지의 이름
        string description; // 선택지 설명
        int count; // 선택지 투표 수
    }
    struct Info {
        string title; // 투표의 제목
        string description; // 투표 설명
        uint256 weiPerVoter; // 투표자가 받아갈 wei 양
        bool start; // poll의 시작 flag
        bool close; // poll의 종료 flag
    }
    address owner; // contract 주인
    mapping(address => bool) voters; // 유효한 투표자 맵
    mapping(address => bool) banList; // 추방된 투표자 맵
    Option[] options; // Option array
    Info info; // Info 객체
    address[] voterAddressList; // 투표자들의 주소 array
    uint256 voterNum; // 유효한 투표자 수
    uint256 amount; // contract가 소유하는 wei 양

    constructor(
        string memory title,
        string memory description,
        uint256 weiPerVoter
    ) {
        owner = msg.sender;
        voters[owner] = false;
        voterNum = 0;
        info.title = title;
        info.description = description;
        info.weiPerVoter = weiPerVoter;
        info.start = false;
        info.close = false;
    }

    function startPoll() public onlyOwner {
        if ((info.start == false) && (info.close == false)) {
            if (amount / info.weiPerVoter >= voterNum) {
                info.start = true;
            } else {
                revert("not ready to set amount");
            }
        } else {
            revert("already closed or info.started");
        }
    }

    function closePoll() public payable onlyOwner {
        if (info.start == true) {
            payable(owner).transfer(address(this).balance);
            info.close = true;
        }
    }

    function addAmount() public payable onlyOwner {
        emit Received(msg.sender, msg.value);
        amount += msg.value;
    }

    function addVoter(address[] calldata _voters) public onlyOwner {
        if (info.start) {
            revert("already start poll");
        }
        for (uint256 i = 0; i < _voters.length; i++) {
            if (!voters[_voters[i]]) {
                emit Debug(_voters[i]);
                voters[_voters[i]] = true;
                banList[_voters[i]] = false;
                voterAddressList.push(_voters[i]);
                voterNum++;
            }
        }
    }

    function deleteVoter(address[] calldata _voters) public onlyOwner {
        if (info.start) {
            revert("already start poll");
        }
        for (uint256 i = 0; i < _voters.length; i++) {
            if (!banList[_voters[i]]) {
                banList[_voters[i]] = true;
                voterNum--;
            }
        }
    }

    function addOption(Option[] calldata _options) public onlyOwner {
        if (info.start) {
            revert("already start poll");
        }
        for (uint256 i = 0; i < _options.length; i++) {
            options.push(_options[i]);
        }
    }

    function deleteOption(uint256[] calldata delList) public onlyOwner {
        if (info.start) {
            revert("already start poll");
        }
        for (uint256 i = 0; i < delList.length; i++) {
            options[delList[i]].flag = false;
        }
    }

    function vote(uint256 optionIdx) public payable onlyVoter {
        if (options[optionIdx].flag == false) {
            revert("access deleted Option");
        }
        if (info.start == false) {
            revert("not ready to info.start poll");
        }
        // 투표시 돈 입금 받아야 함
        voters[msg.sender] = false;
        payable(msg.sender).transfer(info.weiPerVoter);
        options[optionIdx].count++;
    }

    function setTitle(string calldata _title) public onlyOwner {
        info.title = _title;
    }

    function setDescription(string calldata _description) public onlyOwner {
        info.description = _description;
    }

    function setWeiPerVoter(uint256 _weiPerVoter) public onlyOwner {
        info.weiPerVoter = _weiPerVoter;
    }

    function getAmount() public view returns (uint256) {
        return amount;
    }

    function getVoterState(address voter) public view returns (bool) {
        return voters[voter];
    }

    function getBanState(address voter) public view returns (bool) {
        return banList[voter];
    }

    function getInfo() public view returns (Info memory) {
        return info;
    }

    function getOptions() public view returns (Option[] memory) {
        return options;
    }

    function getVoterNum() public view returns (uint256) {
        return voterNum;
    }

    function getVotersAddress() public view returns (address[] memory) {
        return voterAddressList;
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }

    modifier onlyVoter() {
        require(voters[msg.sender]);
        require(banList[msg.sender] == false);
        _;
    }
}

contract PollSystem {
    struct UserInfo {
        string name;
        string univName;
        string deptName;
        string id;
    }
    address owner;
    uint256 pollNum;
    Poll poll;
    mapping(address => UserInfo) userInfos;
    uint256 userNum;
    mapping(address => address[]) createdPollList;
    mapping(address => address[]) invitedPollList;

    constructor() {
        owner = msg.sender;
        pollNum = 0;
        userNum = 0;
    }

    function register(UserInfo calldata _userInfo) public {
        userInfos[msg.sender] = _userInfo;
    }

    function createPoll(address pollAddress) public {
        poll = Poll(pollAddress);
        if (poll.getOwner() == msg.sender) {
            createdPollList[msg.sender].push(pollAddress);
        } else {
            revert("Not your poll");
        }
    }

    function invitePoll(
        address pollAddress,
        address[] calldata voterAddresses
    ) public {
        poll = Poll(pollAddress);
        if (poll.getOwner() == msg.sender) {
            for (uint256 i = 0; i < voterAddresses.length; i++) {
                if (poll.getVoterState(voterAddresses[i])) {
                    invitedPollList[voterAddresses[i]].push(pollAddress);
                }
            }
        } else {
            revert("Not your poll");
        }
    }

    function getUserInfo() public view returns (UserInfo memory) {
        return userInfos[msg.sender];
    }

    function getUserCreatedPollList() public view returns (address[] memory) {
        return createdPollList[msg.sender];
    }

    function getUserInvitedPollList() public view returns (address[] memory) {
        return invitedPollList[msg.sender];
    }
}
