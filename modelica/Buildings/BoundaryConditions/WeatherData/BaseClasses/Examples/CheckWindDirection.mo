within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model CheckWindDirection "Test model for wind direction check"
  extends Modelica.Icons.Example;
  import Buildings;
  Buildings.Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
protected
  Modelica.Blocks.Tables.CombiTable1Ds datRea(
    tableOnFile=true,
    tableName="tab1",
    fileName=
        "Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos",
    columns=2:30,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    "Data reader"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
public
  Buildings.BoundaryConditions.WeatherData.BaseClasses.CheckWindDirection
    cheWinDir annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertTime conTim
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
equation
  connect(datRea.y[15], cheWinDir.nIn) annotation (Line(
      points={{1,10},{18,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(simTim.y, conTim.simTim) annotation (Line(
      points={{-79,10},{-62,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conTim.calTim, datRea.u) annotation (Line(
      points={{-39,10},{-22,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),Commands(file="CheckWindDirection.mos" "run"));
end CheckWindDirection;
