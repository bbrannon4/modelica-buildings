within Buildings.Experimental.OpenBuildingControl.CDL.Conversions.Validation;
model BooleanToInteger
  "Validation model for the BooleanToInteger block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Conversions.BooleanToInteger booToInt
    "Block that convert Boolean to Integer signal"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Sources.BooleanPulse booPul(
    period = 1)
    "Generate output cyclic on and off"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

equation
  connect(booPul.y, booToInt.u)
    annotation (Line(points={{1,0},{28,0},{28,0}}, color={255,0,255}));
  annotation (
  experiment(StopTime=4.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Conversions/Validation/BooleanToInteger.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Conversions.BooleanToInteger\">
Buildings.Experimental.OpenBuildingControl.CDL.Conversions.BooleanToInteger</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 31, 2017, by Jianjun Hu:<br/>
First implementation..
</li>
</ul>

</html>"));
end BooleanToInteger;
