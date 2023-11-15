var pollsysabi = [
  {
    inputs: [],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "pollAddress",
        type: "address",
      },
    ],
    name: "createPoll",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "getUserCreatedPollList",
    outputs: [
      {
        internalType: "address[]",
        name: "",
        type: "address[]",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getUserInfo",
    outputs: [
      {
        components: [
          {
            internalType: "string",
            name: "name",
            type: "string",
          },
          {
            internalType: "string",
            name: "univName",
            type: "string",
          },
          {
            internalType: "string",
            name: "deptName",
            type: "string",
          },
          {
            internalType: "string",
            name: "id",
            type: "string",
          },
        ],
        internalType: "struct PollSystem.UserInfo",
        name: "",
        type: "tuple",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getUserInvitedPollList",
    outputs: [
      {
        internalType: "address[]",
        name: "",
        type: "address[]",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "pollAddress",
        type: "address",
      },
      {
        internalType: "address[]",
        name: "voterAddresses",
        type: "address[]",
      },
    ],
    name: "invitePoll",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        components: [
          {
            internalType: "string",
            name: "name",
            type: "string",
          },
          {
            internalType: "string",
            name: "univName",
            type: "string",
          },
          {
            internalType: "string",
            name: "deptName",
            type: "string",
          },
          {
            internalType: "string",
            name: "id",
            type: "string",
          },
        ],
        internalType: "struct PollSystem.UserInfo",
        name: "_userInfo",
        type: "tuple",
      },
    ],
    name: "register",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
];
