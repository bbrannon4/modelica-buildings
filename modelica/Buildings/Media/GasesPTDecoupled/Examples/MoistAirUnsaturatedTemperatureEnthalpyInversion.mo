within Buildings.Media.GasesPTDecoupled.Examples;
model MoistAirUnsaturatedTemperatureEnthalpyInversion
  "Model to check computation of h(T) and its inverse"
  extends Modelica.Icons.Example;
  extends Buildings.Media.BaseClasses.TestTemperatureEnthalpyInversion(
    redeclare package Medium =
        Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated);
  annotation (Commands(file="MoistAirUnsaturatedTemperatureEnthalpyInversion.mos" "run"));
end MoistAirUnsaturatedTemperatureEnthalpyInversion;
