within Buildings.Experimental.OpenBuildingControl.CDL.SetPoints.Validation;
model HotWaterTemperatureReset "Test model for the heating curve"
  extends Modelica.Icons.Example;
  Buildings.Experimental.OpenBuildingControl.CDL.SetPoints.HotWaterTemperatureReset
  heaCur(
    m=1,
    TSup_nominal=333.15,
    TRet_nominal=313.15,
    TOut_nominal=263.15)
    "Compute the supply and return set point of heating systems with varying outdoor temperature"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Continuous.Sources.Ramp TOut(
    height=40,
    duration=1,
    offset=263.15) "Outdoor temperature vary from -10 degC to 30 degC"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Experimental.OpenBuildingControl.CDL.SetPoints.HotWaterTemperatureReset
  heaCur1(
    m=1,
    dTOutHeaBal=15,
    TSup_nominal=333.15,
    TRet_nominal=313.15,
    TOut_nominal=263.15)
    "Compute the supply and return set point of heating systems with  changing room setpoint temperature"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Continuous.Sources.Pulse  TRoo1(
    offset=273.15 + 20,
    startTime=0.5,
    amplitude=-5,
    period=1)  "Night set back from 20 to 15 deg C"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Continuous.Sources.Constant  TOut1(k=273.15 - 10)
    "Constant outdoor air temperature"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Continuous.Sources.Constant  TRoo(k=273.15 + 20)
    "Room temperature 20 degC"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
equation
  connect(TOut1.y, heaCur1.TOut)
    annotation (Line(points={{-39,-20},{-20,-20},{0,-20},{0,-34},{18,-34}},
      color={0,0,127}));
  connect(TOut.y, heaCur.TOut)
    annotation (Line(points={{-39,60},{-20,60},{0,60},{0,46},{18,46}},
      color={0,0,127}));
  connect(TRoo.y, heaCur.TSetZon)
    annotation (Line(points={{-39,20},{0,20},{0,34},{18.1,34}},
      color={0,0,127}));
  connect(TRoo1.y, heaCur1.TSetZon)
    annotation (Line(points={{-39,-60},{0,-60},{0,-46},{18.1,-46}},
      color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=1.0),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/SetPoints/Validation/HotWaterTemperatureReset.mos"
      "Simulate and plot"),
  Documentation(info="<html>
<p>
Example that demonstrates the use of the hot water temperature reset
for a heating system.
The parameters of the block <code>heaCur</code>
are for a heating system with
<i>60</i>&deg;C supply water temperature and
<i>40</i>&deg;C return water temperature at
an outside temperature of
<i>-10</i>&deg;C and a room temperature of
<i>20</i>&deg;C. The offset for the temperature reset is
<i>8</i> Kelvin, i.e., above
<i>12</i>&deg;C outside temperature, there is no heating load.
The figure below shows the computed supply and return water temperatures.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/CDL/SetPoints/HotWaterTemperatureReset.png\" 
border=\"1\" 
alt=\"Supply and return water temperatures.\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
July 18, 2017, by Jianjun Hu:<br/>
First implementation in CDL.
</li>
</ul>
</html>"));
end HotWaterTemperatureReset;
