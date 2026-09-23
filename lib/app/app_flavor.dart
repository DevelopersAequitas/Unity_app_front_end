enum AppFlavor {
  peersGlobal,
  greenpreneur,
  fempreneur;

  bool get isPeersGlobal => this == AppFlavor.peersGlobal;
  bool get isGreenpreneur => this == AppFlavor.greenpreneur;
  bool get isFempreneur => this == AppFlavor.fempreneur;
}
