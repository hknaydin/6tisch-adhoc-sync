# 6tisch-adhoc-sync

**Ad-hoc Data Synchronisation over IEEE 802.15.4e TSCH for 6TiSCH Smart Grid Networks**

`6tisch-adhoc-sync` is a gossip-based ad-hoc data synchronisation layer that operates directly over the IEEE 802.15.4e TSCH MAC, alongside RPL rather than through it. RPL remains active for routing and topology maintenance, while each node maintains a bounded local cache of measurements and continuously merges it with its neighbours' caches through periodic MAC-layer broadcasts. A mobile RPL root mounted on a service vehicle obtains cached measurements from any node it passes, including measurements of nodes it never encounters directly, without waiting for an end-to-end route to each source.

---

## Key Ideas

- **Custom MAC frame type** — `FRAME802154_ADHOCFRAME` (`0x05`), recognised at the 4eMAC layer on a fast path that bypasses the IPv6 stack, framer, address filtering, and duplicate detection.
- **Two-phase transmission** — radio-direct broadcast during TSCH scanning, shared-slot transmission once the node is associated.
- **TSCH-friendly gossip** — fixed-size local cache, monotonic sequence-number freshness, fixed broadcast period with random jitter, and per-entry hop limit to suppress broadcast storms.
- **Opportunistic retrieval** — every frame carries up to nine cached entries, so any in-range node acts as a partial proxy for the network and the mobile root accumulates the network state over the nodes it passes.
- **Backward-compatible** — the layer is gated by a single compile-time flag and coexists with RPL, the standard scheduling functions, and concurrent application traffic.

---

## Repository Layout

```
6tisch-adhoc-sync/
├── core/4emac/
│   ├── 4emac-adhoc-sync.c       # frame construction & parsing
│   ├── 4emac-adhoc-sync.h
│   ├── 4emac-timesynch.c        # scanning-phase RX path
│   ├── 4erdc.c                  # associated-phase RX slot path
│   └── 4emac-private.h          # configuration parameters
├── examples/
│   ├── ami-meter/               # static AMI meter node (udp-client)
│   └── mobile-root/             # vehicle-mounted mobile RPL root (border-router)
├── simulations/
│   ├── cooja/                   # Cooja scenarios
│   │   ├── grid-30node.csc  grid-40node.csc  grid-50node.csc  grid-60node.csc
│   │   └── random-30node.csc random-40node.csc random-50node.csc random-60node.csc
│   └── mobility/                # root trajectories (.dat), one low- and one high-coverage file per scenario
├── scripts/
│   ├── parse-cooja-log.py       # extract metrics from Cooja logs
│   ├── compute-energest.py      # ENERGEST → mW conversion
│   └── plot-results.py          # figures used in the paper
├── results/                     # CSV files of evaluation runs
│   ├── rpl_root/                # RPL-only baseline (30/40 sources)
│   └── rpl_root_gossip/         # RPL + gossip (30/40/50/60 sources)
└── docs/                        # design notes, frame format, parameters
```

---

## Configuration

All ad-hoc synchronisation parameters are defined in `core/4emac/4emac-private.h`:

| Parameter | Value used in the paper | Description |
|---|---|---|
| `FOURE_CONF_ADHOC_SYNC_ENABLED` | `0` / `1` | Master enable flag (compile-time) |
| `FOURE_ADHOC_SYNC_INTERVAL` | `10 s` | Base broadcast period (plus random jitter) |
| `FOURE_ADHOC_SYNC_MAX_NODES` | `50` (30/40-source runs) / `64` (50/60-source runs) | Cache capacity |
| `FOURE_ADHOC_SYNC_MAX_TTL` | `64` | Maximum propagation hops |
| Max payload | `100 B` | 9 entries of 11 B per frame |

Enable the synchronisation layer at build time:

```bash
make TARGET=cooja DEFINES=FOURE_CONF_ADHOC_SYNC_ENABLED=1
# for the 50- and 60-source scenarios:
make TARGET=cooja DEFINES=FOURE_CONF_ADHOC_SYNC_ENABLED=1,FOURE_ADHOC_SYNC_MAX_NODES=64
```

When the flag is unset, the build is bit-identical to a stock 6TiSCH stack.

---

## Reproducing the Evaluation

### Prerequisites
- Contiki-NG with the 4eMAC stack (Mavi Alp Information Technologies), included as a submodule
- Cooja simulator
- Python 3.9+ (analysis scripts)

### Quick Start

```bash
git clone --recursive https://github.com/hknaydin/6tisch-adhoc-sync.git
cd 6tisch-adhoc-sync
cd examples/ami-meter && make TARGET=cooja DEFINES=FOURE_CONF_ADHOC_SYNC_ENABLED=1
cd ../mobile-root && make TARGET=cooja DEFINES=FOURE_CONF_ADHOC_SYNC_ENABLED=1
cooja simulations/cooja/grid-30node.csc
python scripts/parse-cooja-log.py results/grid-30node.log
```

### Evaluation Scenarios

| Sources | Topologies | Root trajectory | Configurations | Seeds |
|---|---|---|---|---|
| 30, 40 | Grid, Random | Low coverage, High coverage | RPL-only, RPL + gossip | 5 |
| 50, 60 | Grid, Random | Low coverage, High coverage | RPL-only, RPL + gossip | 5 |

All scenarios use a 4 km × 3 km area, the Exp5438 mote (16-bit MSP430F5438) emulated under UDGM with a 1000 m transmission and 2000 m interference range, a 101-slot slotframe with 45 ms slots, and a single vehicle-mounted mobile root moving at about 5 m/s along deterministic trajectories after a 20-min warm-up. Mean values and sample standard deviations over five seeds are reported.

---

## Headline Results (30- and 40-source networks, RPL + gossip vs. RPL-only)

| Metric | RPL-only | RPL + gossip |
|---|---|---|
| Mobile-root data acquisition ratio | 22–32 % | **73–94 %** |
| Average Age of Information at the root | 18–24× higher | **28–117 s** |
| RPL control overhead | — | no material change |
| Per-node power consumption | 5.0–7.5 mW | +≈15 % |
| Static RAM (64-entry build) | — | +7.9–8.0 % |
| UDP latency | 1.0–1.4 s | 2.2–3.7 s (gossip frames share the two shared slots) |

Full per-scenario values, including the 50- and 60-source runs, are given in the paper's appendix and in `results/`.
