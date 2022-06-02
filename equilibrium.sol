// The EQ fee can be calculate from onchain data. Below is the code we use to project the EQ Fee on the UI

function getEquilibriumFee(
    _idealBalance: CurrencyAmount,
    _beforeBalance: CurrencyAmount,
    _amount: CurrencyAmount,
    _fee: FeeLibraryV02
): { eqFee: CurrencyAmount; protocolSubsidy: CurrencyAmount } {
    const afterBalance = _beforeBalance.subtract(_amount)

    let safeZoneMaxCurrency = _idealBalance.multiply(_fee.delta1Rate)
    const safeZoneMax = new Fraction(safeZoneMaxCurrency.numerator, safeZoneMaxCurrency.denominator)
    const safeZoneMinCurrency = _idealBalance.multiply(_fee.delta2Rate)
    const safeZoneMin = new Fraction(safeZoneMinCurrency.numerator, safeZoneMinCurrency.denominator)
    const proxyBeforeBalanceCurrency = _beforeBalance.lessThan(safeZoneMax) ? _beforeBalance : safeZoneMax
    const proxyBeforeBalance = new Fraction(proxyBeforeBalanceCurrency.numerator, proxyBeforeBalanceCurrency.denominator)

    let eqFee = CurrencyAmount.fromRawAmount(_amount.currency, JSBI.BigInt(0))
    let protocolSubsidy = CurrencyAmount.fromRawAmount(_amount.currency, JSBI.BigInt(0))

    if (afterBalance.greaterThan(safeZoneMax) || afterBalance.equalTo(safeZoneMax)) {
        // no fee zone, protocol subsidezes it
        eqFee = _amount.multiply(_fee.protocolSubsidyRate)
        protocolSubsidy = eqFee
    } else if (afterBalance.greaterThan(safeZoneMin) || afterBalance.equalTo(safeZoneMin)) {
        // safe zone
        eqFee = getTrapezoidArea(_amount.currency, _fee.lambda1Rate, ZERO, safeZoneMax, safeZoneMin, proxyBeforeBalance, afterBalance)
    } else {
        // danger zone
        if (_beforeBalance.greaterThan(safeZoneMin) || _beforeBalance.equalTo(safeZoneMin)) {
            // across 2 or 3 zones
            // part 1
            eqFee = eqFee.add(
                getTrapezoidArea(_amount.currency, _fee.lambda1Rate, ZERO, safeZoneMax, safeZoneMin, proxyBeforeBalance, safeZoneMin)
            )
            // part 2
            eqFee = eqFee.add(
                getTrapezoidArea(_amount.currency, _fee.lambda2Rate, _fee.lambda1Rate, safeZoneMin, ZERO, safeZoneMin, afterBalance)
            )
        } else {
            // only in danger zone
            // part2 only
            eqFee = eqFee.add(
                getTrapezoidArea(_amount.currency, _fee.lambda2Rate, _fee.lambda1Rate, safeZoneMin, ZERO, _beforeBalance, afterBalance)
            )
        }
    }

    return {
        eqFee,
        protocolSubsidy,
    }
}
