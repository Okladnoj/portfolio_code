abstract class IGroupsModelRepository {
  final double g1;
  final double g2;
  final double g3;
  final double g4;
  final double g5;
  final double undefined;
  final double total;
  final double outside;

  IGroupsModelRepository(
    this.g1,
    this.g2,
    this.g3,
    this.g4,
    this.g5,
    this.undefined,
    this.total,
    this.outside,
  );
}

abstract class ILactationsModelRepository {
  final double bred;
  final double dry;
  final double fresh;
  final double noBred;
  final double okOpen;
  final double preg;
  final double undefined;
  final double total;
  final double outside;

  ILactationsModelRepository(
    this.bred,
    this.dry,
    this.fresh,
    this.noBred,
    this.okOpen,
    this.preg,
    this.undefined,
    this.total,
    this.outside,
  );
}
