within Buildings.Fluid.BaseClasses;
partial model PartialThreeWayResistance
  "Flow splitter with partial resistance model at each port"
  outer Modelica.Fluid.System system "System properties";

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Fluid medium model"
      annotation (choicesAllMatching=true);

  Modelica.Fluid.Interfaces.FluidPort_a port_1(redeclare package Medium =
        Medium, m_flow(min=if (portFlowDirection_1 == Modelica.Fluid.Types.PortFlowDirection.Entering) then
                0.0 else -Modelica.Constants.inf, max=if (portFlowDirection_1
           == Modelica.Fluid.Types.PortFlowDirection.Leaving) then 0.0 else Modelica.Constants.inf))
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
          rotation=0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_2(redeclare package Medium =
        Medium, m_flow(min=if (portFlowDirection_2 == Modelica.Fluid.Types.PortFlowDirection.Entering) then
                0.0 else -Modelica.Constants.inf, max=if (portFlowDirection_2
           == Modelica.Fluid.Types.PortFlowDirection.Leaving) then 0.0 else Modelica.Constants.inf))
    annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=
           0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_3(
    redeclare package Medium=Medium,
    m_flow(min=if (portFlowDirection_3==Modelica.Fluid.Types.PortFlowDirection.Entering) then 0.0 else -Modelica.Constants.inf,
    max=if (portFlowDirection_3==Modelica.Fluid.Types.PortFlowDirection.Leaving) then 0.0 else Modelica.Constants.inf))
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}},
    rotation=0)));

  parameter Boolean from_dp = true
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(tab="Advanced"));
  parameter Boolean useHomotopy = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  replaceable Buildings.Fluid.Interfaces.PartialStaticTwoPortInterface res1(redeclare
      package Medium = Medium, allowFlowReversal=true, useHomotopy=useHomotopy)
    "Partial model, to be replaced with a fluid component"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}}, rotation=
            0)));
  replaceable Buildings.Fluid.Interfaces.PartialStaticTwoPortInterface res2(redeclare
      package Medium = Medium, allowFlowReversal=true, useHomotopy=useHomotopy)
    "Partial model, to be replaced with a fluid component"
    annotation (Placement(transformation(extent={{60,-10},{40,10}}, rotation=0)));
  replaceable Buildings.Fluid.Interfaces.PartialStaticTwoPortInterface res3(redeclare
      package Medium = Medium, allowFlowReversal=true, useHomotopy=useHomotopy)
    "Partial model, to be replaced with a fluid component"
    annotation (Placement(transformation(
        origin={0,-50},
        extent={{-10,10},{10,-10}},
        rotation=90)));

protected
  parameter Modelica.Fluid.Types.PortFlowDirection portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Bidirectional
    "Flow direction for port_1"
   annotation(Dialog(tab="Advanced"));
  parameter Modelica.Fluid.Types.PortFlowDirection portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Bidirectional
    "Flow direction for port_2"
   annotation(Dialog(tab="Advanced"));
  parameter Modelica.Fluid.Types.PortFlowDirection portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Bidirectional
    "Flow direction for port_3"
   annotation(Dialog(tab="Advanced"));

