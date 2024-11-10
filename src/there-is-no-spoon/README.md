# There Is No Spoon

What would you do if you could assume sole control of one of the major oracles on mainnet? Now you'll have the opportunity to explore this alternate reality. But so can everyone else. You have freedom to cause whatever mayhem you can imagine as long as any funds you steal are sent to the safe harbor address.

Instructions: Using the leaked set of oracle keys compromise the maximum amount of funds possible and sent them to the designated asset recovery address. The Compound v3 market is good target, but bonus points if you can find other contracts that rely on this oracle.

Measuring success: We should see a price change on the oracle used to exploit funds from dependent contracts like Compound v3


Addresses:
```
OCR_ADDRESS: 0x7d4E742018fb52E48b08BE73d041C18B21de6Fb5;
AGGREGATOR_PROXY: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;

COMET: 0xc3d688B66703497DAA19211EEdff47f25384cdc3;

WETH_ADDRESS: 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
WBTC_ADDRESS: 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
USDC_ADDRESS: 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
WSTETH_ADDRESS: 0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0;
COMP_ADDRESS: 0xc00e94cb662c3520282e6f5717214004a7f26888;
LINK_ADDRESS: 0x514910771af9ca656af840dff83e8264ecf986ca;
UNI_ADDRESS: 0x1f9840a85d5af5bf1d1762f925bdaddc4201f984;
CBBTC_ADDRESS: 0xcbb7c0000ab88b473b1f5afd9ef808440eed33bf;
```

Signer Keys
```
[
  {
    "address": "0x060328F012D2262F3851cD3EA8cafE759BEc2C8C",
    "privateKey": "0xd3e283df32c50fb9cb18ad3812a4296ae606c365152d003f202f159e39951444"
  },
  {
    "address": "0x47B39599637F74223DA4F7a491800F2F10c5200a",
    "privateKey": "0xc8f766882ac88bb7d6f8b594b6e8b758ca38bf1a3c8ebbcf8fea09ea7511e8f7"
  },
  {
    "address": "0x292BA080bd1EEfa2402b270b5cb72Bb0e828bB36",
    "privateKey": "0x78782653e6ef350a60f0a5a9416ce79607fb848d2e697d8d4ec1e92016b9be88"
  },
  {
    "address": "0x5845Ac810D1360418Ef724885D16390C1548D4fB",
    "privateKey": "0x9131525b8cab0b459d776346a4cf5bc73fa319692f82fe3872e6af3faf23f955"
  },
  {
    "address": "0x8FeC6283E60C25dC5e448cEFD553A18EF652870c",
    "privateKey": "0xcfd623ce0cb87aadc9eeea5f4695a126884199a118579ff1f0791a2ddc75af8d"
  },
  {
    "address": "0x1431Ff9A775359ACE4D8726348DD856b7D7e32Ce",
    "privateKey": "0xb51999fdc65819988e133ef1a521361093bf5b4d5e1c138f9ccfe8680f81afd7"
  },
  {
    "address": "0x61F9D6Db7148aa294694A775DF369773b8f3A2CD",
    "privateKey": "0x67754650754ff31a377be9afff7914a45856ed3e40dc91eb74704dd7dbe21890"
  },
  {
    "address": "0xd56946F88C027346ECc9702275ADF8F8E3561120",
    "privateKey": "0x8356eb1fb8db3665a6b241a544850edcd3602cb677de3c14169204ce9c88aad5"
  },
  {
    "address": "0xC284D7059Bcc26a86C67113C5551231672F48eA1",
    "privateKey": "0xcf7fa40e1a32d9a4dd5ccc1fb84bee811ce359c6f374f69a3b15c4c0b0475cea"
  },
  {
    "address": "0x5547Cc0531161C44E9A660FfD83649E2ECf13163",
    "privateKey": "0xbad1ae6455515ac936820134a1f2a8e29fd4aec42763fbfc3d02f469d58de9bc"
  },
  {
    "address": "0x46D15a45E94CDd75A0ee7f4EAf45C059752d20bb",
    "privateKey": "0x9c7d9770f2c31e3d25639e99719a664a2ee78081781d50b02bfb5fee3483fad5"
  },
  {
    "address": "0xDF184eF606B2adf5e95b8196993B13bD922d3eBd",
    "privateKey": "0xcee8b1ccd0aab1f00e9263411e0a2b23174ddea9f285d357e625df1fa0d891ea"
  },
  {
    "address": "0x6e968913135127a3d21dbaF454C50577cD688dEd",
    "privateKey": "0xc86d948b926e7119174c3c7436f7501d69dce08ca1b33c1dea1cc8a4d9acdaf2"
  }
]
```

