/*
 * Cooja ScriptRunner Test Script
 * Ad-Hoc Sync Metrics + Standard UDP PDR/Latency
 * 
 * Bu scripti Cooja > ScriptRunner plugin'ine kopyalayın.
 * border-router-server (ID=1) + 30x border-router-client (ID=2..31)
 * 
 * Hesaplanan Metrikler:
 *   1. Control Overhead (RPL DIO/DIS/DAO + Adhoc TX/RX)
 *   2. Convergence Time (tüm node'lar tüm diğer node'ları öğrenene kadar)
 *   3. Average Version Age (seq farkı)
 *   4. Single-Contact Retrieval (η_sc)
 *   5. UDP PDR / Latency (mevcut metrikler)
 */

/* ===== TIMEOUT (90 dakika = 5400000 ms) ===== */
TIMEOUT(5400000);

/* ===== CONFIGURATION ===== */
serverID = 1;
nodeCount = sim.getMotesCount();

/* ===== UDP METRICS (mevcut) ===== */
totalReceived = 0;
totalSent = 0;
totaldelay = 0.0;
totalBufferDrop = 0;

parent_switch_count = 0;
parent_switch_count2 = 0;
parent_switch_count3 = 0;

flag = new Array();
flag2 = new Array();
time_master_is_changed = new Array();
time_is_allocated = new Array();
time_is_allocated2 = new Array();
switch_delay = new Array();
switch_delay2 = new Array();
total_switch_delay = 0.0;
total_switch_delay2 = 0.0;

timeReceived = new Array();
timeSent = new Array();
delay = new Array();

Node_total_send = new Array();
Node_total_received = new Array();
Node_total_delay = new Array();
Node_PDR = new Array();
Node_switch_count = new Array();
Node_switch_count_receive = new Array();
Node_switch_count_transmit = new Array();
Node_buffer_drop = new Array();

/* ===== AD-HOC SYNC METRICS ===== */
// Her node'un bildiği diğer node'ların son seq değerleri
// adhoc_cache[i] = {node_id: seq, ...}  şeklinde
adhoc_cache = new Array();

// Her node'un kendi seq değeri
adhoc_own_seq = new Array();

// Tüm node'lardaki en yüksek seq (global latest)
adhoc_latest_seq = new Array();

// Her node'un convergence zamanı (-1 = henüz converge olmadı)
adhoc_convergence_time = new Array();

// Control overhead sayaçları
adhoc_tx_count = new Array();
adhoc_rx_count = new Array();
rpl_dio_count = new Array();
rpl_dis_count = new Array();
rpl_dao_count = new Array();

// İlk ADHOC_SYNC görülme zamanı
adhoc_first_time = -1;

// Network convergence zamanı
network_converged = false;
network_convergence_time = -1;

/* ===== ENERGEST METRICS ===== */
energest_cpu = new Array();
energest_lpm = new Array();
energest_tx = new Array();
energest_rx = new Array();
energest_total = new Array();

/* ===== INITIALIZATION ===== */
for (i = 1; i <= nodeCount; i++) {
  timeReceived[i] = 0.0;
  timeSent[i] = 0.0;
  delay[i] = 0.0;
  flag[i] = 0;
  flag2[i] = 0;
  time_master_is_changed[i] = 0.0;
  time_is_allocated[i] = 0.0;
  time_is_allocated2[i] = 0.0;
  switch_delay[i] = 0.0;
  switch_delay2[i] = 0.0;

  Node_total_send[i] = 0;
  Node_total_received[i] = 0;
  Node_total_delay[i] = 0.0;
  Node_PDR[i] = 0.0;
  Node_switch_count[i] = 0;
  Node_switch_count_receive[i] = 0;
  Node_switch_count_transmit[i] = 0;
  Node_buffer_drop[i] = 0;

  // Ad-Hoc Sync init
  adhoc_cache[i] = {};
  adhoc_own_seq[i] = 0;
  adhoc_latest_seq[i] = 0;
  adhoc_convergence_time[i] = -1;
  adhoc_tx_count[i] = 0;
  adhoc_rx_count[i] = 0;
  rpl_dio_count[i] = 0;
  rpl_dis_count[i] = 0;
  rpl_dao_count[i] = 0;
  energest_cpu[i] = 0;
  energest_lpm[i] = 0;
  energest_tx[i] = 0;
  energest_rx[i] = 0;
  energest_total[i] = 0;
}

