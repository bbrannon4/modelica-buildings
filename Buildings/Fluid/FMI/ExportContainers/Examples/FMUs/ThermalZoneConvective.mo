within Buildings.Fluid.FMI.ExportContainers.Examples.FMUs;
model ThermalZoneConvective "Simple thermal zone"
  extends Buildings.Fluid.FMI.ExportContainers.ThermalZoneConvective(
    redeclare final package Medium = MediumA, nFluPor = nFluPorts);

  replaceable package MediumA = Buildings.Media.Air "Medium for air";

  parameter Boolean use_p_in = false
    "= true to use a pressure from connector, false to output Medium.p_default"
    annotation(Evaluate=true);
  parameter Boolean allowFlowReversal = false
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Integer nFluPorts = 2 "Number of fluid ports.";

  parameter Modelica.SIunits.Volume V=6*10*3 "Room volume";
  //////////////////////////////////////////////////////////
  // Heat recovery effectiveness
  parameter Real eps = 0.8 "Heat recovery effectiveness";

  /////////////////////////////////////////////////////////
  // Air temperatures at design conditions
  parameter Modelica.SIunits.Temperature TASup_nominal = 273.15+18
    "Nominal air temperature supplied to room";
  parameter Modelica.SIunits.Temperature TRooSet = 273.15+24
    "Nominal room air temperature";
  parameter Modelica.SIunits.Temperature TOut_nominal = 273.15+30
    "Design outlet air temperature";
  parameter Modelica.SIunits.Temperature THeaRecLvg=
    TOut_nominal - eps*(TOut_nominal-TRooSet)
    "Air temperature leaving the heat recovery";

  /////////////////////////////////////////////////////////
  // Cooling loads and air mass flow rates
  parameter Modelica.SIunits.HeatFlowRate QRooInt_flow=
     1000 "Internal heat gains of the room";
  parameter Modelica.SIunits.HeatFlowRate QRooC_flow_nominal=
    -QRooInt_flow-10E3/30*(TOut_nominal-TRooSet)
    "Nominal cooling load of the room";
  parameter Modelica.SIunits.MassFlowRate mA_flow_nominal=
    1.3*QRooC_flow_nominal/1006/(TASup_nominal-TRooSet)
    "Nominal air mass flow rate, increased by factor 1.3 to allow for recovery after temperature setback";
  parameter Modelica.SIunits.TemperatureDifference dTFan = 2
    "Estimated temperature raise across fan that needs to be made up by the cooling coil";
  parameter Modelica.SIunits.HeatFlowRate QCoiC_flow_nominal=4*
    (QRooC_flow_nominal + mA_flow_nominal*(TASup_nominal-THeaRecLvg-dTFan)*1006)
    "Cooling load of coil, taking into account economizer, and increased due to latent heat removal";

  /////////////////////////////////////////////////////////
  // Water temperatures and mass flow rates
  parameter Modelica.SIunits.Temperature TWSup_nominal = 273.15+16
    "Water supply temperature";
  parameter Modelica.SIunits.Temperature TWRet_nominal = 273.15+12
    "Water return temperature";
  parameter Modelica.SIunits.MassFlowRate mW_flow_nominal=
    QCoiC_flow_nominal/(TWRet_nominal-TWSup_nominal)/4200
    "Nominal water mass flow rate";

   Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TRad
    "Radiative temperature"
    annotation (Placement(transformation(extent={{0,40},{-20,60}})));
  Modelica.Blocks.Sources.Constant radTem(k=295.13)
    annotation (Placement(transformation(extent={{40,40},{20,60}})));

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    TDryBul=TOut_nominal,
    filNam="modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos",
    TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.File,
    computeWetBulbTemperature=false) "Weather data reader"
    annotation (Placement(transformation(extent={{152,130},{132,150}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{14,130},{34,150}})));
  Modelica.Blocks.Interfaces.RealOutput TOut(final unit="K")
    "Outdoor temperature" annotation (Placement(transformation(extent={{20,-20},
            {-20,20}},
        rotation=90,
        origin={0,-160}),  iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,-160})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
                                                         TOut1
    "Outside temperature"
    annotation (Placement(transformation(extent={{-20,82},{0,102}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=10000/30)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{20,82},{40,102}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow preHea(Q_flow=
        QRooInt_flow) "Prescribed heat flow"
    annotation (Placement(transformation(extent={{100,50},{80,70}})));
  MixingVolumes.MixingVolumeMoistAir
                                   vol(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    V=V,
    mSenFac=3,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=2)
    annotation (Placement(transformation(extent={{86,2},{106,22}})));
equation
  connect(weaDat.weaBus,weaBus)  annotation (Line(
      points={{132,140},{24,140}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(theCon.port_b,vol. heatPort)
    annotation (Line(points={{40,92},{40,92},{60,92},{60,12},{86,12}},
                                                    color={191,0,0}));
  connect(preHea.port,vol. heatPort)
    annotation (Line(points={{80,60},{60,60},{60,12},{86,12}},
                                                            color={191,0,0}));
  connect(TOut1.T, weaBus.TDryBul) annotation (Line(points={{-22,92},{-40,92},{
          -40,140},{24,140}},
                          color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TOut1.port, theCon.port_a)
    annotation (Line(points={{0,92},{0,92},{20,92}}, color={191,0,0}));
  connect(theHvaAda.heaPorRad, TRad.port) annotation (Line(points={{-60,143.75},
          {-48,143.75},{-48,144},{-46,144},{-46,50},{-20,50}},
                                            color={191,0,0}));
  connect(TRad.T, radTem.y)
    annotation (Line(points={{2,50},{19,50}}, color={0,0,127}));

  connect(theHvaAda.TWat, vol.TWat) annotation (Line(points={{-81.4286,142.5},{
          -100,142.5},{-100,16.8},{84,16.8}},    color={0,0,127}));
  connect(theHvaAda.mWat_flow, vol.mWat_flow) annotation (Line(points={{
          -81.4286,145},{-108,145},{-108,20},{84,20}},
                                              color={0,0,127}));
  connect(theHvaAda.heaPorAir, vol.heatPort) annotation (Line(points={{-60,
          157.5},{0,157.5},{0,120},{60,120},{60,12},{86,12}},     color={191,0,0}));
  connect(theHvaAda.ports[1], vol.ports[1]) annotation (Line(points={{-60.1429,
          150},{-58,150},{-58,150},{-50,150},{-50,-10},{94,-10},{94,2}},color={0,
          127,255}));
  connect(theHvaAda.ports[2], vol.ports[2]) annotation (Line(points={{-60.1429,
          150},{-54,150},{-54,-20},{98,-20},{98,2}},color={0,127,255}));
  connect(TOut, weaBus.TDryBul) annotation (Line(points={{0,-160},{0,-160},{0,
          -54},{0,-40},{120,-40},{120,140},{24,140}}, color={0,0,127}));
    annotation (
              Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},
            {160,180}}), graphics={
      Rectangle(
        extent={{-52,62},{76,-46}},
        lineColor={150,150,150},
        fillPattern=FillPattern.Solid,
        fillColor={150,150,150}),
        Text(
          extent={{-22,-112},{28,-132}},
          lineColor={0,0,127},
          textString="TOut"),
      Polygon(
        points={{12,104},{-66,62},{92,62},{12,104}},
        lineColor={95,95,95},
        smooth=Smooth.None,
        fillPattern=FillPattern.Solid,
        fillColor={95,95,95}),
      Rectangle(
        extent={{-38,-6},{2,44}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{22,-6},{60,44}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},{160,180}})),
    Documentation(info="<html>
<p>
This example demonstrates how to export a model 
of a convective thermal zone that will be coupled 
to an air-based HVAC system. The thermal zone is 
taken from 
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System3\">
Buildings.Examples.Tutorial.SpaceCooling.System3
</a>. 
</p>
<p>
The example extends from 
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.ThermalZoneConvective\">
Buildings.Fluid.FMI.ExportContainers.ThermalZoneConvective
</a> 
which provides 
the input and output signals that are needed to interface 
the acausal thermal zone model with causal connectors of FMI. 
The instance <code>theHvaAda</code> is the HVAC system 
adapter that contains on the right a fluid port, and on 
the left signal ports which are then used to connect at 
the top-level of the model to signal ports which are 
exposed at the FMU interface. 
</p>
</html>", revisions="<html>
<ul>
<li>
April 28, 2016, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/ExportContainers/Examples/FMUs/ThermalZoneConvective.mos"
        "Simulate and plot"),
    experiment(StartTime=1.5552e+07, StopTime=15638400));
end ThermalZoneConvective;
