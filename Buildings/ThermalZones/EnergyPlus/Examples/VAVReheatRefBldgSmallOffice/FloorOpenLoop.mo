within Buildings.ThermalZones.EnergyPlus.Examples.VAVReheatRefBldgSmallOffice;
model FloorOpenLoop "Open loop model of one floor"
  extends Modelica.Icons.Example;

  replaceable package Medium = Buildings.Media.Air "Medium for air"
    annotation (__Dymola_choicesAllMatching=true);
  final parameter Modelica.SIunits.Area AFlo=flo.AFlo "Floor area west";
  final parameter Modelica.SIunits.MassFlowRate mOut_flow = 2
    "Outside air infiltration for each room";

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
  replaceable Buildings.ThermalZones.EnergyPlus.Examples.VAVReheatRefBldgSmallOffice.BaseClasses.Floor flo(
    redeclare package Medium = Medium,
    use_windPressure=false) constrainedby
    Buildings.ThermalZones.EnergyPlus.Examples.VAVReheatRefBldgSmallOffice.BaseClasses.PartialFloor
    "One floor of the office building"
    annotation (Placement(transformation(extent={{32,-2},{86,28}})));
  Fluid.Sources.MassFlowSource_WeatherData bou[4](
    redeclare each package Medium = Medium,
    each m_flow=mOut_flow,
    each nPorts=1)
    "Infiltration, used to avoid that the absolute humidity is continuously increasing"
    annotation (Placement(transformation(extent={{-28,-30},{-8,-10}})));

  Fluid.Sources.Outside out(
    redeclare package Medium = Medium, nPorts=1)
    "Outside condition"
    annotation (Placement(transformation(extent={{-28,-64},{-8,-44}})));
  Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=mOut_flow,
    dp_nominal=10,
    linearized=true)
    annotation (Placement(transformation(extent={{6,-64},{26,-44}})));
  Fluid.FixedResistances.PressureDrop res1[4](
    redeclare each package Medium = Medium,
    each m_flow_nominal=mOut_flow,
    each dp_nominal=10,
    each linearized=true) "Small flow resistance for inlet"
    annotation (Placement(transformation(extent={{4,-30},{24,-10}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-60,50},{-40,50}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, flo.weaBus) annotation (Line(
      points={{-40,50},{66,50},{66,30.3077},{66.0435,30.3077}},
      color={255,204,51},
      thickness=0.5));
  connect(out.ports[1], res.port_a)
    annotation (Line(points={{-8,-54},{6,-54}},color={0,127,255}));
  connect(res.port_b, flo.portsCor[1])
    annotation (Line(points={{26,-54},{60,-54},{60,4},{51.7217,4},{51.7217,
          12.7692}},                                    color={0,127,255}));
  connect(weaBus, out.weaBus) annotation (Line(
      points={{-40,50},{-40,-53.8},{-28,-53.8}},
      color={255,204,51},
      thickness=0.5));
  connect(bou[:].ports[1], res1[:].port_a) annotation (Line(points={{-8,-20},{-2,
          -20},{-2,-20},{4,-20}},color={0,127,255}));
  connect(res1[1].port_b, flo.portsWes[1])
    annotation (Line(points={{24,-20},{37.1652,-20},{37.1652,12.7692}},color={0,127,255}));
  connect(res1[2].port_b, flo.portsNor[1]) annotation (Line(points={{24,-20},{
          46,-20},{46,20.6154},{51.7217,20.6154}},
                                               color={0,127,255}));
  connect(res1[3].port_b, flo.portsSou[1])
    annotation (Line(points={{24,-20},{51.7217,-20},{51.7217,4.46154}}, color={0,127,255}));
  connect(res1[4].port_b, flo.portsEas[1]) annotation (Line(points={{24,-20},{
          78.487,-20},{78.487,12.7692}},
                                  color={0,127,255}));
  connect(weaBus, bou[1].weaBus) annotation (Line(
      points={{-40,50},{-40,-19.8},{-28,-19.8}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, bou[2].weaBus) annotation (Line(
      points={{-40,50},{-40,-20},{-28,-20},{-28,-19.8}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, bou[3].weaBus) annotation (Line(
      points={{-40,50},{-40,-19.8},{-28,-19.8}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, bou[4].weaBus) annotation (Line(
      points={{-40,50},{-40,-20},{-28,-20},{-28,-19.8}},
      color={255,204,51},
      thickness=0.5));
  annotation (
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Examples/VAVReheatRefBldgSmallOffice/FloorOpenLoop.mos"
        "Simulate and plot"),
experiment(
      StopTime=172800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
Documentation(info="<html>
<p>
Test case of one floor of the small office DOE reference building.
</p>
</html>", revisions="<html>
<ul><li>
March 5, 2019, by Michael Wetter:<br/>
First implementation.
</li>
<ul><li>
March 4, 2020, by Milica Grahovac:<br/>
Declared the floor model as replaceable.
</li>
</ul>
</html>"));
end FloorOpenLoop;