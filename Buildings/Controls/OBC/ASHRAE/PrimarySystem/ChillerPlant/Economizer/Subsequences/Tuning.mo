within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer.Subsequences;
block Tuning
  "Defines a tuning parameter for the temperature prediction downstream of WSE"

  parameter Real step=0.02
  "Tuning step";

  parameter Modelica.SIunits.Time wseOnTimDec = 60*60
  "Economizer enable time needed to allow decrease of the tuning parameter";

  parameter Modelica.SIunits.Time wseOnTimInc = 30*60
  "Economizer enable time needed to allow increase of the tuning parameter";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWseSta
    "WSE enable disable status"
    annotation (Placement(transformation(extent={{-220,40},{-180,80}}),
        iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowFanSpe
    "Cooling tower fan speed"
    annotation (Placement(transformation(extent={{-220,-170},{-180,-130}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final max=0.5,
    final min=-0.2,
    final start=initTunPar)
    "Tuning parameter for the waterside economizer outlet temperature prediction "
    annotation (Placement(transformation(extent={{180,-10},{200,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

//protected
  final parameter Real initTunPar = 0
  "Initial value of the tuning parameter";

  Buildings.Controls.OBC.CDL.Logical.Timer tim "Timer"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg "Falling edge"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));

  Buildings.Controls.OBC.CDL.Logical.And and2 "And"
    annotation (Placement(transformation(extent={{-30,80},{-10,100}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqual greEqu "Greater or equal than"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant wseOnTim(
    final k=wseOnTimDec)
    "Check if econ was on for the defined time period"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant tunStep(
    final k=step) "Tuning step"
    annotation (Placement(transformation(extent={{-30,120},{-10,140}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam(y_start=0)
    annotation (Placement(transformation(extent={{60,100},{80,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2(final k1=-1, k2=+1)
                                                              "Add"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre "Logical pre"
    annotation (Placement(transformation(extent={{-70,80},{-50,100}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim1 "Timer"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg1 "Falling edge"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));

  CDL.Logical.And                         and1 "And"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.LessEqual lesEqu "Less equal than"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant wseOnTim1(
    final k=wseOnTimInc) "Check if econ was on for the defined time period"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam1(
    final y_start=initTunPar) "Sampler"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1 "Pre"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

  CDL.Continuous.Hysteresis                  hys(           uHigh=0.99, uLow=
        0.98) "Checks if the signal is at its maximum"
    annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam2(
    final y_start=0) "Sampler"
    annotation (Placement(transformation(extent={{-80,-160},{-60,-140}})));

  CDL.Discrete.ZeroOrderHold zerOrdHol(samplePeriod=1)
    annotation (Placement(transformation(extent={{100,100},{120,120}})));
  CDL.Continuous.Add                        add1 "Tuning parameter aggregator"
    annotation (Placement(transformation(extent={{20,120},{40,140}})));
  CDL.Discrete.ZeroOrderHold zerOrdHol1(samplePeriod=1)
    annotation (Placement(transformation(extent={{90,-30},{110,-10}})));
  CDL.Continuous.Add                        add3 "Tuning parameter aggregator"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  CDL.Continuous.GreaterThreshold                    greThr(   threshold=0.5)
                                                            "Greater or equal than"
    annotation (Placement(transformation(extent={{-40,-160},{-20,-140}})));
  CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));
  CDL.Logical.And                         and3 "And"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  CDL.Logical.FallingEdge                        falEdg2 "Falling edge"
    annotation (Placement(transformation(extent={{-120,-190},{-100,-170}})));
  CDL.Logical.Or                          and4 "And"
    annotation (Placement(transformation(extent={{-80,-200},{-60,-180}})));
equation
  connect(uWseSta, tim.u)
    annotation (Line(points={{-200,60},{-160,60},{-160,90},{-142,90}},
                                                     color={255,0,255}));
  connect(greEqu.u2, wseOnTim.y) annotation (Line(points={{-102,82},{-110,82},{
          -110,60},{-119,60}},
                         color={0,0,127}));
  connect(tim.y, greEqu.u1)
    annotation (Line(points={{-119,90},{-102,90}}, color={0,0,127}));
  connect(add2.y, y)
    annotation (Line(points={{161,0},{190,0}}, color={0,0,127}));
  connect(greEqu.y, pre.u)
    annotation (Line(points={{-79,90},{-72,90}}, color={255,0,255}));
  connect(and2.u1, pre.y)
    annotation (Line(points={{-32,90},{-49,90}},color={255,0,255}));
  connect(uWseSta, tim1.u) annotation (Line(points={{-200,60},{-160,60},{-160,
          -40},{-142,-40}},
                       color={255,0,255}));
  connect(lesEqu.u2, wseOnTim1.y) annotation (Line(points={{-102,-48},{-110,-48},
          {-110,-70},{-119,-70}},
                               color={0,0,127}));
  connect(tim1.y, lesEqu.u1)
    annotation (Line(points={{-119,-40},{-102,-40}},
                                                   color={0,0,127}));
  connect(lesEqu.y, pre1.u)
    annotation (Line(points={{-79,-40},{-62,-40}}, color={255,0,255}));
  connect(and1.u1, pre1.y) annotation (Line(points={{-22,-50},{-30,-50},{-30,
          -40},{-39,-40}},
                      color={255,0,255}));
  connect(uTowFanSpe, hys.u)
    annotation (Line(points={{-200,-150},{-162,-150}}, color={0,0,127}));
  connect(triSam.y, zerOrdHol.u)
    annotation (Line(points={{81,110},{98,110}}, color={0,0,127}));
  connect(add1.y, triSam.u) annotation (Line(points={{41,130},{50,130},{50,110},
          {58,110}}, color={0,0,127}));
  connect(zerOrdHol.y, add2.u1) annotation (Line(points={{121,110},{130,110},{
          130,6},{138,6}}, color={0,0,127}));
  connect(zerOrdHol.y, add1.u1) annotation (Line(points={{121,110},{130,110},{
          130,150},{10,150},{10,136},{18,136}}, color={0,0,127}));
  connect(tunStep.y, add1.u2) annotation (Line(points={{-9,130},{10,130},{10,
          124},{18,124}}, color={0,0,127}));
  connect(add2.u2, zerOrdHol1.y) annotation (Line(points={{138,-6},{128,-6},{
          128,-20},{111,-20}}, color={0,0,127}));
  connect(triSam1.y, zerOrdHol1.u)
    annotation (Line(points={{81,-20},{88,-20}}, color={0,0,127}));
  connect(zerOrdHol1.y, add3.u1) annotation (Line(points={{111,-20},{120,-20},{
          120,30},{10,30},{10,16},{18,16}}, color={0,0,127}));
  connect(tunStep.y, add3.u2)
    annotation (Line(points={{-9,130},{0,130},{0,4},{18,4}}, color={0,0,127}));
  connect(add3.y, triSam1.u) annotation (Line(points={{41,10},{50,10},{50,-20},
          {58,-20}}, color={0,0,127}));
  connect(triSam2.y, greThr.u)
    annotation (Line(points={{-59,-150},{-42,-150}}, color={0,0,127}));
  connect(booToRea.y, triSam2.u) annotation (Line(points={{-99,-150},{-82,-150}},
                                color={0,0,127}));
  connect(uWseSta, falEdg.u) annotation (Line(points={{-200,60},{-160,60},{-160,
          40},{-102,40}}, color={255,0,255}));
  connect(falEdg.y, and2.u2) annotation (Line(points={{-79,40},{-40,40},{-40,82},
          {-32,82}}, color={255,0,255}));
  connect(and2.y, triSam.trigger)
    annotation (Line(points={{-9,90},{70,90},{70,98.2}}, color={255,0,255}));
  connect(uWseSta, falEdg1.u) annotation (Line(points={{-200,60},{-160,60},{
          -160,-90},{-62,-90}}, color={255,0,255}));
  connect(and1.u2, falEdg1.y) annotation (Line(points={{-22,-58},{-30,-58},{-30,
          -90},{-39,-90}}, color={255,0,255}));
  connect(hys.y, booToRea.u)
    annotation (Line(points={{-139,-150},{-122,-150}}, color={255,0,255}));
  connect(and3.y, triSam1.trigger) annotation (Line(points={{61,-50},{70,-50},{
          70,-31.8}}, color={255,0,255}));
  connect(and1.y, and3.u1)
    annotation (Line(points={{1,-50},{38,-50}}, color={255,0,255}));
  connect(hys.y, falEdg2.u) annotation (Line(points={{-139,-150},{-132,-150},{
          -132,-180},{-122,-180}}, color={255,0,255}));
  connect(falEdg1.y, and4.u1) annotation (Line(points={{-39,-90},{-30,-90},{-30,
          -120},{-90,-120},{-90,-190},{-82,-190}}, color={255,0,255}));
  connect(falEdg2.y, and4.u2) annotation (Line(points={{-99,-180},{-90,-180},{
          -90,-198},{-82,-198}}, color={255,0,255}));
  connect(and4.y, triSam2.trigger) annotation (Line(points={{-59,-190},{-50,
          -190},{-50,-170},{-70,-170},{-70,-161.8}}, color={255,0,255}));
  connect(greThr.y, and3.u2) annotation (Line(points={{-19,-150},{12,-150},{12,
          -58},{38,-58}}, color={255,0,255}));
  annotation (defaultComponentName = "wseTun",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-180,-220},{180,180}})),
Documentation(info="<html>
<p>
Waterside economizer outlet temperature prediction tuning parameter subsequence 
per OBC Chilled Water Plant Sequence of Operation, section 3.2.3.3. The parameter
is increased or decreased in a <code>step</code> depending on how long the
the economizer remained enabled and the values of the cooling tower fan speed signal 
<code>uTowFanSpe</code> during that period.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 13, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Tuning;