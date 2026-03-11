% function out = model
%
% sca2d3.m
%
% Model exported on Feb 5 2026, 14:17 by COMSOL 6.2.0.339.

addpath('C:\Program Files\COMSOL\COMSOL62\Multiphysics\mli');
addpath('C:\Program Files\COMSOL\COMSOL62\Multiphysics\ext\LiveLink\Simulink\sli');
addpath('C:\Users\user\.comsol\v62\llsimulink');

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('model1');

model.modelPath('C:\Users\user\Documents\Arseniy\SWITCHING_V2\COMSOL');

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 2);

model.component('comp1').mesh.create('mesh1');

model.component('comp1').physics.create('ewfd', 'ElectromagneticWavesFrequencyDomain', 'geom1');

model.study.create('std1');
model.study('std1').create('wave', 'Wavelength');
model.study('std1').feature('wave').set('solnum', 'auto');
model.study('std1').feature('wave').set('notsolnum', 'auto');
model.study('std1').feature('wave').set('outputmap', {});
model.study('std1').feature('wave').set('ngenAUX', '1');
model.study('std1').feature('wave').set('goalngenAUX', '1');
model.study('std1').feature('wave').set('ngenAUX', '1');
model.study('std1').feature('wave').set('goalngenAUX', '1');
model.study('std1').feature('wave').setSolveFor('/physics/ewfd', true);

model.param.set('lambda', '1.6[m]');
model.param.set('n1', 'if(lambda == 1.6, 1, 1)');
model.param.set('n2', 'if(lambda == 1.6, 2, 2)');
% model.param.set('n11', '1.63');
% model.param.set('n21', '3.19');

model.component('comp1').geom('geom1').create('c1', 'Circle');
model.component('comp1').geom('geom1').feature('c1').set('r', 15);
model.component('comp1').geom('geom1').feature('c1').setIndex('layer', 'lambda', 0);
model.component('comp1').geom('geom1').feature('c1').set('r', '5 + lambda');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('c1').set('r', '5 + lambda');
model.component('comp1').geom('geom1').run('c1');
model.component('comp1').geom('geom1').create('sel2', 'ExplicitSelection');
model.component('comp1').geom('geom1').feature('sel2').selection('selection').init(1);
model.component('comp1').geom('geom1').feature('sel2').selection('selection').set('c1', [7 8 10 11]);
model.component('comp1').geom('geom1').feature('sel2').label('ffCalc');
model.component('comp1').geom('geom1').run('sel2');

addpath('C:\Users\user\Documents\Arseniy\SWITCHING_V2.1\SWITCHING_V2.1');
params = load('best_solution2.mat');
N = (length(params.best_overall_params) + 2)/3;
r0 = 0.7;
r = r0;

radii = r * (1 + params.best_overall_params(1:N));
init = startPosition(N, 2.85*r);
c = params.best_overall_params(N+1:end);
coords = (cell2mat(init) + r * [0; 0; c]);

lmbd = 1.6; %um
radii = radii * lmbd / 2 / pi;
coords = coords * lmbd / 2 / pi;
for n = 1:N
    name = sprintf('c%d', n+1);
    if radii(n) > 2e-3
    model.component('comp1').geom('geom1').create(name, 'Circle');
    model.component('comp1').geom('geom1').feature(name).set('r', radii(n));
    model.component('comp1').geom('geom1').feature(name).set('pos', coords(2*n-1:2*n) .* [1; -1]);
    end
end
model.component('comp1').geom('geom1').runPre('fin');

model.component('comp1').geom('geom1').create('sel1', 'ExplicitSelection');
for n = 1:N
    if radii(n) > 2e-3
    name = sprintf('c%d', n+1);
    model.component('comp1').geom('geom1').feature('sel1').selection('selection').set(name, 1);
    end
end
model.component('comp1').geom('geom1').run('sel1');
model.component('comp1').geom('geom1').run;