Transmitter Keys
```
[
  {
    "address": "0x059277ff07373b7713D6bfa8Bb41382dD79dD181",
    "privateKey": "0xe1072ffc8517d45b68ee7e2e4e0c3f1647c15737076d0e60cd9de385a924cde8"
  },
  {
    "address": "0xc6c1f6BE396970b92467E28558655402f54C384d",
    "privateKey": "0xa4caa03f672e1531c41192721cd053509be92c3a2b4e6a00502fca442d129306"
  },
  {
    "address": "0x6eD4c43c226856e03f52C5305038E0B8d5092856",
    "privateKey": "0x63f44b9183023676142b50f6f16035e995b90015a7163f734851f86175a85299"
  },
  {
    "address": "0xD0d21EDfC0626D6AC1Ea12444714cb2DFeEfBCe1",
    "privateKey": "0xbe72652cd26d6292d3ae8f10b348b64062ea413b8a1b53b23b05935e3177a944"
  },
  {
    "address": "0x2f6D74151394497A8ac360222768f5a99fC0beE5",
    "privateKey": "0x8f44810840a54e920e11cff4b377b8bf71e29da035898578fdc6e47f6994f87a"
  },
  {
    "address": "0xFecA8fE1CAd0e8F22d1C849eDA003f0d1218C2eE",
    "privateKey": "0x0a11f2a34ef9d73a32411b7d4039039ee34e6aef0d2668a286f091ca55daa2a7"
  },
  {
    "address": "0x908a5877403bd0BCB8824A8a79c0CBA1B2e468cD",
    "privateKey": "0x6d4c30628920f2fb4cb03b1647ff091930955d6a56b3c2e05b1b44f7fa424363"
  },
  {
    "address": "0x1367d2AE75A60770527513DeC1B0aB04F60AfA9C",
    "privateKey": "0x5f8a0affa1122e7fbccf3984c8031f4034a7aa5741870845972ddec0146e9db6"
  },
  {
    "address": "0x37Cb11e4D21CdE99F0c00DDc65f31D25DF56eCeC",
    "privateKey": "0x46c16c9481f4e638af0cee6d23e4fa0d3212639b711b400700163fe144c74505"
  },
  {
    "address": "0x2f422Cef29f063d2dd832351aa2ad0327f62967a",
    "privateKey": "0x18496553645257a07e9bb5a8d596a2e08369ac75b833be45e86e0975f1ce2481"
  },
  {
    "address": "0x3098F67f614Ee7f701a10d823dc988100d56F40A",
    "privateKey": "0x72e02f9e5028abf6a499eb3b38a6535cda5656c0838305af3d125c4345b29dde"
  },
  {
    "address": "0x1430D4E0f41f9cA122be31D5efCA5eCE6bB6d493",
    "privateKey": "0xf3a998457b2532d812450785291409ad58915d8355328b769ee22df4b7a80241"
  },
  {
    "address": "0xbD4279D07608AFEb916e03280e40D046a7b2a7ce",
    "privateKey": "0xa1ea1581374e7174e31b9da26400bdfce7665c15a5be9deab4f92418a39a133a"
  }
]
```

**RPC URL:**
**Block Explorer:**
**Asset Recovery Address:** 0x26024E509156C6101Ec2FA6d1E8fFeA786AeaEB2