/* ===== LOGGING ===== */
tarih = new Date();
log.log("\n" + tarih.getDate() + "/" + (tarih.getMonth() + 1) + "/" + tarih.getFullYear() +
  "  " + tarih.getHours() + ":" + tarih.getMinutes() + ":" + tarih.getSeconds() + "\n");
log.log("Total motes: " + nodeCount + "\n");

start_time = 0;

/* ===== RESULT FUNCTIONS ===== */
function printAdhocResults() {
  log.log("\n========== AD-HOC SYNC RESULTS ==========\n");

  // 1. Control Overhead
  var total_rpl_dio = 0, total_rpl_dis = 0, total_rpl_dao = 0;
  var total_adhoc_tx = 0, total_adhoc_rx = 0;
  for (var n = 1; n <= nodeCount; n++) {
    total_rpl_dio += rpl_dio_count[n];
    total_rpl_dis += rpl_dis_count[n];
    total_rpl_dao += rpl_dao_count[n];
    total_adhoc_tx += adhoc_tx_count[n];
    total_adhoc_rx += adhoc_rx_count[n];
  }
  log.log("\n--- Control Overhead ---\n");
  log.log("RPL_DIO: " + total_rpl_dio + "\n");
  log.log("RPL_DIS: " + total_rpl_dis + "\n");
  log.log("RPL_DAO: " + total_rpl_dao + "\n");
  log.log("RPL_Total: " + (total_rpl_dio + total_rpl_dis + total_rpl_dao) + "\n");
  log.log("Adhoc_TX: " + total_adhoc_tx + "\n");
  log.log("Adhoc_RX: " + total_adhoc_rx + "\n");

  // 2. Convergence Time
  log.log("\n--- Convergence Time ---\n");
  var converged_count = 0;
  var first_conv = -1, last_conv = -1, sum_conv = 0;
  for (var n = 1; n <= nodeCount; n++) {
    if (adhoc_convergence_time[n] >= 0) {
      var t_s = adhoc_convergence_time[n] / 1000000.0;
      converged_count++;
      sum_conv += t_s;
      if (first_conv < 0 || t_s < first_conv) first_conv = t_s;
      if (t_s > last_conv) last_conv = t_s;
      log.log("  Node " + n + " converged at: " + t_s.toFixed(2) + " s\n");
    }
  }
  log.log("Converged nodes: " + converged_count + "/" + nodeCount + "\n");
  if (converged_count > 0) {
    log.log("First convergence: " + first_conv.toFixed(2) + " s\n");
    log.log("Network convergence (last): " + last_conv.toFixed(2) + " s\n");
    log.log("Average convergence: " + (sum_conv / converged_count).toFixed(2) + " s\n");
  }

  // 3. Average Version Age
  log.log("\n--- Version Age (at simulation end) ---\n");
  var va_sum = 0, va_count = 0, va_max = 0;
  var va_zero = 0;
  for (var i = 1; i <= nodeCount; i++) {
    for (var j = 1; j <= nodeCount; j++) {
      if (i == j) continue;
      var cached_seq = 0;
      if (adhoc_cache[i][j] != undefined) cached_seq = adhoc_cache[i][j];
      var latest = adhoc_latest_seq[j];
      if (latest > 0) {
        var delta = latest - cached_seq;
        va_sum += delta;
        va_count++;
        if (delta > va_max) va_max = delta;
        if (delta == 0) va_zero++;
      }
    }
  }
  if (va_count > 0) {
    log.log("Avg Version Age: " + (va_sum / va_count).toFixed(2) + "\n");
    log.log("Max Version Age: " + va_max + "\n");
    log.log("Perfect pairs (delta=0): " + va_zero + "/" + va_count +
      " (" + (va_zero / va_count * 100).toFixed(1) + "%)\n");
  }

  // 4. Single-Contact Retrieval (eta_sc)
  log.log("\n--- Single-Contact Retrieval (eta_sc) ---\n");
  var eta_sum = 0;
  var eta_min = 1.0, eta_max_val = 0.0;
  for (var n = 1; n <= nodeCount; n++) {
    var known = 0;
    for (var j = 1; j <= nodeCount; j++) {
      if (j == n) continue;
      if (adhoc_cache[n][j] != undefined && adhoc_cache[n][j] > 0) known++;
    }
    var eta = known / (nodeCount - 1);
    eta_sum += eta;
    if (eta < eta_min) eta_min = eta;
    if (eta > eta_max_val) eta_max_val = eta;
    log.log("  Node " + n + ": " + (eta * 100).toFixed(1) + "% (" + known + "/" + (nodeCount - 1) + ")\n");
  }
  var eta_avg = eta_sum / nodeCount * 100;
  log.log("Avg eta_sc: " + eta_avg.toFixed(1) + "%\n");
  log.log("Min eta_sc: " + (eta_min * 100).toFixed(1) + "%\n");
  log.log("Max eta_sc: " + (eta_max_val * 100).toFixed(1) + "%\n");

  // Per-node table
  log.log("\n--- Per-Node Summary ---\n");
  log.log("Node | AdhocTX | AdhocRX | DIO | DIS | DAO | eta_sc\n");
  for (var n = 1; n <= nodeCount; n++) {
    var known = 0;
    for (var j = 1; j <= nodeCount; j++) {
      if (j != n && adhoc_cache[n][j] != undefined && adhoc_cache[n][j] > 0) known++;
    }
    var eta = (known / (nodeCount - 1) * 100).toFixed(1);
    log.log(n + " | " + adhoc_tx_count[n] + " | " + adhoc_rx_count[n] + " | " +
      rpl_dio_count[n] + " | " + rpl_dis_count[n] + " | " + rpl_dao_count[n] + " | " +
      eta + "%\n");
  }
}