model.component('comp1').material.create('mat1', 'Common');
model.component('comp1').material('mat1').propertyGroup.create('RefractiveIndex', 'Refractive_index');
model.component('comp1').material('mat1').propertyGroup('RefractiveIndex').set('n', {'nrefr'});

model.component('comp1').variable.create('var1');
model.component('comp1').variable('var1').set('nrefr', 'n1');
model.component('comp1').variable('var1').selection.geom('geom1', 2);
model.component('comp1').variable('var1').selection.set([1 2 3 4 5]);
model.component('comp1').variable.create('var2');
model.component('comp1').variable('var2').set('nrefr', 'n2');
model.component('comp1').variable('var2').selection.geom('geom1', 2);
model.component('comp1').variable('var2').selection.named('geom1_sel1');


model.component('comp1').physics('ewfd').create('ffd1', 'FarFieldDomain', 2);
model.component('comp1').physics('ewfd').feature('ffd1').selection.set([5]);
model.component('comp1').physics('ewfd').feature('ffd1').feature('ffc1').selection.geom('geom1', 1);
model.component('comp1').physics('ewfd').feature('ffd1').feature('ffc1').selection.named('geom1_sel2');

model.study('std1').feature('wave').set('plist', 'lambda');
model.study('std1').feature('wave').set('punit', 'cm');

model.component('comp1').physics('ewfd').prop('BackgroundField').set('SolveFor', 'scatteredField');
% model.component('comp1').physics('ewfd').prop('BackgroundField').set('WaveType', 'user defined');
model.component('comp1').physics('ewfd').prop('BackgroundField').set('Eb', {'0' '0' 'exp(-2j*pi*x/lambda)'});
model.component('comp1').physics('ewfd').prop('BackgroundField').set('WaveType', 'GaussianBeam');
model.component('comp1').physics('ewfd').prop('BackgroundField').set('w0', '1.6');
model.component('comp1').physics('ewfd').prop('BackgroundField').set('kUserDefined', 'ewfd.k0 * n1');
% model.component('comp1').physics('ewfd').prop('BackgroundField').set('WaveType', 'userdef');
% model.component('comp1').physics('ewfd').prop('BackgroundField').set('Eb', {'0' '0' 'exp(-n1*2j*pi*x/lambda)'});

model.sol.create('sol1');
model.sol('sol1').study('std1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'wave');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'wave');
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').feature('s1').set('stol', 0.01);
model.sol('sol1').feature('s1').create('p1', 'Parametric');
model.sol('sol1').feature('s1').feature.remove('pDef');
model.sol('sol1').feature('s1').feature('p1').set('pname', {'lambda0'});
model.sol('sol1').feature('s1').feature('p1').set('plistarr', {'lambda'});
model.sol('sol1').feature('s1').feature('p1').set('punit', {'cm'});
model.sol('sol1').feature('s1').feature('p1').set('pcontinuationmode', 'no');
model.sol('sol1').feature('s1').feature('p1').set('preusesol', 'no');
model.sol('sol1').feature('s1').feature('p1').set('pdistrib', 'off');
model.sol('sol1').feature('s1').feature('p1').set('plot', 'off');
model.sol('sol1').feature('s1').feature('p1').set('plotgroup', 'Default');
model.sol('sol1').feature('s1').feature('p1').set('probesel', 'all');
model.sol('sol1').feature('s1').feature('p1').set('probes', {});
model.sol('sol1').feature('s1').feature('p1').set('control', 'wave');
model.sol('sol1').feature('s1').set('control', 'wave');
model.sol('sol1').feature('s1').feature('aDef').set('complexfun', true);
model.sol('sol1').feature('s1').feature('aDef').set('cachepattern', false);
model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').create('d1', 'Direct');
model.sol('sol1').feature('s1').feature('d1').set('linsolver', 'mumps');
model.sol('sol1').feature('s1').feature('d1').label('Suggested Direct Solver (ewfd)');
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'd1');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').attach('std1');
model.sol('sol1').runAll;

