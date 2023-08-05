package network

import (
	"fmt"

	tmrand "github.com/tendermint/tendermint/libs/rand"
	dbm "github.com/tendermint/tm-db"

	"github.com/cosmos/cosmos-sdk/baseapp"
	pruningtypes "github.com/cosmos/cosmos-sdk/pruning/types"
	servertypes "github.com/cosmos/cosmos-sdk/server/types"
	"github.com/cosmos/cosmos-sdk/simapp"
	"github.com/cosmos/cosmos-sdk/simapp/params"

	"github.com/evmos/ethermint/encoding"
	"github.com/evmos/ethermint/testutil/network"

	"github.com/tharsis/evmos/app"
)

// DefaultConfig returns a sane default configuration suitable for nearly all
// testing requirements.
func DefaultConfig() network.Config {
	encCfg := encoding.MakeConfig(app.ModuleBasics)
	cfg := network.DefaultConfig()

	cfg.Codec = encCfg.Codec
	cfg.TxConfig = encCfg.TxConfig
	cfg.LegacyAmino = encCfg.Amino
	cfg.InterfaceRegistry = encCfg.InterfaceRegistry
	cfg.AppConstructor = NewAppConstructor(encCfg)
	cfg.GenesisState = app.ModuleBasics.DefaultGenesis(encCfg.Codec)

	cfg.ChainID = fmt.Sprintf("evmos_%d-1", tmrand.Int63n(9999999999999)+1)
	return cfg
}

// NewAppConstructor returns a new Evmos AppConstructor
func NewAppConstructor(encodingCfg params.EncodingConfig) network.AppConstructor {
	return func(val network.Validator) servertypes.Application {
		return app.NewEvmos(
			val.Ctx.Logger, dbm.NewMemDB(), nil, true, make(map[int64]bool), val.Ctx.Config.RootDir, 0,
			encodingCfg,
			simapp.EmptyAppOptions{},
			baseapp.SetPruning(pruningtypes.NewPruningOptionsFromString(val.AppConfig.Pruning)),
			baseapp.SetMinGasPrices(val.AppConfig.MinGasPrices),
		)
	}
}
