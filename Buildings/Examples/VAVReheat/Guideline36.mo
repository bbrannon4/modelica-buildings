within Buildings.Examples.VAVReheat;
model Guideline36
  "Variable air volume flow system with terminal reheat and five thermal zones"
  extends Modelica.Icons.Example;
  extends Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop;

  parameter Modelica.SIunits.VolumeFlowRate maxSysPriFlo=m_flow_nominal/1.2
    "Maximum expected system primary airflow at design stage";
  parameter Modelica.SIunits.VolumeFlowRate minZonPriFlo[numZon]={
      mCor_flow_nominal,mSou_flow_nominal,mEas_flow_nominal,mNor_flow_nominal,
      mWes_flow_nominal}/1.2 "Minimum expected zone primary flow rate";

  parameter Modelica.SIunits.Time samplePeriod=120
    "Sample period of component, set to the same value as the trim and respond that process yPreSetReq";

  Buildings.Examples.VAVReheat.Controls.RoomVAVGuideline36 conVAVCor(
    m_flow_nominal=mCor_flow_nominal,
    zonAre=AFloCor,
    final samplePeriod=samplePeriod) "Controller for terminal unit corridor"
    annotation (Placement(transformation(extent={{530,32},{550,52}})));
  Buildings.Examples.VAVReheat.Controls.RoomVAVGuideline36 conVAVSou(
    m_flow_nominal=mSou_flow_nominal,
    zonAre=AFloSou,
    final samplePeriod=samplePeriod) "Controller for terminal unit south"
    annotation (Placement(transformation(extent={{700,30},{720,50}})));
  Buildings.Examples.VAVReheat.Controls.RoomVAVGuideline36 conVAVEas(
    m_flow_nominal=mEas_flow_nominal,
    zonAre=AFloEas,
    final samplePeriod=samplePeriod) "Controller for terminal unit east"
    annotation (Placement(transformation(extent={{880,30},{900,50}})));
  Buildings.Examples.VAVReheat.Controls.RoomVAVGuideline36 conVAVNor(
    m_flow_nominal=mNor_flow_nominal,
    zonAre=AFloNor,
    final samplePeriod=samplePeriod) "Controller for terminal unit north"
    annotation (Placement(transformation(extent={{1040,30},{1060,50}})));
  Buildings.Examples.VAVReheat.Controls.RoomVAVGuideline36 conVAVWes(
    m_flow_nominal=mWes_flow_nominal,
    zonAre=AFloWes,
    final samplePeriod=samplePeriod) "Controller for terminal unit west"
    annotation (Placement(transformation(extent={{1240,28},{1260,48}})));
  Buildings.Examples.VAVReheat.Controls.AHUGuideline36 conAHU(
    numZon=numZon,
    maxSysPriFlo=maxSysPriFlo,
    minZonPriFlo=minZonPriFlo,
    zonAre=zonAre,
    have_occSen=fill(false, numZon))
    "AHU controller"
    annotation (Placement(transformation(extent={{392,334},{432,442}})));
  Buildings.Examples.VAVReheat.Controls.ZoneSetPointsGuideline36 TSetZon(
    THeaOn=THeaOn,
    THeaOff=THeaOff,
    TCooOff=TCooOff,
    numZon=numZon) "Zone temperature set points" annotation (Placement(
        transformation(rotation=0, extent={{58,298},{80,324}})));
  Modelica.Blocks.Routing.Multiplex5 TDis "Discharge air temperatures"
    annotation (Placement(transformation(extent={{220,280},{240,300}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nOcc[numZon](each final
            k=0)
    "Occupany signal (set to zero as the control is configured to have no occupancy sensors)"
    annotation (Placement(transformation(extent={{320,460},{340,480}})));
  Modelica.Blocks.Routing.Multiplex5 VBox_flow
    "Air flow rate at the terminal boxes"
    annotation (Placement(transformation(extent={{220,240},{240,260}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum TZonResReq(nin=5)
    "Number of zone temperature requests"
    annotation (Placement(transformation(extent={{340,280},{360,300}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum PZonResReq(nin=5)
    "Number of zone pressure requests"
    annotation (Placement(transformation(extent={{340,240},{360,260}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant zonSta(k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Constants.ZoneStates.deadband)
    "Zone state signal"
    annotation (Placement(transformation(extent={{300,330},{320,350}})));
  parameter Modelica.SIunits.PressureDifference dpDisRetMax=40
    "Maximum return fan discharge static pressure setpoint";
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yOutDam(k=1)
    "Outdoor air damper control signal"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
equation
  connect(fanSup.port_b, dpDisSupFan.port_a) annotation (Line(
      points={{320,-40},{320,0},{320,-10},{320,-10}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));

  connect(conVAVCor.TRoo, TRooAir.y5[1]) annotation (Line(
      points={{528,42},{520,42},{520,162},{511,162}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conVAVSou.TRoo, TRooAir.y1[1]) annotation (Line(
      points={{698,40},{690,40},{690,40},{680,40},{680,178},{511,178}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TRooAir.y2[1], conVAVEas.TRoo) annotation (Line(
      points={{511,174},{868,174},{868,40},{878,40}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TRooAir.y3[1], conVAVNor.TRoo) annotation (Line(
      points={{511,170},{1028,170},{1028,40},{1038,40}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TRooAir.y4[1], conVAVWes.TRoo) annotation (Line(
      points={{511,166},{1220,166},{1220,38},{1238,38}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conVAVCor.TDis, TSupCor.T) annotation (Line(points={{528,39.3333},{
          522,39.3333},{522,40},{514,40},{514,92},{569,92}}, color={0,0,127}));
  connect(TSupSou.T, conVAVSou.TDis) annotation (Line(points={{749,92},{688,92},
          {688,37.3333},{698,37.3333}}, color={0,0,127}));
  connect(TSupEas.T, conVAVEas.TDis) annotation (Line(points={{929,90},{872,90},
          {872,37.3333},{878,37.3333}}, color={0,0,127}));
  connect(TSupNor.T, conVAVNor.TDis) annotation (Line(points={{1089,94},{1032,
          94},{1032,37.3333},{1038,37.3333}}, color={0,0,127}));
  connect(TSupWes.T, conVAVWes.TDis) annotation (Line(points={{1289,90},{1228,
          90},{1228,35.3333},{1238,35.3333}}, color={0,0,127}));
  connect(cor.yVAV, conVAVCor.yDam) annotation (Line(points={{566,50},{556,50},
          {556,48},{551,48}}, color={0,0,127}));
  connect(cor.yVal, conVAVCor.yVal) annotation (Line(points={{566,34},{560,34},
          {560,41.3333},{551,41.3333}}, color={0,0,127}));
  connect(conVAVSou.yDam, sou.yVAV) annotation (Line(points={{721,46},{730,46},
          {730,48},{746,48}}, color={0,0,127}));
  connect(conVAVSou.yVal, sou.yVal) annotation (Line(points={{721,39.3333},{
          732.5,39.3333},{732.5,32},{746,32}}, color={0,0,127}));
  connect(conVAVEas.yVal, eas.yVal) annotation (Line(points={{901,39.3333},{
          912.5,39.3333},{912.5,32},{926,32}}, color={0,0,127}));
  connect(conVAVEas.yDam, eas.yVAV) annotation (Line(points={{901,46},{910,46},
          {910,48},{926,48}}, color={0,0,127}));
  connect(conVAVNor.yDam, nor.yVAV) annotation (Line(points={{1061,46},{1072.5,
          46},{1072.5,48},{1086,48}}, color={0,0,127}));
  connect(conVAVNor.yVal, nor.yVal) annotation (Line(points={{1061,39.3333},{
          1072.5,39.3333},{1072.5,32},{1086,32}}, color={0,0,127}));
  connect(conVAVCor.TRooHeaSet, TSetZon.THeaSet) annotation (Line(points={{528,50},
          {480,50},{480,315.333},{81.1,315.333}},    color={0,0,127}));
  connect(conVAVCor.TRooCooSet, TSetZon.TCooSet) annotation (Line(points={{528,
          47.3333},{480,47.3333},{480,319.667},{81.1,319.667}}, color={0,0,127}));
  connect(conVAVSou.TRooHeaSet, TSetZon.THeaSet) annotation (Line(points={{698,48},
          {660,48},{660,315.333},{81.1,315.333}},    color={0,0,127}));
  connect(conVAVSou.TRooCooSet, TSetZon.TCooSet) annotation (Line(points={{698,
          45.3333},{660,45.3333},{660,319.667},{81.1,319.667}}, color={0,0,127}));
  connect(conVAVEas.TRooHeaSet, TSetZon.THeaSet) annotation (Line(points={{878,48},
          {850,48},{850,315.333},{81.1,315.333}},    color={0,0,127}));
  connect(conVAVEas.TRooCooSet, TSetZon.TCooSet) annotation (Line(points={{878,
          45.3333},{850,45.3333},{850,319.667},{81.1,319.667}}, color={0,0,127}));
  connect(conVAVNor.TRooHeaSet, TSetZon.THeaSet) annotation (Line(points={{1038,48},
          {1020,48},{1020,315.333},{81.1,315.333}},     color={0,0,127}));
  connect(conVAVNor.TRooCooSet, TSetZon.TCooSet) annotation (Line(points={{1038,
          45.3333},{1020,45.3333},{1020,319.667},{81.1,319.667}}, color={0,0,
          127}));
  connect(conVAVWes.TRooHeaSet, TSetZon.THeaSet) annotation (Line(points={{1238,46},
          {1202,46},{1202,315.333},{81.1,315.333}},     color={0,0,127}));
  connect(conVAVWes.TRooCooSet, TSetZon.TCooSet) annotation (Line(points={{1238,
          43.3333},{1202,43.3333},{1202,319.667},{81.1,319.667}}, color={0,0,
          127}));

  connect(conVAVWes.yVal, wes.yVal) annotation (Line(points={{1261,37.3333},{
          1272.5,37.3333},{1272.5,32},{1286,32}}, color={0,0,127}));
  connect(wes.yVAV, conVAVWes.yDam) annotation (Line(points={{1286,48},{1274,48},
          {1274,44},{1261,44}}, color={0,0,127}));
  connect(TSetZon.uOcc, occSch.occupied) annotation (Line(points={{55.8,300.194},
          {-92,300.194},{-92,300},{-240,300},{-240,300},{-240,300},{-240,-216},
          {-297,-216}}, color={255,0,255}));
  connect(occSch.tNexOcc, TSetZon.tNexOcc) annotation (Line(points={{-297,-204},
          {-254,-204},{-254,300},{-254,300},{-254,315.333},{55.8,315.333}},
        color={0,0,127}));
  connect(TSetZon.TZon, flo.TRooAir) annotation (Line(points={{55.8,308.86},{
          55.8,310},{46,310},{46,622},{1164,622},{1164,554.889},{1093.44,
          554.889}}, color={0,0,127}));
  connect(conAHU.THeaSet, TSetZon.THeaSet) annotation (Line(points={{391,434},{
          120,434},{120,315.333},{81.1,315.333}}, color={0,0,127}));
  connect(conAHU.TCooSet, TSetZon.TCooSet) annotation (Line(points={{391,428},{
          128,428},{128,319.667},{81.1,319.667}}, color={0,0,127}));
  connect(conAHU.TZon, flo.TRooAir) annotation (Line(points={{391,418},{280,418},
          {280,622},{1164,622},{1164,554.889},{1093.44,554.889}}, color={0,0,
          127}));
  connect(conAHU.TOut, TOut.y) annotation (Line(points={{391,410},{-266,410},{
          -266,180},{-279,180}},
                            color={0,0,127}));
  connect(TRet.T, conAHU.TOutCut)
    annotation (Line(points={{100,151},{100,406},{391,406}}, color={0,0,127}));
  connect(conAHU.TSup, TSup.T) annotation (Line(points={{391,394},{140,394},{
          140,-20},{340,-20},{340,-29}}, color={0,0,127}));
  connect(dpDisSupFan.p_rel, conAHU.ducStaPre) annotation (Line(points={{311,0},
          {150,0},{150,382},{391,382}}, color={0,0,127}));
  connect(conAHU.uOpeMod, TSetZon.yOpeMod) annotation (Line(points={{391,366},{
          130,366},{130,308.833},{81.1,308.833}}, color={255,127,0}));
  connect(conAHU.uFreProSta, TSetZon.yFreProSta) annotation (Line(points={{391,358},
          {134,358},{134,303.417},{81.1,303.417}},      color={255,127,0}));
  connect(conAHU.TDis, TDis.y) annotation (Line(points={{391,422},{254,422},{
          254,290},{241,290}}, color={0,0,127}));
  connect(conAHU.nOcc, nOcc.y) annotation (Line(points={{391,390},{360,390},{
          360,470},{341,470}}, color={0,0,127}));
  connect(conAHU.VBox_flow, VBox_flow.y) annotation (Line(points={{391,376},{
          260,376},{260,250},{241,250}}, color={0,0,127}));
  connect(conVAVCor.uOpeMod, TSetZon.yOpeMod) annotation (Line(points={{528,34},
          {520,34},{520,16},{400,16},{400,200},{88,200},{88,308.833},{81.1,
          308.833}}, color={255,127,0}));
  connect(conVAVSou.uOpeMod, TSetZon.yOpeMod) annotation (Line(points={{698,32},
          {690,32},{690,16},{400,16},{400,200},{88,200},{88,308.833},{81.1,
          308.833}}, color={255,127,0}));
  connect(conVAVEas.uOpeMod, TSetZon.yOpeMod) annotation (Line(points={{878,32},
          {868,32},{868,16},{400,16},{400,200},{88,200},{88,308.833},{81.1,
          308.833}}, color={255,127,0}));
  connect(conVAVNor.uOpeMod, TSetZon.yOpeMod) annotation (Line(points={{1038,32},
          {1032,32},{1032,16},{1024,16},{1024,16},{400,16},{400,200},{88,200},{
          88,308.833},{81.1,308.833}}, color={255,127,0}));
  connect(conVAVWes.uOpeMod, TSetZon.yOpeMod) annotation (Line(points={{1238,30},
          {1228,30},{1228,16},{400,16},{400,200},{88,200},{88,308.833},{81.1,
          308.833}}, color={255,127,0}));
  connect(conAHU.uZonTemResReq, TZonResReq.y) annotation (Line(points={{391,346},
          {368,346},{368,290},{361.7,290}}, color={255,127,0}));
  connect(conVAVCor.yZonTemResReq, TZonResReq.u[1]) annotation (Line(points={{551,
          37.3333},{554,37.3333},{554,220},{328,220},{328,295.6},{338,295.6}},
        color={255,127,0}));
  connect(conVAVSou.yZonTemResReq, TZonResReq.u[2]) annotation (Line(points={{721,
          35.3333},{726,35.3333},{726,220},{328,220},{328,292.8},{338,292.8}},
        color={255,127,0}));
  connect(conVAVEas.yZonTemResReq, TZonResReq.u[3]) annotation (Line(points={{901,
          35.3333},{904,35.3333},{904,220},{328,220},{328,290},{338,290}},
        color={255,127,0}));
  connect(conVAVNor.yZonTemResReq, TZonResReq.u[4]) annotation (Line(points={{1061,
          35.3333},{1064,35.3333},{1064,220},{328,220},{328,287.2},{338,287.2}},
                   color={255,127,0}));
  connect(conVAVWes.yZonTemResReq, TZonResReq.u[5]) annotation (Line(points={{1261,
          33.3333},{1266,33.3333},{1266,220},{328,220},{328,284.4},{338,284.4}},
                   color={255,127,0}));
  connect(conVAVCor.yZonPreResReq, PZonResReq.u[1]) annotation (Line(points={{551,
          34.6667},{558,34.6667},{558,214},{332,214},{332,255.6},{338,255.6}},
        color={255,127,0}));
  connect(conVAVSou.yZonPreResReq, PZonResReq.u[2]) annotation (Line(points={{721,
          32.6667},{728,32.6667},{728,214},{332,214},{332,252.8},{338,252.8}},
        color={255,127,0}));
  connect(conVAVEas.yZonPreResReq, PZonResReq.u[3]) annotation (Line(points={{901,
          32.6667},{906,32.6667},{906,214},{332,214},{332,250},{338,250}},
        color={255,127,0}));
  connect(conVAVNor.yZonPreResReq, PZonResReq.u[4]) annotation (Line(points={{1061,
          32.6667},{1066,32.6667},{1066,214},{332,214},{332,247.2},{338,247.2}},
                   color={255,127,0}));
  connect(conVAVWes.yZonPreResReq, PZonResReq.u[5]) annotation (Line(points={{1261,
          30.6667},{1268,30.6667},{1268,214},{332,214},{332,244.4},{338,244.4}},
                   color={255,127,0}));
  connect(conAHU.uZonPreResReq, PZonResReq.y) annotation (Line(points={{391,338},
          {372,338},{372,250},{361.7,250}}, color={255,127,0}));
  connect(VSupCor_flow.V_flow, VBox_flow.u1[1]) annotation (Line(points={{569,
          130},{472,130},{472,206},{180,206},{180,260},{218,260}}, color={0,0,
          127}));
  connect(VSupSou_flow.V_flow, VBox_flow.u2[1]) annotation (Line(points={{749,
          130},{742,130},{742,206},{180,206},{180,255},{218,255}}, color={0,0,
          127}));
  connect(VSupEas_flow.V_flow, VBox_flow.u3[1]) annotation (Line(points={{929,
          128},{914,128},{914,206},{180,206},{180,250},{218,250}}, color={0,0,
          127}));
  connect(VSupNor_flow.V_flow, VBox_flow.u4[1]) annotation (Line(points={{1089,
          132},{1080,132},{1080,206},{180,206},{180,245},{218,245}}, color={0,0,
          127}));
  connect(VSupWes_flow.V_flow, VBox_flow.u5[1]) annotation (Line(points={{1289,
          128},{1284,128},{1284,206},{180,206},{180,240},{218,240}}, color={0,0,
          127}));
  connect(TSupCor.T, TDis.u1[1]) annotation (Line(points={{569,92},{466,92},{
          466,210},{176,210},{176,300},{218,300}}, color={0,0,127}));
  connect(TSupSou.T, TDis.u2[1]) annotation (Line(points={{749,92},{720,92},{
          720,92},{688,92},{688,210},{176,210},{176,295},{218,295}}, color={0,0,
          127}));
  connect(TSupEas.T, TDis.u3[1]) annotation (Line(points={{929,90},{872,90},{
          872,210},{176,210},{176,290},{218,290}}, color={0,0,127}));
  connect(TSupNor.T, TDis.u4[1]) annotation (Line(points={{1089,94},{1032,94},{
          1032,210},{176,210},{176,285},{218,285}}, color={0,0,127}));
  connect(TSupWes.T, TDis.u5[1]) annotation (Line(points={{1289,90},{1228,90},{
          1228,210},{176,210},{176,280},{218,280}}, color={0,0,127}));
  connect(conAHU.yOutDamPos, eco.yOut) annotation (Line(points={{433,398},{450,398},
          {450,36},{-10,36},{-10,-34}}, color={0,0,127}));
  connect(conVAVCor.VDis, VSupCor_flow.V_flow) annotation (Line(points={{528,
          44.6667},{522,44.6667},{522,130},{569,130}}, color={0,0,127}));
  connect(VSupSou_flow.V_flow, conVAVSou.VDis) annotation (Line(points={{749,130},
          {690,130},{690,42.6667},{698,42.6667}},      color={0,0,127}));
  connect(VSupEas_flow.V_flow, conVAVEas.VDis) annotation (Line(points={{929,128},
          {874,128},{874,42.6667},{878,42.6667}},      color={0,0,127}));
  connect(VSupNor_flow.V_flow, conVAVNor.VDis) annotation (Line(points={{1089,
          132},{1034,132},{1034,42.6667},{1038,42.6667}}, color={0,0,127}));
  connect(VSupWes_flow.V_flow, conVAVWes.VDis) annotation (Line(points={{1289,
          128},{1230,128},{1230,40.6667},{1238,40.6667}}, color={0,0,127}));
  connect(TSup.T, conVAVCor.TSupAHU) annotation (Line(points={{340,-29},{340,
          -20},{514,-20},{514,36.6667},{528,36.6667}}, color={0,0,127}));
  connect(TSup.T, conVAVSou.TSupAHU) annotation (Line(points={{340,-29},{340,
          -20},{686,-20},{686,34.6667},{698,34.6667}}, color={0,0,127}));
  connect(TSup.T, conVAVEas.TSupAHU) annotation (Line(points={{340,-29},{340,
          -20},{864,-20},{864,34.6667},{878,34.6667}}, color={0,0,127}));
  connect(TSup.T, conVAVNor.TSupAHU) annotation (Line(points={{340,-29},{340,
          -20},{1028,-20},{1028,34.6667},{1038,34.6667}}, color={0,0,127}));
  connect(TSup.T, conVAVWes.TSupAHU) annotation (Line(points={{340,-29},{340,
          -20},{1224,-20},{1224,32.6667},{1238,32.6667}}, color={0,0,127}));
  connect(VOut1.V_flow, conAHU.VOut_flow) annotation (Line(points={{-61,-20.9},
          {-61,386},{391,386}},color={0,0,127}));
  connect(conAHU.uZonSta, zonSta.y) annotation (Line(points={{391,362},{330,362},
          {330,340},{321,340}}, color={255,127,0}));
  connect(fanSup.y, conAHU.ySupFanSpe) annotation (Line(points={{310,-28},{310,-14},
          {460,-14},{460,410.4},{433,410.4}},
                                           color={0,0,127}));
  connect(conAHU.yHea, gaiHeaCoi.u) annotation (Line(points={{433,360},{456,360},
          {456,-280},{80,-280},{80,-210},{98,-210}}, color={0,0,127}));
  connect(conAHU.yCoo, gaiCooCoi.u) annotation (Line(points={{433,348},{446,348},
          {446,-274},{88,-274},{88,-248},{98,-248}}, color={0,0,127}));
  connect(conAHU.TMix, TMix.T)
    annotation (Line(points={{391,372},{40,372},{40,-29}}, color={0,0,127}));
  connect(conAHU.yRetDamPos, eco.yRet) annotation (Line(points={{433,386},{436,386},
          {436,40},{-16.8,40},{-16.8,-34}},
                                          color={0,0,127}));
  connect(yOutDam.y, eco.yExh)
    annotation (Line(points={{-19,-10},{-3,-10},{-3,-34}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-400,-400},{
            1660,640}})),
    Documentation(info="<html>
<p>
This model consist of an HVAC system, a building envelope model and a model
for air flow through building leakage and through open doors.
</p>
<p>
The HVAC system is a variable air volume (VAV) flow system with economizer
and a heating and cooling coil in the air handler unit. There is also a
reheat coil and an air damper in each of the five zone inlet branches.
</p>
<p>
See the model
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop\">
Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop</a>
for a description of the HVAC system and the building envelope.
</p>
<p>
The control is based on ASHRAE Guideline 36, and implemented
using the sequences from the library
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1\">
Buildings.Controls.OBC.ASHRAE.G36_PR1</a> for
multi-zone VAV systems with economizer. The schematic diagram of the HVAC and control
sequence is shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/VAVReheat/vavControlSchematics.png\" border=\"1\"/>
</p>
<p>
A similar model but with a different control sequence can be found in
<a href=\"modelica://Buildings.Examples.VAVReheat.ASHRAE2006\">
Buildings.Examples.VAVReheat.ASHRAE2006</a>.
Note that this model, because of the frequent time sampling,
has longer computing time than
<a href=\"modelica://Buildings.Examples.VAVReheat.ASHRAE2006\">
Buildings.Examples.VAVReheat.ASHRAE2006</a>.
The reason is that the time integrator cannot make large steps
because it needs to set a time step each time the control samples
its input.
</p>
</html>", revisions="<html>
<ul>
<li>
May 19, 2016, by Michael Wetter:<br/>
Changed chilled water supply temperature to <i>6&circ;C</i>.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/509\">#509</a>.
</li>
<li>
April 26, 2016, by Michael Wetter:<br/>
Changed controller for freeze protection as the old implementation closed
the outdoor air damper during summer.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/511\">#511</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
September 24, 2015 by Michael Wetter:<br/>
Set default temperature for medium to avoid conflicting
start values for alias variables of the temperature
of the building and the ambient air.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">issue 426</a>.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVReheat/Guideline36.mos"
        "Simulate and plot"),
    experiment(StopTime=172800, Tolerance=1e-08));
end Guideline36;