model.result.create('pg1', 'PlotGroup2D');
model.result('pg1').label('Electric Field (ewfd)');
model.result('pg1').set('frametype', 'spatial');
model.result('pg1').set('defaultPlotID', 'ElectromagneticWavesFrequencyDomain/phys1/pdef1/pcond2/pg1');
model.result('pg1').feature.create('surf1', 'Surface');
model.result('pg1').feature('surf1').set('smooth', 'internal');
model.result('pg1').feature('surf1').set('data', 'parent');
model.result.create('pg2', 'PolarGroup');
model.result('pg2').label('2D Far Field (ewfd)');
model.result('pg2').set('data', 'dset1');
model.result('pg2').create('rp1', 'RadiationPattern');
model.result('pg2').feature('rp1').set('legend', 'on');
model.result('pg2').feature('rp1').set('phidisc', '180');
model.result('pg2').feature('rp1').set('expr', {'ewfd.normEfar'});
model.result('pg2').feature('rp1').create('exp1', 'Export');
model.result('pg2').feature('rp1').feature('exp1').setIndex('expr', 'comp1.ewfd.phi', 0);
model.result('pg1').run;

model.component('comp1').coordSystem.create('pml1', 'PML');
model.component('comp1').coordSystem('pml1').selection.set([1 2 3 4]);
model.component('comp1').coordSystem('pml1').set('ScalingType', 'Cylindrical');

model.sol('sol1').study('std1');
model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'wave');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'wave');
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').feature('s1').set('stol', 0.01);
model.sol('sol1').feature('s1').create('p1', 'Parametric');
model.sol('sol1').feature('s1').feature.remove('pDef');
model.sol('sol1').feature('s1').feature('p1').set('pname', {'lambda0'});
model.sol('sol1').feature('s1').feature('p1').set('plistarr', {'lambda'});
model.sol('sol1').feature('s1').feature('p1').set('punit', {'cm'});
model.sol('sol1').feature('s1').feature('p1').set('pcontinuationmode', 'no');
model.sol('sol1').feature('s1').feature('p1').set('preusesol', 'no');
model.sol('sol1').feature('s1').feature('p1').set('pdistrib', 'off');
model.sol('sol1').feature('s1').feature('p1').set('plot', 'off');
model.sol('sol1').feature('s1').feature('p1').set('plotgroup', 'pg1');
model.sol('sol1').feature('s1').feature('p1').set('probesel', 'all');
model.sol('sol1').feature('s1').feature('p1').set('probes', {});
model.sol('sol1').feature('s1').feature('p1').set('control', 'wave');
model.sol('sol1').feature('s1').set('control', 'wave');
model.sol('sol1').feature('s1').feature('aDef').set('complexfun', true);
model.sol('sol1').feature('s1').feature('aDef').set('cachepattern', false);
model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').create('d1', 'Direct');
model.sol('sol1').feature('s1').feature('d1').set('linsolver', 'mumps');
model.sol('sol1').feature('s1').feature('d1').label('Suggested Direct Solver (ewfd)');
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'd1');
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').attach('std1');
model.sol('sol1').runAll;

model.study('std1').create('param', 'Parametric');
model.study('std1').feature('param').setIndex('pname', 'lambda', 0);
model.study('std1').feature('param').setIndex('plistarr', '', 0);
model.study('std1').feature('param').setIndex('punit', 'm', 0);
model.study('std1').feature('param').setIndex('pname', 'lambda', 0);
model.study('std1').feature('param').setIndex('plistarr', '', 0);
model.study('std1').feature('param').setIndex('punit', 'm', 0);
model.study('std1').feature('param').setIndex('plistarr', '{1.3, 1.6}', 0);

model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').feature('rp1').set('phidisc', 720);
model.result('pg2').run;

out = model;
mphlaunch(model);
