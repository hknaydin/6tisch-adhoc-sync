<?xml version="1.0" encoding="UTF-8"?>
<simconf>
  <project EXPORT="discard">[APPS_DIR]/mrm</project>
  <project EXPORT="discard">[APPS_DIR]/mspsim</project>
  <project EXPORT="discard">[APPS_DIR]/avrora</project>
  <project EXPORT="discard">[APPS_DIR]/serial_socket</project>
  <project EXPORT="discard">[APPS_DIR]/powertracker</project>
  <project EXPORT="discard">[APPS_DIR]/mobility</project>
  <simulation>
    <title>My simulation</title>
    <speedlimit>0.1</speedlimit>
    <randomseed>160736</randomseed>
    <motedelay_us>1000000</motedelay_us>
    <radiomedium>
      org.contikios.cooja.radiomediums.UDGM
      <transmitting_range>1000.0</transmitting_range>
      <interference_range>2000.0</interference_range>
      <success_ratio_tx>1.0</success_ratio_tx>
      <success_ratio_rx>1.0</success_ratio_rx>
    </radiomedium>
    <events>
      <logoutput>80000</logoutput>
    </events>
    <motetype>
      org.contikios.cooja.mspmote.Exp5438MoteType
      <identifier>exp5438#1</identifier>
      <description>Exp5438 Mote Type exp5438#1</description>
      <source EXPORT="discard">[CONTIKI_DIR]/examples/tsch/rpl-udp/border-router-server/border-router-server.c</source>
      <commands EXPORT="discard">make border-router-server.exp5438 TARGET=exp5438</commands>
      <firmware EXPORT="copy">[CONTIKI_DIR]/examples/tsch/rpl-udp/border-router-server/border-router-server.exp5438</firmware>
      <moteinterface>org.contikios.cooja.interfaces.Position</moteinterface>
      <moteinterface>org.contikios.cooja.interfaces.RimeAddress</moteinterface>
      <moteinterface>org.contikios.cooja.interfaces.IPAddress</moteinterface>
      <moteinterface>org.contikios.cooja.interfaces.Mote2MoteRelations</moteinterface>
      <moteinterface>org.contikios.cooja.interfaces.MoteAttributes</moteinterface>
      <moteinterface>org.contikios.cooja.mspmote.interfaces.MspClock</moteinterface>
      <moteinterface>org.contikios.cooja.mspmote.interfaces.MspMoteID</moteinterface>
      <moteinterface>org.contikios.cooja.mspmote.interfaces.Msp802154Radio</moteinterface>
      <moteinterface>org.contikios.cooja.mspmote.interfaces.UsciA1Serial</moteinterface>
      <moteinterface>org.contikios.cooja.mspmote.interfaces.Exp5438LED</moteinterface>
      <moteinterface>org.contikios.cooja.mspmote.interfaces.MspDebugOutput</moteinterface>
    </motetype>
    <motetype>
      org.contikios.cooja.mspmote.Exp5438MoteType
      <identifier>exp5438#2</identifier>
      <description>Exp5438 Mote Type exp5438#2</description>
      <source EXPORT="discard">[CONTIKI_DIR]/examples/tsch/rpl-udp/border-router-client/border-router-client.c</source>
      <commands EXPORT="discard">make border-router-client.exp5438 TARGET=exp5438</commands>
      <firmware EXPORT="copy">[CONTIKI_DIR]/examples/tsch/rpl-udp/border-router-client/border-router-client.exp5438</firmware>
      <moteinterface>org.contikios.cooja.interfaces.Position</moteinterface>
      <moteinterface>org.contikios.cooja.interfaces.RimeAddress</moteinterface>
      <moteinterface>org.contikios.cooja.interfaces.IPAddress</moteinterface>
      <moteinterface>org.contikios.cooja.interfaces.Mote2MoteRelations</moteinterface>
      <moteinterface>org.contikios.cooja.interfaces.MoteAttributes</moteinterface>
      <moteinterface>org.contikios.cooja.mspmote.interfaces.MspClock</moteinterface>
      <moteinterface>org.contikios.cooja.mspmote.interfaces.MspMoteID</moteinterface>
      <moteinterface>org.contikios.cooja.mspmote.interfaces.Msp802154Radio</moteinterface>
      <moteinterface>org.contikios.cooja.mspmote.interfaces.UsciA1Serial</moteinterface>
      <moteinterface>org.contikios.cooja.mspmote.interfaces.Exp5438LED</moteinterface>
      <moteinterface>org.contikios.cooja.mspmote.interfaces.MspDebugOutput</moteinterface>
    </motetype>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>836.2689514049089</x>
        <y>1658.831316844241</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>1</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>873.4797270165677</x>
        <y>2725.11997078752</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>2</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>2050.1251073562453</x>
        <y>1663.6813385441192</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>3</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>2869.9572903238914</x>
        <y>1822.8176960711921</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>4</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>283.9725493930409</x>
        <y>2793.5162131550987</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>5</id>
      </interface_config>
      <motetype_identifier>exp5438#1</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>2765.9074801623483</x>
        <y>2885.4855158641913</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>6</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>1085.0368653667963</x>
        <y>1378.3842740878351</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>7</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>1003.142669175048</x>
        <y>1096.8100174604367</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>8</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>2331.7550393734373</x>
        <y>364.5365388587875</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>9</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>361.2954809051245</x>
        <y>1700.5902457478537</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>10</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>1176.307427535464</x>
        <y>574.4854885781339</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>11</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>193.61805430216054</x>
        <y>1146.262088804091</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>12</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>611.5513265511839</x>
        <y>2145.1371013616717</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>13</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>906.3955934102007</x>
        <y>699.1824361267195</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>14</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>1892.2526499113892</x>
        <y>2275.142073935356</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>15</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>1201.4661627575708</x>
        <y>2194.5413482697836</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>16</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>460.4416003362601</x>
        <y>1924.6375907527008</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>17</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>2820.80336525408</x>
        <y>1532.5154800289256</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>18</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>1819.6099994690246</x>
        <y>1158.0020439040038</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>19</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>727.3070706886721</x>
        <y>1133.618224271924</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>20</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>1571.2944956659405</x>
        <y>78.70126214672813</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>21</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>2610.3974362304552</x>
        <y>2227.909685995313</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>22</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>2013.1864905891991</x>
        <y>981.9736946917689</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>23</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>32.47143962748878</x>
        <y>2017.580288400977</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>24</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>2134.3878730345164</x>
        <y>2592.397275365131</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>25</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>223.1379112912424</x>
        <y>328.9710198965615</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>26</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>344.3057779239077</x>
        <y>2473.7938276777277</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>27</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>1791.5187320698126</x>
        <y>777.1872401839639</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>28</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>2680.82916042643</x>
        <y>2129.7069032492395</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>29</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>94.69078085747218</x>
        <y>2422.1306902005863</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>30</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>2837.4502193195253</x>
        <y>2498.3312399073666</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>31</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>1707.9977296710572</x>
        <y>2769.7821486170888</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>32</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>2442.892581126627</x>
        <y>2786.0023470797037</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>33</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>1302.2437919318847</x>
        <y>1993.5062623582148</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>34</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>2549.7252368831614</x>
        <y>2151.5257045959574</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>35</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>635.6408610750032</x>
        <y>1838.1110215596084</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>36</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>2083.1427224287404</x>
        <y>2640.9532749386635</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>37</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>1572.0277772297875</x>
        <y>1410.67007929584</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>38</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>2363.4859214596086</x>
        <y>1548.2257697996845</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>39</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>2339.49914554428</x>
        <y>2534.048158812866</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>40</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
    <mote>
      <breakpoints />
      <interface_config>
        org.contikios.cooja.interfaces.Position
        <x>7.942673405419143</x>
        <y>1537.896465992249</y>
        <z>0.0</z>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspClock
        <deviation>1.0</deviation>
      </interface_config>
      <interface_config>
        org.contikios.cooja.mspmote.interfaces.MspMoteID
        <id>41</id>
      </interface_config>
      <motetype_identifier>exp5438#2</motetype_identifier>
    </mote>
  </simulation>
  <plugin>
    org.contikios.cooja.plugins.SimControl
    <width>280</width>
    <z>3</z>
    <height>160</height>
    <location_x>1063</location_x>
    <location_y>3</location_y>
  </plugin>
  <plugin>
    org.contikios.cooja.plugins.Visualizer
    <plugin_config>
      <moterelations>true</moterelations>
      <skin>org.contikios.cooja.plugins.skins.IDVisualizerSkin</skin>
      <skin>org.contikios.cooja.plugins.skins.GridVisualizerSkin</skin>
      <skin>org.contikios.cooja.plugins.skins.TrafficVisualizerSkin</skin>
      <skin>org.contikios.cooja.plugins.skins.UDGMVisualizerSkin</skin>
      <viewport>5.9854974523778015 0.0 0.0 5.9854974523778015 117.08800577919693 -12.753310203908027</viewport>
    </plugin_config>
    <width>1058</width>
    <z>2</z>
    <height>938</height>
    <location_x>1</location_x>
    <location_y>1</location_y>
  </plugin>
  <plugin>
    org.contikios.cooja.plugins.LogListener
    <plugin_config>
      <filter />
      <formatted_time />
      <coloring />
    </plugin_config>
    <width>585</width>
    <z>5</z>
    <height>240</height>
    <location_x>1061</location_x>
    <location_y>160</location_y>
  </plugin>
  <plugin>
    org.contikios.cooja.plugins.TimeLine
    <plugin_config>
      <mote>0</mote>
      <mote>1</mote>
      <mote>2</mote>
      <mote>3</mote>
      <mote>4</mote>
      <mote>5</mote>
      <mote>6</mote>
      <mote>7</mote>
      <mote>8</mote>
      <mote>9</mote>
      <mote>10</mote>
      <mote>11</mote>
      <mote>12</mote>
      <mote>13</mote>
      <mote>14</mote>
      <mote>15</mote>
      <mote>16</mote>
      <mote>17</mote>
      <mote>18</mote>
      <mote>19</mote>
      <mote>20</mote>
      <mote>21</mote>
      <mote>22</mote>
      <mote>23</mote>
      <mote>24</mote>
      <mote>25</mote>
      <mote>26</mote>
      <mote>27</mote>
      <mote>28</mote>
      <mote>29</mote>
      <mote>30</mote>
      <mote>31</mote>
      <mote>32</mote>
      <mote>33</mote>
      <mote>34</mote>
      <mote>35</mote>
      <mote>36</mote>
      <mote>37</mote>
      <mote>38</mote>
      <mote>39</mote>
      <mote>40</mote>
      <showRadioRXTX />
      <showRadioHW />
      <showLEDs />
      <zoomfactor>500.0</zoomfactor>
    </plugin_config>
    <width>1646</width>
    <z>6</z>
    <height>166</height>
    <location_x>0</location_x>
    <location_y>820</location_y>
  </plugin>
  <plugin>
    PowerTracker
    <width>400</width>
    <z>4</z>
    <height>400</height>
    <location_x>1251</location_x>
    <location_y>370</location_y>
  </plugin>
  <plugin>
    org.contikios.cooja.plugins.ScriptRunner
    <plugin_config>
      <script>/*
 * Cooja ScriptRunner Test Script
 * Ad-Hoc Sync Metrics + Standard UDP PDR/Latency
 * 
 * Bu scripti Cooja &gt; ScriptRunner plugin'ine kopyalayın.
 * border-router-server (ID=1) + 30x border-router-client (ID=2..31)
 * 
 * Hesaplanan Metrikler:
 *   1. Control Overhead (RPL DIO/DIS/DAO + Adhoc TX/RX)
 *   2. Convergence Time (tüm node'lar tüm diğer node'ları öğrenene kadar)
 *   3. Average Version Age (seq farkı)
 *   4. Single-Contact Retrieval (η_sc)
 *   5. UDP PDR / Latency (mevcut metrikler)
 */