function printEnergestResults() {
  log.log("\n========== ENERGEST RESULTS ==========\n");
  var sum_cpu = 0, sum_lpm = 0, sum_tx = 0, sum_rx = 0, sum_total = 0;
  for (var n = 1; n <= nodeCount; n++) {
    sum_cpu += energest_cpu[n];
    sum_lpm += energest_lpm[n];
    sum_tx += energest_tx[n];
    sum_rx += energest_rx[n];
    sum_total += energest_total[n];
  }
  log.log("Energest_CPU: " + sum_cpu + "\n");
  log.log("Energest_LPM: " + sum_lpm + "\n");
  log.log("Energest_TX: " + sum_tx + "\n");
  log.log("Energest_RX: " + sum_rx + "\n");
  log.log("Energest_Total: " + sum_total + "\n");

  log.log("\n--- Per-Node Energest (Ticks) ---\n");
  log.log("Node | CPU | LPM | TX | RX | Total\n");
  for (var n = 1; n <= nodeCount; n++) {
    log.log(n + " | " + energest_cpu[n] + " | " + energest_lpm[n] + " | " +
      energest_tx[n] + " | " + energest_rx[n] + " | " + energest_total[n] + "\n");
  }
}

function printUdpResults() {
  log.log("\n========== UDP PDR/LATENCY RESULTS ==========\n");
  var PDR = 0;
  if (totalSent > 0) PDR = (totalReceived / totalSent) * 100;
  var avgDelay = 0;
  if (totalReceived > 0) avgDelay = totaldelay / totalReceived;

  for (var i = 2; i <= nodeCount; i++) {
    var nodePDR = 0;
    if (Node_total_send[i] > 0) nodePDR = (Node_total_received[i] / Node_total_send[i]) * 100;
    var nodeAvgDelay = 0;
    if (Node_total_received[i] > 0) nodeAvgDelay = Node_total_delay[i] / Node_total_received[i];
    log.log("ID: " + i +
      " TX: " + Node_total_send[i] +
      " RX: " + Node_total_received[i] +
      " PDR: " + nodePDR.toFixed(1) + "%" +
      " AvgDelay: " + nodeAvgDelay.toFixed(1) + "ms" +
      " Switches: " + Node_switch_count[i] +
      " BufDrop: " + Node_buffer_drop[i] + "\n");
  }

  log.log("\nTotal TX: " + totalSent +
    " RX: " + totalReceived +
    " PDR: " + PDR.toFixed(2) + "%" +
    " AvgDelay: " + avgDelay.toFixed(2) + "ms" +
    " BufferDrop: " + totalBufferDrop + "\n");
}