public
  Delays.DelayFirstOrder vol(
    redeclare package Medium = Medium,
    nPorts=3,
    use_HeatTransfer=false,
    tau=tau,
    m_flow_nominal=mDyn_flow_nominal,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    p_start=p_start,
    use_T_start=use_T_start,
    T_start=T_start,
    h_start=h_start,
    X_start=X_start,
    C_start=C_start) if
       dynamicBalance "Fluid volume to break algebraic loop"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  parameter Boolean dynamicBalance = true
    "Set to true to use a dynamic balance, which often leads to smaller systems of equations"
    annotation (Dialog(tab="Assumptions", group="Dynamics"));

  parameter Modelica.SIunits.Time tau=10
    "Time constant at nominal flow for dynamic energy and momentum balance"
    annotation (Dialog(tab="Assumptions", group="Dynamics", enable=dynamicBalance));
  parameter Modelica.SIunits.MassFlowRate mDyn_flow_nominal
    "Nominal mass flow rate for dynamic momentum and energy balance"
    annotation (Dialog(tab="Assumptions", group="Dynamics", enable=dynamicBalance));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=system.energyDynamics
    "Formulation of energy balance"
    annotation (Dialog(tab="Assumptions", group="Dynamics", enable=dynamicBalance));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=system.massDynamics
    "Formulation of mass balance"
    annotation (Dialog(tab="Assumptions", group="Dynamics", enable=dynamicBalance));
  parameter Modelica.Media.Interfaces.PartialMedium.AbsolutePressure p_start=
      Medium.p_default "Start value of pressure"
    annotation (Dialog(tab="Initialization"));
  parameter Boolean use_T_start=true "= true, use T_start, otherwise h_start"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Media.Interfaces.PartialMedium.Temperature T_start=if
      use_T_start then Medium.T_default else Medium.temperature_phX(
      p_start,
      h_start,
      X_start) "Start value of temperature"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Media.Interfaces.PartialMedium.SpecificEnthalpy h_start=
      if use_T_start then Medium.specificEnthalpy_pTX(
      p_start,
      T_start,
      X_start) else Medium.h_default "Start value of specific enthalpy"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Media.Interfaces.PartialMedium.MassFraction X_start[Medium.nX]=
     Medium.X_default "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Media.Interfaces.PartialMedium.ExtraProperty C_start[
    Medium.nC]=fill(0, Medium.nC) "Start value of trace substances"
    annotation (Dialog(tab="Initialization"));
equation
  connect(port_1, res1.port_a) annotation (Line(points={{-100,5.55112e-16},{
          -100,6.10623e-16},{-60,6.10623e-16}},                     color={0,
          127,255}));
  connect(res2.port_a, port_2) annotation (Line(points={{60,6.10623e-16},{60,
          5.55112e-16},{100,5.55112e-16}},                     color={0,127,255}));
  connect(res3.port_a, port_3) annotation (Line(points={{-1.68051e-18,-60},{
          -1.68051e-18,-79},{5.55112e-16,-79},{5.55112e-16,-100}},   color={0,
          127,255}));
  connect(res1.port_b,vol. ports[1]) annotation (Line(
      points={{-40,6.10623e-16},{-30.6666,6.10623e-16},{-30.6666,5.55115e-17},{
          -21.3333,5.55115e-17},{-21.3333,-5.55112e-16},{-2.66667,-5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res2.port_b,vol. ports[2]) annotation (Line(
      points={{40,6.10623e-16},{30,6.10623e-16},{30,5.55115e-17},{20,
          5.55115e-17},{20,-5.55112e-16},{5.55112e-16,-5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res3.port_b,vol. ports[3]) annotation (Line(
      points={{1.22293e-15,-40},{2.66667,-40},{2.66667,-5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  if not dynamicBalance then
    connect(res1.port_b, res3.port_b) annotation (Line(
      points={{-40,6.10623e-16},{-20,6.10623e-16},{-20,-40},{1.22293e-15,-40}},
      color={0,127,255},
      smooth=Smooth.None));
    connect(res1.port_b, res2.port_b) annotation (Line(
      points={{-40,6.10623e-16},{-20,6.10623e-16},{-20,1.22125e-15},{0,
            1.22125e-15},{0,6.10623e-16},{40,6.10623e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  end if;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),
                      graphics),
                       Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                            graphics),
     extent=[40,-10; 60,10],
    Documentation(info="<html>
<p>
Partial model for flow resistances with three ports such as a 
flow mixer/splitter or a three way valve.
</p>
<p>
If <code>dynamicBalance=true</code>, then at the junction of the three flows,
a mixing volume will be present. This will introduce a dynamic energy and momentum
balance, which often breaks algebraic loops. 
The time constant of the mixing volume is determined by the parameter <code>tau</code>.
</html>", revisions="<html>
<ul>
<li>
March 23 2010, by Michael Wetter:<br>
Changed start values from <code>system.p_start</code> or (code <code>T_start</code>)
to <code>Medium.p_default</code>.
</li>
<li>
September 18, 2008 by Michael Wetter:<br>
Replaced splitter model with a fluid port since the 
splitter model in Modelica.Fluid 1.0 beta does not transport
<code>mC_flow</code>.
<li>
June 11, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end PartialThreeWayResistance;
