package ocr3types

import (
	"context"
	"time"

	"github.com/smartcontractkit/libocr/commontypes"
	"github.com/smartcontractkit/libocr/offchainreporting2plus/types"
)

type Outcome []byte

type ReportingPluginFactory[RI any] interface {
	// Creates a new reporting plugin instance. The instance may have
	// associated goroutines or hold system resources, which should be
	// released when its Close() function is called.
	NewReportingPlugin(context.Context, ReportingPluginConfig) (ReportingPlugin[RI], ReportingPluginInfo, error)
}

type ReportingPluginConfig struct {
	ConfigDigest types.ConfigDigest

	// OracleID (index) of the oracle executing this ReportingPlugin instance.
	OracleID commontypes.OracleID

	// N is the total number of nodes.
	N int

	// F is an upper bound on the number of faulty nodes, i.e. there are assumed
	// to be at most F faulty nodes.
	F int

	// Encoded configuration for the contract
	OnchainConfig []byte

	// Encoded configuration for the ORR3Plugin disseminated through the
	// contract. This value is only passed through the contract, but otherwise
	// ignored by it.
	OffchainConfig []byte

	// Estimate of the duration between rounds. You should not rely on this
	// value being accurate. Rounds might occur more or less frequently than
	// estimated.
	//
	// This value is intended for estimating the load incurred by a
	// ReportingPlugin before running it and for configuring caches.
	EstimatedRoundInterval time.Duration

	// Maximum duration the ReportingPlugin's functions are allowed to take
	MaxDurationQuery                        time.Duration
	MaxDurationObservation                  time.Duration
	MaxDurationShouldAcceptAttestedReport   time.Duration
	MaxDurationShouldTransmitAcceptedReport time.Duration
}

type ReportWithInfo[RI any] struct {
	Report types.Report
	// Metadata about the report passed to transmitter, keyring, etc..., e.g.
	// to trace flow of report through the system.
	Info RI
}

type TransmissionSchedule struct {
	// The IDs of the oracles that should transmit the report.
	// If you have n oracles, and want all of them to transmit, you should set
	// this to [0, 1, ..., n-1].
	Transmitters []commontypes.OracleID
	// The transmission delays for transmission of the report.
	// The length of this slice must be equal to the length of Transmitters.
	//
	// We randomly permute the oracles for transmission, independently for
	// each report. For example:
	// - n = 7
	// - Transmitters = [1, 3, 5]
	// - TransmissionDelays = [10s, 20s, 30s]
	// Then oracle 3 might transmit after 10s, oracle 5 after 20s, and oracle 1
	// after 30s. Oracles 0, 2, 4, and 6 will not transmit at all.
	// Note that on oracles that do not transmit, ShouldAcceptAttestedReport and
	// ShouldTransmitAcceptedReport will not be invoked.
	TransmissionDelays []time.Duration
}

type ReportPlus[RI any] struct {
	ReportWithInfo ReportWithInfo[RI]
	// Overrides the transmission schedule for this report. Leave as nil to
	// use the default transmission schedule.
	TransmissionScheduleOverride *TransmissionSchedule
}

type OutcomeContext struct {
	// SeqNr of an OCR3 round/outcome. This is guaranteed to increase
	// in increments of one, i.e. for each SeqNr exactly one Outcome will
	// be generated.
	// The initial SeqNr value is 1. Its PreviousOutcome is nil.
	SeqNr uint64
	// This is guaranteed (!) to be the unique outcome with sequence number
	// (SeqNr-1).
	PreviousOutcome Outcome

	// Deprecated: exposed for legacy compatibility, do not rely on this
	// unless you have a really good reason.
	Epoch uint64
	// Deprecated: exposed for legacy compatibility, do not rely on this
	// unless you have a really good reason.
	Round uint64
}

