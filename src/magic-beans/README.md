# The Magic Beans

The date is April 16, 2022. More than $1B in $BEAN is sitting in Aave and various DEXes. Somewhere out in the world a blackhat is putting their finishing touches on their BIPs and simulating their attack. But you've already identified the bug and can beat them to the punch.

In our alternate reality we have made one minor change to the governance contract to remove the mandatory 1 day waiting period between proposal submission and execution. This should make your job as a whitehat a bit easier.

Instructions: Using the virtual testnet RPC, exploit the Beanstalk contract to rescue the maximum amount of funds possible to the designated asset recovery address.

Measuring success: We should see CRV_BEAN tokens leave the Beanstalk address and used to recover various tokens to the asset recovery address. You may also find other ways to recover funds controlled by Beanstalk through the governance vulnerability.

Addresses:
```
CRV_BEAN (0x3a70DfA7d2262988064A2D051dd47521E43c9BdD)
BEAN (0xDC59ac4FeFa32293A95889Dc396682858d52e5Db)
USDC (0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48)
WETH (0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2)
DAI (0x6B175474E89094C44Da98b954EedeAC495271d0F)
WBTC (0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599)
USDT (0xdAC17F958D2ee523a2206206994597C13D831ec7)


BEANSTALK (0xC1E088fC1323b20BCBee9bd1B9fC9546db5624C5)
```

**RPC URL:**
**Block Explorer:**
**Asset Recovery Address:** 0xfB4f69CCDE9c4c9BA9084B9a0c1b61714AAdeFe0