/* ===== Parse ADHOC_SYNC table line ===== */
function parseAdhocSync(nodeID, message) {
  // Format: "ADHOC_SYNC: 3 [1:5] [2:4] [3:8]"
  var match = message.match(/ADHOC_SYNC:\s+(\d+)(.*)/);
  if (match == null) return;

  var observerID = parseInt(match[1]);
  var entriesStr = match[2];

  // Record first time
  if (adhoc_first_time < 0) adhoc_first_time = time;

  // Parse [id:seq] entries
  var entryPattern = /\[(\d+):(\d+)\]/g;
  var m;
  while ((m = entryPattern.exec(entriesStr)) != null) {
    var targetID = parseInt(m[1]);
    var seq = parseInt(m[2]);

    // Update cache
    if (targetID >= 1 && targetID <= nodeCount) {
      adhoc_cache[observerID][targetID] = seq;

      // Update global latest
      if (seq > adhoc_latest_seq[targetID]) {
        adhoc_latest_seq[targetID] = seq;
      }

      // Update own seq tracking
      if (targetID == observerID) {
        adhoc_own_seq[observerID] = seq;
      }
    }
  }

  // Check convergence for this observer
  if (adhoc_convergence_time[observerID] < 0) {
    var allKnown = true;
    for (var j = 1; j <= nodeCount; j++) {
      if (j == observerID) continue;
      if (adhoc_cache[observerID][j] == undefined || adhoc_cache[observerID][j] <= 0) {
        allKnown = false;
        break;
      }
    }
    if (allKnown) {
      adhoc_convergence_time[observerID] = time - start_time;
      log.log("*** Node " + observerID + " CONVERGED at " +
        (adhoc_convergence_time[observerID] / 1000000.0).toFixed(2) + " s ***\n");

      // Check network-wide convergence
      if (!network_converged) {
        var allConverged = true;
        for (var n = 1; n <= nodeCount; n++) {
          if (adhoc_convergence_time[n] < 0) {
            allConverged = false;
            break;
          }
        }
        if (allConverged) {
          network_converged = true;
          network_convergence_time = time - start_time;
          log.log("*** NETWORK CONVERGED at " +
            (network_convergence_time / 1000000.0).toFixed(2) + " s ***\n");
        }
      }
    }
  }
}

/* ===== MAIN LOOP ===== */
start_time = time;
last_report_time = 0;
REPORT_INTERVAL = 300000000; /* 5 dakika = 300 saniye = 300000000 us */

