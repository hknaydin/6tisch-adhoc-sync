# 6tisch-adhoc-sync

**Ad-hoc Data Synchronisation over IEEE 802.15.4e TSCH for 6TiSCH Smart Grid Networks**

`6tisch-adhoc-sync` is a gossip-based ad-hoc data synchronisation layer that operates directly over the IEEE 802.15.4e TSCH MAC and replaces RPL-based upward forwarding as the data plane of the 6TiSCH stack. Each node maintains and continuously merges a distributed snapshot of the network's measurement state with its neighbours, rather than pushing every reading toward a fixed root. A mobile sink — for example, a drive-by collector mounted on a service vehicle — can retrieve the full network state by contacting any single node in range, with no DODAG formation and no 6P negotiation.

This repository contains the implementation, simulation configurations, mobility traces, and evaluation scripts associated with the paper:

---

## Key Ideas

- **Custom MAC frame type** — `FRAME802154_ADHOCFRAME` (`0x05`), recognised at the 4eMAC layer on a fast path that bypasses the IPv6 stack, framer, address filtering, and duplicate detection.
- **Two-phase transmission** — asynchronous radio-direct broadcast during TSCH bootstrap, synchronous shared-slot transmission once the node is part of the schedule.
- **TSCH-friendly gossip** — bounded local cache, monotonic sequence-number freshness, Trickle-style broadcast period with random jitter, and per-entry TTL to suppress broadcast storms.
- **Single-contact retrieval** — a mobile sink obtains the network-wide state from any reachable node in one contact, without joining the RPL DODAG.
- **Backward-compatible** — the entire layer is gated by a single compile-time flag and coexists with RPL, with the standard scheduling functions, and with concurrent application traffic.

---

## Repository Layout

```
6tisch-adhoc-sync/
├── core/4emac/
│   ├── 4emac-adhoc-sync.c       # frame construction & parsing
│   ├── 4emac-adhoc-sync.h
│   ├── 4emac-timesynch.c        # bootstrap-phase RX path
│   ├── 4erdc.c                  # synched-phase RX slot path
│   └── 4emac-private.h          # configuration parameters
├── examples/
│   ├── ami-meter/               # static AMI meter node
│   └── mobile-sink/             # drive-by collector
├── simulations/
│   ├── cooja/                   # .csc Cooja simulation files
│   │   ├── grid-30node.csc
│   │   ├── grid-40node.csc
│   │   ├── random-30node.csc
│   │   └── random-40node.csc
├── scripts/
│   ├── parse-cooja-log.py       # extract metrics from Cooja logs
│   ├── compute-energest.py      # ENERGEST → mW conversion
│   └── plot-results.py          # figures used in the paper
├── results/                     # CSV files of evaluation runs
└── docs/                        # design notes, frame format, parameters
```

---

## Configuration

All ad-hoc synchronisation parameters are defined in `core/4emac/4emac-private.h`:

| Parameter | Default | Description |
|---|---|---|
| `FOURE_CONF_ADHOC_SYNC_ENABLED` | `0` | Master enable flag (compile-time) |
| `FOURE_ADHOC_SYNC_INTERVAL` | `10 s` | Base broadcast period |
| `FOURE_ADHOC_SYNC_MAX_NODES` | `50` | Cache capacity |
| `FOURE_ADHOC_SYNC_MAX_TTL` | `64` | Maximum propagation hops |
| Max payload | `100 B` | ≈14 entries per frame |

Enable the synchronisation layer at build time:

```bash
make TARGET=cooja DEFINES=FOURE_CONF_ADHOC_SYNC_ENABLED=1
```

When the flag is unset, the build is bit-identical to a stock 6TiSCH stack.

---

## Reproducing the Evaluation

### Prerequisites
- Contiki-NG (4eMAC stack from Mavi Alp Information Technologies)
- Cooja simulator
- BonnMotion 3.0+
- Python 3.9+ (for the analysis scripts)

### Quick Start

```bash
# 1. Clone the repository (with the Contiki-NG/4eMAC submodule)
git clone --recursive https://github.com/hknaydin/6tisch-adhoc-sync.git
cd 6tisch-adhoc-sync

# 2. Build the AMI meter and mobile-sink examples
cd examples/ami-meter && make TARGET=cooja
cd ../mobile-sink && make TARGET=cooja

# 3. Run a Cooja simulation
cooja simulations/cooja/grid-30node.csc

# 4. Parse the resulting log
python scripts/parse-cooja-log.py results/grid-30node.log
```

### Evaluation Scenarios

| Scenario | Topology | Sink mobility | Mobile sinks |
|---|---|---|---|
| S1 | Grid | Static | 0 |
| S2 | Grid | High (2–8 m/s, RWP) | 1 |
| S3 | Random | Static | 0 |
| S4 | Random | High (2–8 m/s, RWP) | 1 |

All six scenarios are executed for both 30-node and 40-node networks on a 300 m × 300 m area, with the Exp5438 mote (16-bit MSP430F5438) emulated under UDGM. Each scenario is repeated for ten random seeds; mean values are reported.

---

## Headline Results

Comparison against standard 6TiSCH (RPL Classic + Minimal 6TiSCH schedule):

| Metric | Standard 6TiSCH | This work |
|---|---|---|
| Control overhead | High (DIO/DAO/6P) | **−72 %** (Trickle-based) |
| Convergence time | 120–300 s | **15–45 s** |
| Memory footprint | 12 KB (RPL table) | **4 KB** (cache) |
| Mobile-sink success | < 30 % | **> 92 %** |
| Avg. data latency | 450 ms | **120 ms** |

The protocol remains stable under packet-loss rates of up to 30 %.

## Acknowledgements

The customised Contiki-NG and 4eMAC TSCH stack used in this work were provided by [Mavi Alp Information Technologies](https://www.mavialp.com/). Field-deployment and integration discussions with [Dicle Electricity Distribution Inc. (DEDAŞ)](https://www.dedas.com.tr/) shaped the AMI use case that motivated the architecture.

---

## License

This project is released under the MIT License. See [`LICENSE`](LICENSE) for details. Note that the underlying Contiki-NG / 4eMAC stack carries its own license terms; refer to the corresponding submodule for details.

---

## Contact

For questions, issues, or collaboration:

- Hakan Aydin — Karadeniz Technical University, Software Engineering
- GitHub Issues — preferred channel for bug reports and feature requests