/* ===== TIMEOUT (60 dakika = 3600000 ms) ===== */
TIMEOUT(3800000);

/* ===== CONFIGURATION ===== */
serverID = 5;
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
for (i = 1; i &lt;= nodeCount; i++) {
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
  for (var n = 1; n &lt;= nodeCount; n++) {
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
  for (var n = 1; n &lt;= nodeCount; n++) {
    if (adhoc_convergence_time[n] &gt;= 0) {
      var t_s = adhoc_convergence_time[n] / 1000000.0;
      converged_count++;
      sum_conv += t_s;
      if (first_conv &lt; 0 || t_s &lt; first_conv) first_conv = t_s;
      if (t_s &gt; last_conv) last_conv = t_s;
      log.log("  Node " + n + " converged at: " + t_s.toFixed(2) + " s\n");
    }
  }
  log.log("Converged nodes: " + converged_count + "/" + nodeCount + "\n");
  if (converged_count &gt; 0) {
    log.log("First convergence: " + first_conv.toFixed(2) + " s\n");
    log.log("Network convergence (last): " + last_conv.toFixed(2) + " s\n");
    log.log("Average convergence: " + (sum_conv / converged_count).toFixed(2) + " s\n");
  }

  // 3. Average Version Age
  log.log("\n--- Version Age (at simulation end) ---\n");
  var va_sum = 0, va_count = 0, va_max = 0;
  var va_zero = 0;
  for (var i = 1; i &lt;= nodeCount; i++) {
    for (var j = 1; j &lt;= nodeCount; j++) {
      if (i == j) continue;
      var cached_seq = 0;
      if (adhoc_cache[i][j] != undefined) cached_seq = adhoc_cache[i][j];
      var latest = adhoc_latest_seq[j];
      if (latest &gt; 0) {
        var delta = latest - cached_seq;
        va_sum += delta;
        va_count++;
        if (delta &gt; va_max) va_max = delta;
        if (delta == 0) va_zero++;
      }
    }
  }
  if (va_count &gt; 0) {
    log.log("Avg Version Age: " + (va_sum / va_count).toFixed(2) + "\n");
    log.log("Max Version Age: " + va_max + "\n");
    log.log("Perfect pairs (delta=0): " + va_zero + "/" + va_count +
      " (" + (va_zero / va_count * 100).toFixed(1) + "%)\n");
  }

  // 4. Single-Contact Retrieval (eta_sc)
  log.log("\n--- Single-Contact Retrieval (eta_sc) ---\n");
  var eta_sum = 0;
  var eta_min = 1.0, eta_max_val = 0.0;
  for (var n = 1; n &lt;= nodeCount; n++) {
    var known = 0;
    for (var j = 1; j &lt;= nodeCount; j++) {
      if (j == n) continue;
      if (adhoc_cache[n][j] != undefined &amp;&amp; adhoc_cache[n][j] &gt; 0) known++;
    }
    var eta = known / (nodeCount - 1);
    eta_sum += eta;
    if (eta &lt; eta_min) eta_min = eta;
    if (eta &gt; eta_max_val) eta_max_val = eta;
    log.log("  Node " + n + ": " + (eta * 100).toFixed(1) + "% (" + known + "/" + (nodeCount - 1) + ")\n");
  }
  var eta_avg = eta_sum / nodeCount * 100;
  log.log("Avg eta_sc: " + eta_avg.toFixed(1) + "%\n");
  log.log("Min eta_sc: " + (eta_min * 100).toFixed(1) + "%\n");
  log.log("Max eta_sc: " + (eta_max_val * 100).toFixed(1) + "%\n");

  // Per-node table
  log.log("\n--- Per-Node Summary ---\n");
  log.log("Node | AdhocTX | AdhocRX | DIO | DIS | DAO | eta_sc\n");
  for (var n = 1; n &lt;= nodeCount; n++) {
    var known = 0;
    for (var j = 1; j &lt;= nodeCount; j++) {
      if (j != n &amp;&amp; adhoc_cache[n][j] != undefined &amp;&amp; adhoc_cache[n][j] &gt; 0) known++;
    }
    var eta = (known / (nodeCount - 1) * 100).toFixed(1);
    log.log(n + " | " + adhoc_tx_count[n] + " | " + adhoc_rx_count[n] + " | " +
      rpl_dio_count[n] + " | " + rpl_dis_count[n] + " | " + rpl_dao_count[n] + " | " +
      eta + "%\n");
  }
}

/* Energest Hardware Parameters (from Table for Exp5438) */
var V = 3.0;
var I_CPU = 1.9;      /* mA */
var I_LPM = 0.0545;   /* mA */
var I_TX = 20.0;      /* mA */
var I_RX = 17.7;      /* mA */

function printEnergestResults() {
  log.log("\n========== ENERGEST RESULTS ==========\n");
  var sum_cpu = 0, sum_lpm = 0, sum_tx = 0, sum_rx = 0, sum_total = 0;
  for (var n = 1; n &lt;= nodeCount; n++) {
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

  var p_cpu = 0, p_lpm = 0, p_tx = 0, p_rx = 0, p_total = 0;
  if (sum_total &gt; 0) {
    p_cpu = (sum_cpu / sum_total) * I_CPU * V;
    p_lpm = (sum_lpm / sum_total) * I_LPM * V;
    p_tx  = (sum_tx / sum_total) * I_TX * V;
    p_rx  = (sum_rx / sum_total) * I_RX * V;
    p_total = p_cpu + p_lpm + p_tx + p_rx;
  }

  log.log("\n--- Network Average Power ---\n");
  log.log("Power_CPU: " + p_cpu.toFixed(4) + "\n");
  log.log("Power_LPM: " + p_lpm.toFixed(4) + "\n");
  log.log("Power_TX: " + p_tx.toFixed(4) + "\n");
  log.log("Power_RX: " + p_rx.toFixed(4) + "\n");
  log.log("Power_Total: " + p_total.toFixed(4) + "\n");

  log.log("\n--- Per-Node Power (mW) ---\n");
  log.log("Node | CPU | LPM | TX | RX | Total (mW)\n");
  for (var n = 1; n &lt;= nodeCount; n++) {
    var np_cpu = 0, np_lpm = 0, np_tx = 0, np_rx = 0, np_total = 0;
    var tot = energest_total[n];
    if (tot &gt; 0) {
      np_cpu = (energest_cpu[n] / tot) * I_CPU * V;
      np_lpm = (energest_lpm[n] / tot) * I_LPM * V;
      np_tx  = (energest_tx[n] / tot) * I_TX * V;
      np_rx  = (energest_rx[n] / tot) * I_RX * V;
      np_total = np_cpu + np_lpm + np_tx + np_rx;
    }
    log.log(n + " | " + np_cpu.toFixed(4) + " | " + np_lpm.toFixed(4) + " | " +
      np_tx.toFixed(4) + " | " + np_rx.toFixed(4) + " | " + np_total.toFixed(4) + "\n");
  }
}

function printUdpResults() {
  log.log("\n========== UDP PDR/LATENCY RESULTS ==========\n");
  var PDR = 0;
  if (totalSent &gt; 0) PDR = (totalReceived / totalSent) * 100;
  var avgDelay = 0;
  if (totalReceived &gt; 0) avgDelay = totaldelay / totalReceived;

  for (var i = 1; i &lt;= nodeCount; i++) {
    if (i == serverID) continue;
    var nodePDR = 0;
    if (Node_total_send[i] &gt; 0) nodePDR = (Node_total_received[i] / Node_total_send[i]) * 100;
    var nodeAvgDelay = 0;
    if (Node_total_received[i] &gt; 0) nodeAvgDelay = Node_total_delay[i] / Node_total_received[i];
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

  var unique_nodes_retrieved = 0;
  for (var i = 1; i &lt;= nodeCount; i++) {
    if (i == serverID) continue;
    var is_cached = (adhoc_cache[serverID][i] != undefined &amp;&amp; adhoc_cache[serverID][i] &gt; 0);
    var is_received_direct = (Node_total_received[i] &gt; 0);
    if (is_cached || is_received_direct) {
      unique_nodes_retrieved++;
    }
  }
  var eta_sink = (unique_nodes_retrieved / (nodeCount - 1)) * 100;
  log.log("Unique Nodes Retrieved at Sink: " + unique_nodes_retrieved + 
    "/" + (nodeCount - 1) + " (" + eta_sink.toFixed(2) + "%)\n");
}

/* ===== Parse ADHOC_SYNC table line ===== */
function parseAdhocSync(nodeID, message) {
  // Format: "ADHOC_SYNC: 3 [1:5] [2:4] [3:8]"
  var match = message.match(/ADHOC_SYNC:\s+(\d+)(.*)/);
  if (match == null) return;

  var observerID = parseInt(match[1]);
  var entriesStr = match[2];

  // Record first time
  if (adhoc_first_time &lt; 0) adhoc_first_time = time;

  // Parse [id:seq] entries
  var entryPattern = /\[(\d+):(\d+)\]/g;
  var m;
  while ((m = entryPattern.exec(entriesStr)) != null) {
    var targetID = parseInt(m[1]);
    var seq = parseInt(m[2]);

    // Update cache
    if (targetID &gt;= 1 &amp;&amp; targetID &lt;= nodeCount) {
      adhoc_cache[observerID][targetID] = seq;

      // Update global latest
      if (seq &gt; adhoc_latest_seq[targetID]) {
        adhoc_latest_seq[targetID] = seq;
      }

      // Update own seq tracking
      if (targetID == observerID) {
        adhoc_own_seq[observerID] = seq;
      }
    }
  }

  // Check convergence for this observer
  if (adhoc_convergence_time[observerID] &lt; 0) {
    var allKnown = true;
    for (var j = 1; j &lt;= nodeCount; j++) {
      if (j == observerID) continue;
      if (adhoc_cache[observerID][j] == undefined || adhoc_cache[observerID][j] &lt;= 0) {
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
        for (var n = 1; n &lt;= nodeCount; n++) {
          if (adhoc_convergence_time[n] &lt; 0) {
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
  if (time - last_report_time &gt; REPORT_INTERVAL) {
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
  if (msg.indexOf("[INFO: Energest  ]") &gt;= 0) {
    if (msg.indexOf("CPU") &gt;= 0) {
      var m = msg.match(/CPU\s+:\s+(\d+)/);
      if (m) energest_cpu[id] += parseInt(m[1]);
    } else if (msg.indexOf("LPM") &gt;= 0 &amp;&amp; msg.indexOf("Deep") &lt; 0) {
      var m = msg.match(/LPM\s+:\s+(\d+)/);
      if (m) energest_lpm[id] += parseInt(m[1]);
    } else if (msg.indexOf("Radio Tx") &gt;= 0) {
      var m = msg.match(/Radio Tx\s+:\s+(\d+)/);
      if (m) energest_tx[id] += parseInt(m[1]);
    } else if (msg.indexOf("Radio Rx") &gt;= 0) {
      var m = msg.match(/Radio Rx\s+:\s+(\d+)/);
      if (m) energest_rx[id] += parseInt(m[1]);
    } else if (msg.indexOf("Total time") &gt;= 0) {
      var m = msg.match(/Total time\s+:\s+(\d+)/);
      if (m) energest_total[id] += parseInt(m[1]);
    }
  }

  /* ===== AD-HOC SYNC PARSING ===== */

  // ADHOC_SYNC table dump
  if (msg.indexOf("ADHOC_SYNC:") &gt;= 0) {
    parseAdhocSync(id, msg);
  }

  // Adhoc TX counting (sadece "sent via radio" say — enqueued her zaman sent'e dönüşmeyebilir)
  if (msg.indexOf("ADHOC TX") &gt;= 0) {
    adhoc_tx_count[id]++;
  }

  // Adhoc RX counting
  if (msg.indexOf("Received adhoc frame") &gt;= 0) {
    adhoc_rx_count[id]++;
  }

  // RPL counting — gerçek log formatları:
  //   "[INFO: RPL       ] Sending a multicast-DIO with rank 256"
  //   "[INFO: RPL       ] Sending a DIS to ff02::1a"
  //   "[INFO: RPL       ] Sending a DAO with sequence number 241..."
  if (msg.indexOf("multicast-DIO") &gt;= 0) {
    rpl_dio_count[id]++;
  }
  if (msg.indexOf("Sending a DIS") &gt;= 0) {
    rpl_dis_count[id]++;
  }
  if (msg.indexOf("Sending a DAO") &gt;= 0) {
    rpl_dao_count[id]++;
  }

  /* ===== UDP PDR / LATENCY PARSING (mevcut) ===== */
  if (msgArray.length &gt; 4) {

    // Time master switch
    if (msgArray[3] == "Time" &amp;&amp; msgArray[4] == "master") {
      parent_switch_count++;
      Node_switch_count[id]++;
      flag[id] = 1;
      flag2[id] = 1;
      time_master_is_changed[id] = time;
    }

    // Slot allocation - Receive
    if (flag[id] == 1 &amp;&amp; msgArray.length &gt; 8) {
      if (msgArray[4] == "is" &amp;&amp; msgArray[5] == "allocated" &amp;&amp; msgArray[8] == "Receive") {
        parent_switch_count2++;
        Node_switch_count_receive[id]++;
        time_is_allocated[id] = time;
        switch_delay[id] = (time_is_allocated[id] - time_master_is_changed[id]) / 1000;
        total_switch_delay += switch_delay[id];
        flag[id] = 0;
      }
    }

    // Slot allocation - Transmit
    if (flag2[id] == 1 &amp;&amp; msgArray.length &gt; 8) {
      if (msgArray[4] == "is" &amp;&amp; msgArray[5] == "allocated" &amp;&amp; msgArray[8] == "Transmit") {
        parent_switch_count3++;
        Node_switch_count_transmit[id]++;
        time_is_allocated2[id] = time;
        switch_delay2[id] = (time_is_allocated2[id] - time_master_is_changed[id]) / 1000;
        total_switch_delay2 += switch_delay2[id];
        flag2[id] = 0;
      }
    }

    // Received HELLO (at server)
    if (msgArray[3] == "Received" &amp;&amp; msgArray[4] == "HELLO") {
      var lastStr = msgArray[7];
      if (lastStr != undefined) {
        var last = lastStr.substring(lastStr.lastIndexOf(":") + 1, lastStr.length);
        var senderID = parseInt(last, 16);

        if (senderID &gt;= 1 &amp;&amp; senderID &lt;= nodeCount &amp;&amp; senderID != serverID) {
          Node_total_received[senderID]++;
          timeReceived[senderID] = time;
          totalReceived++;

          if (timeReceived[senderID] &gt; 0 &amp;&amp; timeSent[senderID] &gt; 0) {
            delay[senderID] = (timeReceived[senderID] - timeSent[senderID]) / 1000;
            if (delay[senderID] &gt; 0) {
              Node_total_delay[senderID] += delay[senderID];
              totaldelay += delay[senderID];
            }
          }

          if (totalSent &gt; 0) {
            Node_PDR[senderID] = (Node_total_received[senderID] / Node_total_send[senderID]) * 100;
          }
        }
      }
    }

    // Sending HELLO (at client)
    if (msgArray[3] == "Sending" &amp;&amp; msgArray[4] == "HELLO") {
      totalSent++;
      Node_total_send[id]++;
      timeSent[id] = time;
    }

    // Buffer Drop
    if (msgArray[3] == "Drop" &amp;&amp; msgArray[4] == "DN") {
      if (id != serverID) {
        totalBufferDrop++;
        Node_buffer_drop[id]++;
      }
    }
  }
}</script>
      <active>true</active>
    </plugin_config>
    <width>600</width>
    <z>1</z>
    <height>700</height>
    <location_x>1042</location_x>
    <location_y>295</location_y>
  </plugin>
  <plugin>
    Mobility
    <plugin_config>
      <positions EXPORT="copy">[APPS_DIR]/mobility/random40node_high.dat</positions>
    </plugin_config>
    <width>500</width>
    <z>0</z>
    <height>200</height>
    <location_x>1147</location_x>
    <location_y>119</location_y>
  </plugin>
</simconf>