while (1) {

  YIELD();

  /* ===== Periyodik Sonuç Raporlama (her 5 dk) ===== */
  if (time - last_report_time > REPORT_INTERVAL) {
    log.log("\n\n===== PERIODIC REPORT at " + (time / 1000000.0).toFixed(1) + " s =====\n");
    printAdhocResults();
    printEnergestResults();
    printUdpResults();
    log.log("===== END REPORT =====\n");
    last_report_time = time;
  }

  str = msg.replace(/  +/g, ' ');
  msgArray = str.split(' ');

  /* ===== ENERGEST PARSING ===== */
  if (msg.indexOf("[INFO: Energest  ]") >= 0) {
    if (msg.indexOf("CPU") >= 0) {
      var m = msg.match(/CPU\s+:\s+(\d+)/);
      if (m) energest_cpu[id] += parseInt(m[1]);
    } else if (msg.indexOf("LPM") >= 0 && msg.indexOf("Deep") < 0) {
      var m = msg.match(/LPM\s+:\s+(\d+)/);
      if (m) energest_lpm[id] += parseInt(m[1]);
    } else if (msg.indexOf("Radio Tx") >= 0) {
      var m = msg.match(/Radio Tx\s+:\s+(\d+)/);
      if (m) energest_tx[id] += parseInt(m[1]);
    } else if (msg.indexOf("Radio Rx") >= 0) {
      var m = msg.match(/Radio Rx\s+:\s+(\d+)/);
      if (m) energest_rx[id] += parseInt(m[1]);
    } else if (msg.indexOf("Total time") >= 0) {
      var m = msg.match(/Total time\s+:\s+(\d+)/);
      if (m) energest_total[id] += parseInt(m[1]);
    }
  }

  /* ===== AD-HOC SYNC PARSING ===== */

  // ADHOC_SYNC table dump
  if (msg.indexOf("ADHOC_SYNC:") >= 0) {
    parseAdhocSync(id, msg);
  }

  // Adhoc TX counting (sadece "sent via radio" say — enqueued her zaman sent'e dönüşmeyebilir)
  if (msg.indexOf("ADHOC TX") >= 0) {
    adhoc_tx_count[id]++;
  }

  // Adhoc RX counting
  if (msg.indexOf("Received adhoc frame") >= 0) {
    adhoc_rx_count[id]++;
  }

  // RPL counting — gerçek log formatları:
  //   "[INFO: RPL       ] Sending a multicast-DIO with rank 256"
  //   "[INFO: RPL       ] Sending a DIS to ff02::1a"
  //   "[INFO: RPL       ] Sending a DAO with sequence number 241..."
  if (msg.indexOf("multicast-DIO") >= 0) {
    rpl_dio_count[id]++;
  }
  if (msg.indexOf("Sending a DIS") >= 0) {
    rpl_dis_count[id]++;
  }
  if (msg.indexOf("Sending a DAO") >= 0) {
    rpl_dao_count[id]++;
  }

  /* ===== UDP PDR / LATENCY PARSING (mevcut) ===== */
  if (msgArray.length > 4) {

    // Time master switch
    if (msgArray[3] == "Time" && msgArray[4] == "master") {
      parent_switch_count++;
      Node_switch_count[id]++;
      flag[id] = 1;
      flag2[id] = 1;
      time_master_is_changed[id] = time;
    }

    // Slot allocation - Receive
    if (flag[id] == 1 && msgArray.length > 8) {
      if (msgArray[4] == "is" && msgArray[5] == "allocated" && msgArray[8] == "Receive") {
        parent_switch_count2++;
        Node_switch_count_receive[id]++;
        time_is_allocated[id] = time;
        switch_delay[id] = (time_is_allocated[id] - time_master_is_changed[id]) / 1000;
        total_switch_delay += switch_delay[id];
        flag[id] = 0;
      }
    }

    // Slot allocation - Transmit
    if (flag2[id] == 1 && msgArray.length > 8) {
      if (msgArray[4] == "is" && msgArray[5] == "allocated" && msgArray[8] == "Transmit") {
        parent_switch_count3++;
        Node_switch_count_transmit[id]++;
        time_is_allocated2[id] = time;
        switch_delay2[id] = (time_is_allocated2[id] - time_master_is_changed[id]) / 1000;
        total_switch_delay2 += switch_delay2[id];
        flag2[id] = 0;
      }
    }

    // Received HELLO (at server)
    if (msgArray[3] == "Received" && msgArray[4] == "HELLO") {
      var lastStr = msgArray[7];
      if (lastStr != undefined) {
        var last = lastStr.substring(lastStr.lastIndexOf(":") + 1, lastStr.length);
        var senderID = parseInt(last, 16);

        if (senderID >= 2 && senderID <= nodeCount) {
          Node_total_received[senderID]++;
          timeReceived[senderID] = time;
          totalReceived++;

          if (timeReceived[senderID] > 0 && timeSent[senderID] > 0) {
            delay[senderID] = (timeReceived[senderID] - timeSent[senderID]) / 1000;
            if (delay[senderID] > 0) {
              Node_total_delay[senderID] += delay[senderID];
              totaldelay += delay[senderID];
            }
          }

          if (totalSent > 0) {
            Node_PDR[senderID] = (Node_total_received[senderID] / Node_total_send[senderID]) * 100;
          }
        }
      }
    }

    // Sending HELLO (at client)
    if (msgArray[3] == "Sending" && msgArray[4] == "HELLO") {
      totalSent++;
      Node_total_send[id]++;
      timeSent[id] = time;
    }

    // Buffer Drop
    if (msgArray[3] == "Drop" && msgArray[4] == "DN") {
      if (id != 1) {
        totalBufferDrop++;
        Node_buffer_drop[id]++;
      }
    }
  }
}