// A ReportingPlugin allows plugging custom logic into the OCR3 protocol. The
// OCR protocol handles cryptography, networking, ensuring that a sufficient
// number of nodes is in agreement about any report, transmitting the report to
// the contract, etc... The ReportingPlugin handles application-specific logic.
// To do so, the ReportingPlugin defines a number of callbacks that are called
// by the OCR protocol logic at certain points in the protocol's execution flow.
// The report generated by the ReportingPlugin must be in a format understood by
// contract that the reports are transmitted to.
//
// We assume that each correct node participating in the protocol instance will
// be running the same ReportingPlugin implementation. However, not all nodes
// may be correct; up to f nodes be faulty in arbitrary ways (aka byzantine
// faults). For example, faulty nodes could be down, have intermittent
// connectivity issues, send garbage messages, or be controlled by an adversary.
//
// For a protocol round where everything is working correctly, follower oracles
// will call Observation, ValidateObservation, ObservationQuorum, Outcome, and
// Reports. The leader oracle will additionally call Query at the beginning of
// the round. For each report, ShouldAcceptAttestedReport will be called, iff
// the oracle is in the set of transmitters for the report. If
// ShouldAcceptAttestedReport returns true, ShouldTransmitAcceptedReport will be
// called. However, an ReportingPlugin must also correctly handle the case where
// faults occur.
//
// In particular, an ReportingPlugin must deal with cases where:
//
// - only a subset of the functions on the ReportingPlugin are invoked for a
// given round
//
// - an arbitrary number of seqnrs has been skipped between invocations of the
// ReportingPlugin
//
// - the observation returned by Observation is not included in the list of
// AttributedObservations passed to Report
//
// - a query or observation is malformed. (For defense in depth, it is also
// recommended that malformed outcomes are handled gracefully.)
//
// - instances of the ReportingPlugin run by different oracles have different
// call traces. E.g., the ReportingPlugin's Observation function may have been
// invoked on node A, but not on node B.
//
// All functions on an ReportingPlugin should be thread-safe.
//
// The execution of the functions in the ReportingPlugin is on the critical path
// of the protocol's execution. A blocking function may block the oracle from
// participating in the protocol. Functions should be designed to generally
// return as quickly as possible and honor context expiration.
//
// For a given OCR protocol instance, there can be many (consecutive) instances
// of an ReportingPlugin, e.g. due to software restarts. If you need
// ReportingPlugin state to survive across restarts, you should store it in the
// Outcome or persist it. A ReportingPlugin instance will only ever serve a
// single protocol instance. Outcomes and other state are are not preserved
// between protocol instances. A fresh protocol instance will start with a clean
// state. Carrying state between different protocol instances is up to the
// ReportingPlugin logic.
type ReportingPlugin[RI any] interface {
	// Query creates a Query that is sent from the leader to all follower nodes
	// as part of the request for an observation. Be careful! A malicious leader
	// could equivocate (i.e. send different queries to different followers.)
	// Many applications will likely be better off always using an empty query
	// if the oracles don't need to coordinate on what to observe (e.g. in case
	// of a price feed) or the underlying data source offers an (eventually)
	// consistent view to different oracles (e.g. in case of observing a
	// blockchain).
	//
	// You may assume that the outctx.SeqNr is increasing monotonically (though
	// *not* strictly) across the lifetime of a protocol instance and that
	// outctx.previousOutcome contains the consensus outcome with sequence
	// number (outctx.SeqNr-1).
	Query(ctx context.Context, outctx OutcomeContext) (types.Query, error)

	// Observation gets an observation from the underlying data source. Returns
	// a value or an error.
	//
	// You may assume that the outctx.SeqNr is increasing monotonically (though
	// *not* strictly) across the lifetime of a protocol instance and that
	// outctx.previousOutcome contains the consensus outcome with sequence
	// number (outctx.SeqNr-1).
	Observation(ctx context.Context, outctx OutcomeContext, query types.Query) (types.Observation, error)

	// Should return an error if an observation isn't well-formed.
	// Non-well-formed  observations will be discarded by the protocol. This
	// function should be pure. This is called for each observation, don't do
	// anything slow in here.
	//
	// You may assume that the outctx.SeqNr is increasing monotonically (though
	// *not* strictly) across the lifetime of a protocol instance and that
	// outctx.previousOutcome contains the consensus outcome with sequence
	// number (outctx.SeqNr-1).
	ValidateObservation(ctx context.Context, outctx OutcomeContext, query types.Query, ao types.AttributedObservation) error

	// ObservationQuorum indicates whether the provided valid (according to
	// ValidateObservation) observations are sufficient to construct an outcome.
	//
	// This function should be pure. Don't do anything slow in here.
	//
	// This is an advanced feature. The "default" approach (what OCR1 & OCR2
	// did) is to have this function call
	// quorumhelper.ObservationCountReachesObservationQuorum(QuorumTwoFPlusOne, ...)
	//
	// If you write a custom implementation, be sure to consider that byzantine
	// oracles may not contribute valid observations, and you still want your
	// plugin to remain live. This function must be monotone in aos, i.e. if
	// it returns true for aos, it must also return true for any
	// superset of aos.
	ObservationQuorum(ctx context.Context, outctx OutcomeContext, query types.Query, aos []types.AttributedObservation) (quorumReached bool, err error)

	// Generates an outcome for a seqNr, typically based on the previous
	// outcome, the current query, and the current set of attributed
	// observations.
	//
	// This function should be pure. Don't do anything slow in here.
	//
	// You may assume that the outctx.SeqNr is increasing monotonically (though
	// *not* strictly) across the lifetime of a protocol instance and that
	// outctx.previousOutcome contains the consensus outcome with sequence
	// number (outctx.SeqNr-1).
	//
	// You may assume that all provided observations have been validated by
	// ValidateObservation.
	Outcome(ctx context.Context, outctx OutcomeContext, query types.Query, aos []types.AttributedObservation) (Outcome, error)

	// Generates a (possibly empty) list of reports from an outcome. Each report
	// will be signed and possibly be transmitted to the contract. (Depending on
	// ShouldAcceptAttestedReport & ShouldTransmitAcceptedReport)
	//
	// This function should be pure. Don't do anything slow in here.
	//
	// This is likely to change in the future. It will likely be returning a
	// list of report batches, where each batch goes into its own Merkle tree.
	//
	// You may assume that the outctx.SeqNr is increasing monotonically (though
	// *not* strictly) across the lifetime of a protocol instance and that
	// outctx.previousOutcome contains the consensus outcome with sequence
	// number (outctx.SeqNr-1).
	Reports(ctx context.Context, seqNr uint64, outcome Outcome) ([]ReportPlus[RI], error)

	// Decides whether a report should be accepted for transmission. Any report
	// passed to this function will have been attested, i.e. signed by f+1
	// oracles.
	//
	// Don't make assumptions about the seqNr order in which this function
	// is called.
	ShouldAcceptAttestedReport(ctx context.Context, seqNr uint64, reportWithInfo ReportWithInfo[RI]) (bool, error)

	// Decides whether the given report should actually be broadcast to the
	// contract. This is invoked just before the broadcast occurs. Any report
	// passed to this function will have been signed by a quorum of oracles and
	// been accepted by ShouldAcceptAttestedReport.
	//
	// Don't make assumptions about the seqNr order in which this function
	// is called.
	//
	// As mentioned above, you should gracefully handle only a subset of a
	// ReportingPlugin's functions being invoked for a given report. For
	// example, due to reloading persisted pending transmissions from the
	// database upon oracle restart, this function  may be called with reports
	// that no other function of this instance of this interface has ever
	// been invoked on.
	ShouldTransmitAcceptedReport(ctx context.Context, seqNr uint64, reportWithInfo ReportWithInfo[RI]) (bool, error)

	// If Close is called a second time, it may return an error but must not
	// panic. This will always be called when a plugin is no longer
	// needed, e.g. on shutdown of the protocol instance or shutdown of the
	// oracle node. This will only be called after any calls to other functions
	// of the plugin have completed.
	Close() error
}

// It's much easier to increase these than to decrease them, so we start with
// conservative values. Talk to the maintainers if you need higher limits for
// your plugin.
const (
	mib                     = 1024 * 1024
	MaxMaxQueryLength       = 5 * mib
	MaxMaxObservationLength = 1 * mib
	MaxMaxOutcomeLength     = 5 * mib
	MaxMaxReportLength      = 5 * mib
	MaxMaxReportCount       = 2000
)

// Limits for data returned by the ReportingPlugin.
// Used for computing rate limits and defending against outsized messages.
// Messages are checked against these values during (de)serialization. Be
// careful when changing these values, they could lead to different versions
// of a ReportingPlugin being unable to communicate with each other.
type ReportingPluginLimits struct {
	MaxQueryLength       int
	MaxObservationLength int
	MaxOutcomeLength     int
	MaxReportLength      int
	MaxReportCount       int
}

type ReportingPluginInfo struct {
	// Used for debugging purposes.
	Name string

	Limits ReportingPluginLimits
}