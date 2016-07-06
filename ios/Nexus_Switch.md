adcn5ka# sho ip ospf nei
 OSPF Process ID 10 VRF default
 Total number of neighbors: 1
 Neighbor ID     Pri State            Up Time  Address         Interface
 10.0.111.10       1 FULL/DR          00:08:45 1.1.1.2         Eth1/8




adcn5ka# sho run int eth 1/8

!Command: show running-config interface Ethernet1/8
!Time: Wed Jul  6 00:16:22 2016

version 5.1(3)N1(1a)

interface Ethernet1/8
  no switchport
  speed 1000
  mtu 9216
  ip address 1.1.1.1/30
  ip router ospf 10 area 0.0.0.0



HTP-NEXUS01# sho ip ospf nei
 OSPF Process ID 10 VRF default
 Total number of neighbors: 7
 Neighbor ID     Pri State            Up Time  Address         Interface
 10.0.111.11       1 FULL/DR          7w0d     10.0.114.3      Vlan114
 10.0.111.11       1 FULL/DR          7w0d     10.0.113.3      Vlan113
 10.0.111.11       1 FULL/DR          7w0d     10.0.112.3      Vlan112
 10.0.111.11       1 FULL/DR          7w0d     10.0.111.3      Vlan111
 10.0.111.11       1 FULL/DR          7w0d     10.0.110.3      Vlan110
 10.0.9.2          1 FULL/BDR         00:37:15 1.1.1.1         Eth1/47
 10.0.111.11       1 FULL/DR          7w0d     1.1.1.6         Eth1/54
HTP-NEXUS01# sho run int eth1/47

!Command: show running-config interface Ethernet1/47
!Time: Wed Jul  6 00:19:38 2016

version 7.0(3)I2(2)

interface Ethernet1/47
  no switchport
  mtu 9216
  ip address 1.1.1.2/30
  ip router ospf 10 area 0.0.0.0
  no shutdown