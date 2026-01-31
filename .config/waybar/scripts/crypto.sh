#!/bin/bash
data=$(curl -sf 'https://api.kraken.com/0/public/Ticker?pair=XBTUSD,XMRUSD')

if [[ -z "$data" ]]; then
  echo '{"text": "API error"}'
  exit 0
fi

btc=$(echo "$data" | jq -r '.result.XXBTZUSD.c[0] | tonumber | round' | numfmt --grouping)
xmr=$(echo "$data" | jq -r '.result.XXMRZUSD.c[0] | tonumber | round' | numfmt --grouping)

btc_chg=$(echo "$data" | jq -r '.result.XXBTZUSD | (((.c[0] | tonumber) - (.o | tonumber)) / (.o | tonumber) * 100) | . * 10 | round / 10')
xmr_chg=$(echo "$data" | jq -r '.result.XXMRZUSD | (((.c[0] | tonumber) - (.o | tonumber)) / (.o | tonumber) * 100) | . * 10 | round / 10')

# Add + prefix for positive changes
[[ $(echo "$btc_chg >= 0" | bc) -eq 1 ]] && btc_chg="+$btc_chg"
[[ $(echo "$xmr_chg >= 0" | bc) -eq 1 ]] && xmr_chg="+$xmr_chg"

echo "{\"text\": \"BTC $btc | XMR $xmr\", \"tooltip\": \"24h: BTC ${btc_chg}% | XMR ${xmr_chg}%\"}"
