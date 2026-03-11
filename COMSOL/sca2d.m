function out = model
%
% sca2d.m
%
% Model exported on Feb 2 2026, 19:26 by COMSOL 6.2.0.339.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

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

model.param.set('q', '10');
model.param.set('lambda', '2*pi*1[m]/q');
model.param.set('q', '5');

model.component('comp1').geom('geom1').run;
model.component('comp1').geom('geom1').create('c1', 'Circle');
model.component('comp1').geom('geom1').run('c1');
model.component('comp1').geom('geom1').create('c2', 'Circle');
model.component('comp1').geom('geom1').feature('c2').set('r', 6);
model.component('comp1').geom('geom1').feature('c2').setIndex('layer', 1, 0);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('c2').set('r', 5);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run;

model.component('comp1').material.create('mat1', 'Common');
model.component('comp1').material('mat1').propertyGroup.create('RefractiveIndex', 'Refractive_index');
model.component('comp1').material('mat1').propertyGroup('RefractiveIndex').set('n', {'1'});

model.component('comp1').variable.create('var1');
model.component('comp1').variable('var1').set('nrefr', '1');
model.component('comp1').variable('var1').selection.geom('geom1', 2);
model.component('comp1').variable('var1').selection.set([1 2 3 4 5]);
model.component('comp1').variable.create('var2');
model.component('comp1').variable('var2').selection.geom('geom1', 1);
model.component('comp1').variable('var2').selection.geom('geom1', 2);
model.component('comp1').variable('var2').selection.set([6]);
model.component('comp1').variable('var2').set('nrefr', '1 + exp(-(sqrt(root.x^2 + root.y^2) / 0.3[m])^2)');

model.component('comp1').coordSystem.create('pml1', 'PML');
model.component('comp1').coordSystem('pml1').set('ScalingType', 'Cylindrical');
model.component('comp1').coordSystem('pml1').selection.set([1 2 3 4]);

model.component('comp1').physics('ewfd').create('ffd1', 'FarFieldDomain', 2);
model.component('comp1').physics('ewfd').prop('BackgroundField').set('SolveFor', 'scatteredField');
model.component('comp1').physics('ewfd').prop('BackgroundField').set('Eb', {'0' '0' 'exp(1j*2*pi / lambda*x)'});

model.study('std1').feature('wave').set('plist', 'lambda');

model.component('comp1').mesh('mesh1').run;

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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
model.result('pg2').run;
model.result('pg1').run;
model.result.create('pg3', 'PlotGroup2D');
model.result('pg3').run;
model.result('pg3').create('surf1', 'Surface');
model.result('pg3').feature('surf1').set('expr', 'nrefr');
model.result('pg3').run;
model.result('pg3').run;
model.result('pg1').run;

model.param.set('q', '20');

model.component('comp1').mesh('mesh1').run;

model.component('comp1').physics('ewfd').feature('wee1').set('n_mat', 'userdef');
model.component('comp1').physics('ewfd').feature('wee1').set('n', {'nrefr' '0' '0' '0' 'nrefr' '0' '0' '0' 'nrefr'});

model.component('comp1').mesh.remove('mesh1');
model.component('comp1').mesh.create('mesh1');
model.component('comp1').mesh('mesh1').automatic(true);
model.component('comp1').mesh('mesh1').feature('size').set('hmax', 'lambda/3');
model.component('comp1').mesh('mesh1').feature('size').set('hmin', 0.001);
model.component('comp1').mesh('mesh1').create('map1', 'Map');
model.component('comp1').mesh('mesh1').feature('map1').selection.geom('geom1', 2);
model.component('comp1').mesh('mesh1').feature('map1').selection.set([1 2 3 4]);
model.component('comp1').mesh('mesh1').run('map1');
model.component('comp1').mesh('mesh1').feature('map1').set('smoothmaxiter', 8);
model.component('comp1').mesh('mesh1').run('map1');
model.component('comp1').mesh('mesh1').feature('map1').set('smoothmaxdepth', 6);
model.component('comp1').mesh('mesh1').run('map1');
model.component('comp1').mesh('mesh1').create('ftri1', 'FreeTri');
model.component('comp1').mesh('mesh1').feature('ftri1').selection.geom('geom1', 2);
model.component('comp1').mesh('mesh1').feature('ftri1').selection.set([5]);
model.component('comp1').mesh('mesh1').run('ftri1');
model.component('comp1').mesh('mesh1').create('ftri2', 'FreeTri');
model.component('comp1').mesh('mesh1').feature('ftri2').selection.geom('geom1', 2);
model.component('comp1').mesh('mesh1').feature('ftri2').selection.set([6]);
model.component('comp1').mesh('mesh1').feature('ftri2').set('smoothcontrol', true);
model.component('comp1').mesh('mesh1').run;
model.component('comp1').mesh('mesh1').feature('ftri2').create('size1', 'Size');
model.component('comp1').mesh('mesh1').feature('ftri2').feature('size1').set('custom', true);
model.component('comp1').mesh('mesh1').feature('ftri2').feature('size1').set('hmaxactive', true);
model.component('comp1').mesh('mesh1').feature('ftri2').feature('size1').set('hmax', 'lambda/6');
model.component('comp1').mesh('mesh1').run;

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg3').run;
model.result('pg2').run;

model.component('comp1').physics('ewfd').prop('BackgroundField').set('Eb', {'0' '0' 'exp(-1j*2*pi / lambda*x)'});

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;
model.result('pg3').run;
model.result('pg2').run;

model.component('comp1').mesh('mesh1').feature('size').set('hmax', 'lambda/6');
model.component('comp1').mesh('mesh1').feature('size').set('hmin', '0.0001');
model.component('comp1').mesh('mesh1').feature('ftri2').feature('size1').set('hmax', 'lambda/12');
model.component('comp1').mesh('mesh1').run;

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').variable('var2').set('nrefr', '1 + exp(-(sqrt(root.x^2 + root.y^2) / 0.7[m])^2)');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').feature('rp1').set('phidisc', 720);
model.result('pg2').run;

model.component('comp1').variable('var2').active(false);
model.component('comp1').variable.create('var3');
model.component('comp1').variable('var3').selection.geom('geom1', 2);
model.component('comp1').variable('var3').selection.set([6]);
model.component('comp1').variable('var3').set('nrefr', '2 - 0.5*cos((0:N_inside)/N_inside * 4*pi) + 1j*cos((0:N_inside)/N_inside * 4*pi)');
model.component('comp1').variable('var3').set('radius', 'sqrt(root.x^2 + root.y^2) / 1[m]');
model.component('comp1').variable('var3').set('nrefr', '2 - 0.5*cos((1 - radius) * 4*pi) + 1j*cos((1 - radius)  * 4*pi)');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg3').run;
model.result('pg3').feature('surf1').set('expr', 'real(nrefr)');
model.result('pg3').run;
model.result('pg3').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').create('ls1', 'LineSegment');
model.component('comp1').geom('geom1').feature('ls1').set('specify1', 'coord');
model.component('comp1').geom('geom1').feature('ls1').selection('vertex2').set('c1', 3);
model.component('comp1').geom('geom1').run('ls1');

model.result('pg3').run;
model.result.remove('pg3');
model.result.create('pg3', 'PlotGroup1D');
model.result('pg3').run;
model.result('pg3').set('phasetype', 'fromdataset');
model.result('pg3').setIndex('looplevelinput', 'first', 0);
model.result('pg3').setIndex('looplevelinput', 'all', 0);
model.result('pg3').create('lngr1', 'LineGraph');
model.result('pg3').feature('lngr1').set('markerpos', 'datapoints');
model.result('pg3').feature('lngr1').set('linewidth', 'preference');

model.component('comp1').geom('geom1').run;

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').feature.remove('lngr1');
model.result('pg3').run;
model.result('pg3').create('lngr1', 'LineGraph');
model.result('pg3').feature('lngr1').set('markerpos', 'datapoints');
model.result('pg3').feature('lngr1').set('linewidth', 'preference');
model.result('pg3').feature('lngr1').selection.set([3]);
model.result('pg3').feature('lngr1').set('expr', 'real(nrefr)');
model.result('pg3').run;
model.result('pg3').run;
model.result('pg3').create('lngr2', 'LineGraph');
model.result('pg3').feature('lngr2').set('markerpos', 'datapoints');
model.result('pg3').feature('lngr2').set('linewidth', 'preference');
model.result('pg3').feature('lngr2').selection.set([3]);
model.result('pg3').feature('lngr2').set('expr', 'imag(nrefr)');
model.result('pg3').run;
model.result('pg3').feature('lngr2').set('legend', true);
model.result('pg3').feature('lngr2').set('legendmethod', 'manual');
model.result('pg3').feature('lngr2').setIndex('legends', 'real', 0);
model.result('pg3').feature('lngr2').setIndex('legends', 'imag', 1);
model.result('pg3').run;
model.result('pg3').feature('lngr2').setIndex('legends', '', 1);
model.result('pg3').feature('lngr2').setIndex('legends', 'imag', 0);
model.result('pg3').run;
model.result('pg3').feature('lngr1').set('legend', true);
model.result('pg3').feature('lngr1').set('legendmethod', 'manual');
model.result('pg3').feature('lngr1').setIndex('legends', 'real', 0);
model.result('pg2').run;
model.result('pg2').run;

model.component('comp1').func.create('an1', 'Analytic');
model.component('comp1').func.remove('an1');
model.component('comp1').func.create('im1', 'Image');
model.component('comp1').func.remove('im1');
model.component('comp1').func.create('int1', 'Interpolation');
model.component('comp1').func('int1').set('source', 'file');
model.component('comp1').func('int1').set('filename', 'C:\Users\user\Documents\Arseniy\SWITCHING_V1\inc_field.csv');
model.component('comp1').func('int1').set('dseparator', 'comma');
model.component('comp1').func('int1').set('struct', 'sectionwise');
model.component('comp1').func('int1').setIndex('funcs', 'coeffs', 0, 0);
model.component('comp1').func('int1').refresh;
model.component('comp1').func('int1').setIndex('funcs', 2, 0, 1);
model.component('comp1').func('int1').setIndex('funcs', 1, 0, 1);
model.component('comp1').func('int1').setIndex('funcs', 'n', 0, 0);
model.component('comp1').func('int1').setIndex('funcs', 'real_part', 0, 0);
model.component('comp1').func('int1').set('struct', 'spreadsheet');
model.component('comp1').func('int1').set('nargs', 1);
model.component('comp1').func('int1').setIndex('funcs', 'imag_part', 1, 0);
model.component('comp1').func('int1').setIndex('funcs', 2, 0, 1);
model.component('comp1').func('int1').setIndex('funcs', 3, 1, 1);
model.component('comp1').func('int1').set('dseparator', 'point');
model.component('comp1').func('int1').importData;
model.component('comp1').func('int1').discardData;
model.component('comp1').func('int1').set('filename', 'C:\Users\user\Documents\Arseniy\SWITCHING_V1\inc_field.txt');
model.component('comp1').func('int1').set('dseparator', 'point');
model.component('comp1').func('int1').importData;
model.component('comp1').func('int1').setIndex('funcs', 1, 0, 1);
model.component('comp1').func('int1').setIndex('funcs', 1, 1, 1);
model.component('comp1').func('int1').setIndex('funcs', 2, 1, 1);
model.component('comp1').func.create('an1', 'Analytic');
model.component('comp1').func('an1').set('funcname', 'inc_field');
model.component('comp1').func('an1').set('args', 'x, y');
model.component('comp1').func('an1').set('expr', 'sum((real_part(i) + 1j * imag_part(i)), i, -20, 20)');
model.component('comp1').func('an1').set('args', 'r, phi');
model.component('comp1').func('an1').set('expr', 'sum((real_part(i) + 1j * imag_part(i)) * besselj(i, r) * exp(1j *i * phi) , i, -20, 20)');
model.component('comp1').func('an1').set('args', 'x, y');
model.component('comp1').func('an1').set('expr', '(real_part(-20) + 1j * imag_part(-20)) * besselj(-20, sqrt(x^2+y^2)) * exp(1j * -20 * atan2(y, x))+(real_part(-19) + 1j * imag_part(-19)) * besselj(-19, sqrt(x^2+y^2)) * exp(1j * -19 * atan2(y, x))+(real_part(-18) + 1j * imag_part(-18)) * besselj(-18, sqrt(x^2+y^2)) * exp(1j * -18 * atan2(y, x))+(real_part(-17) + 1j * imag_part(-17)) * besselj(-17, sqrt(x^2+y^2)) * exp(1j * -17 * atan2(y, x))+(real_part(-16) + 1j * imag_part(-16)) * besselj(-16, sqrt(x^2+y^2)) * exp(1j * -16 * atan2(y, x))+(real_part(-15) + 1j * imag_part(-15)) * besselj(-15, sqrt(x^2+y^2)) * exp(1j * -15 * atan2(y, x))+(real_part(-14) + 1j * imag_part(-14)) * besselj(-14, sqrt(x^2+y^2)) * exp(1j * -14 * atan2(y, x))+(real_part(-13) + 1j * imag_part(-13)) * besselj(-13, sqrt(x^2+y^2)) * exp(1j * -13 * atan2(y, x))+(real_part(-12) + 1j * imag_part(-12)) * besselj(-12, sqrt(x^2+y^2)) * exp(1j * -12 * atan2(y, x))+(real_part(-11) + 1j * imag_part(-11)) * besselj(-11, sqrt(x^2+y^2)) * exp(1j * -11 * atan2(y, x))+(real_part(-10) + 1j * imag_part(-10)) * besselj(-10, sqrt(x^2+y^2)) * exp(1j * -10 * atan2(y, x))+(real_part(-9) + 1j * imag_part(-9)) * besselj(-9, sqrt(x^2+y^2)) * exp(1j * -9 * atan2(y, x))+(real_part(-8) + 1j * imag_part(-8)) * besselj(-8, sqrt(x^2+y^2)) * exp(1j * -8 * atan2(y, x))+(real_part(-7) + 1j * imag_part(-7)) * besselj(-7, sqrt(x^2+y^2)) * exp(1j * -7 * atan2(y, x))+(real_part(-6) + 1j * imag_part(-6)) * besselj(-6, sqrt(x^2+y^2)) * exp(1j * -6 * atan2(y, x))+(real_part(-5) + 1j * imag_part(-5)) * besselj(-5, sqrt(x^2+y^2)) * exp(1j * -5 * atan2(y, x))+(real_part(-4) + 1j * imag_part(-4)) * besselj(-4, sqrt(x^2+y^2)) * exp(1j * -4 * atan2(y, x))+(real_part(-3) + 1j * imag_part(-3)) * besselj(-3, sqrt(x^2+y^2)) * exp(1j * -3 * atan2(y, x))+(real_part(-2) + 1j * imag_part(-2)) * besselj(-2, sqrt(x^2+y^2)) * exp(1j * -2 * atan2(y, x))+(real_part(-1) + 1j * imag_part(-1)) * besselj(-1, sqrt(x^2+y^2)) * exp(1j * -1 * atan2(y, x))+(real_part(0) + 1j * imag_part(0)) * besselj(0, sqrt(x^2+y^2)) * exp(1j * 0 * atan2(y, x))+(real_part(1) + 1j * imag_part(1)) * besselj(1, sqrt(x^2+y^2)) * exp(1j * 1 * atan2(y, x))+(real_part(2) + 1j * imag_part(2)) * besselj(2, sqrt(x^2+y^2)) * exp(1j * 2 * atan2(y, x))+(real_part(3) + 1j * imag_part(3)) * besselj(3, sqrt(x^2+y^2)) * exp(1j * 3 * atan2(y, x))+(real_part(4) + 1j * imag_part(4)) * besselj(4, sqrt(x^2+y^2)) * exp(1j * 4 * atan2(y, x))+(real_part(5) + 1j * imag_part(5)) * besselj(5, sqrt(x^2+y^2)) * exp(1j * 5 * atan2(y, x))+(real_part(6) + 1j * imag_part(6)) * besselj(6, sqrt(x^2+y^2)) * exp(1j * 6 * atan2(y, x))+(real_part(7) + 1j * imag_part(7)) * besselj(7, sqrt(x^2+y^2)) * exp(1j * 7 * atan2(y, x))+(real_part(8) + 1j * imag_part(8)) * besselj(8, sqrt(x^2+y^2)) * exp(1j * 8 * atan2(y, x))+(real_part(9) + 1j * imag_part(9)) * besselj(9, sqrt(x^2+y^2)) * exp(1j * 9 * atan2(y, x))+(real_part(10) + 1j * imag_part(10)) * besselj(10, sqrt(x^2+y^2)) * exp(1j * 10 * atan2(y, x))+(real_part(11) + 1j * imag_part(11)) * besselj(11, sqrt(x^2+y^2)) * exp(1j * 11 * atan2(y, x))+(real_part(12) + 1j * imag_part(12)) * besselj(12, sqrt(x^2+y^2)) * exp(1j * 12 * atan2(y, x))+(real_part(13) + 1j * imag_part(13)) * besselj(13, sqrt(x^2+y^2)) * exp(1j * 13 * atan2(y, x))+(real_part(14) + 1j * imag_part(14)) * besselj(14, sqrt(x^2+y^2)) * exp(1j * 14 * atan2(y, x))+(real_part(15) + 1j * imag_part(15)) * besselj(15, sqrt(x^2+y^2)) * exp(1j * 15 * atan2(y, x))+(real_part(16) + 1j * imag_part(16)) * besselj(16, sqrt(x^2+y^2)) * exp(1j * 16 * atan2(y, x))+(real_part(17) + 1j * imag_part(17)) * besselj(17, sqrt(x^2+y^2)) * exp(1j * 17 * atan2(y, x))+(real_part(18) + 1j * imag_part(18)) * besselj(18, sqrt(x^2+y^2)) * exp(1j * 18 * atan2(y, x))+(real_part(19) + 1j * imag_part(19)) * besselj(19, sqrt(x^2+y^2)) * exp(1j * 19 * atan2(y, x))+(real_part(20) + 1j * imag_part(20)) * besselj(20, sqrt(x^2+y^2)) * exp(1j * 20 * atan2(y, x))');
model.component('comp1').func.create('an2', 'Analytic');
model.component('comp1').func('an2').set('expr', 'real_part(-5)');
model.component('comp1').func.remove('an2');
model.component('comp1').func('an1').set('expr', 'besselj(-20, sqrt(x^2+y^2))');
model.component('comp1').func('an1').createPlot('pg6');

model.result('pg6').run;

model.component('comp1').func('an1').set('expr', 'besselj(-20, sqrt(x^2+y^2)) * exp(1j * (-20) * atan2(y,x))');
model.component('comp1').func('an1').createPlot('pg7');

model.result('pg7').run;

model.component('comp1').func('an1').set('expr', '(real_part(-20) + 1j * imag_part(-20)) * besselj(-20, sqrt(x^2+y^2)) * exp(1j * (-20) * atan2(y, x))+(real_part(-19) + 1j * imag_part(-19)) * besselj(-19, sqrt(x^2+y^2)) * exp(1j * (-19) * atan2(y, x))+(real_part(-18) + 1j * imag_part(-18)) * besselj(-18, sqrt(x^2+y^2)) * exp(1j * (-18) * atan2(y, x))+(real_part(-17) + 1j * imag_part(-17)) * besselj(-17, sqrt(x^2+y^2)) * exp(1j * (-17) * atan2(y, x))+(real_part(-16) + 1j * imag_part(-16)) * besselj(-16, sqrt(x^2+y^2)) * exp(1j * (-16) * atan2(y, x))+(real_part(-15) + 1j * imag_part(-15)) * besselj(-15, sqrt(x^2+y^2)) * exp(1j * (-15) * atan2(y, x))+(real_part(-14) + 1j * imag_part(-14)) * besselj(-14, sqrt(x^2+y^2)) * exp(1j * (-14) * atan2(y, x))+(real_part(-13) + 1j * imag_part(-13)) * besselj(-13, sqrt(x^2+y^2)) * exp(1j * (-13) * atan2(y, x))+(real_part(-12) + 1j * imag_part(-12)) * besselj(-12, sqrt(x^2+y^2)) * exp(1j * (-12) * atan2(y, x))+(real_part(-11) + 1j * imag_part(-11)) * besselj(-11, sqrt(x^2+y^2)) * exp(1j * (-11) * atan2(y, x))+(real_part(-10) + 1j * imag_part(-10)) * besselj(-10, sqrt(x^2+y^2)) * exp(1j * (-10) * atan2(y, x))+(real_part(-9) + 1j * imag_part(-9)) * besselj(-9, sqrt(x^2+y^2)) * exp(1j * (-9) * atan2(y, x))+(real_part(-8) + 1j * imag_part(-8)) * besselj(-8, sqrt(x^2+y^2)) * exp(1j * (-8) * atan2(y, x))+(real_part(-7) + 1j * imag_part(-7)) * besselj(-7, sqrt(x^2+y^2)) * exp(1j * (-7) * atan2(y, x))+(real_part(-6) + 1j * imag_part(-6)) * besselj(-6, sqrt(x^2+y^2)) * exp(1j * (-6) * atan2(y, x))+(real_part(-5) + 1j * imag_part(-5)) * besselj(-5, sqrt(x^2+y^2)) * exp(1j * (-5) * atan2(y, x))+(real_part(-4) + 1j * imag_part(-4)) * besselj(-4, sqrt(x^2+y^2)) * exp(1j * (-4) * atan2(y, x))+(real_part(-3) + 1j * imag_part(-3)) * besselj(-3, sqrt(x^2+y^2)) * exp(1j * (-3) * atan2(y, x))+(real_part(-2) + 1j * imag_part(-2)) * besselj(-2, sqrt(x^2+y^2)) * exp(1j * (-2) * atan2(y, x))+(real_part(-1) + 1j * imag_part(-1)) * besselj(-1, sqrt(x^2+y^2)) * exp(1j * (-1) * atan2(y, x))+(real_part(0) + 1j * imag_part(0)) * besselj(0, sqrt(x^2+y^2)) * exp(1j * (0) * atan2(y, x))+(real_part(1) + 1j * imag_part(1)) * besselj(1, sqrt(x^2+y^2)) * exp(1j * (1) * atan2(y, x))+(real_part(2) + 1j * imag_part(2)) * besselj(2, sqrt(x^2+y^2)) * exp(1j * (2) * atan2(y, x))+(real_part(3) + 1j * imag_part(3)) * besselj(3, sqrt(x^2+y^2)) * exp(1j * (3) * atan2(y, x))+(real_part(4) + 1j * imag_part(4)) * besselj(4, sqrt(x^2+y^2)) * exp(1j * (4) * atan2(y, x))+(real_part(5) + 1j * imag_part(5)) * besselj(5, sqrt(x^2+y^2)) * exp(1j * (5) * atan2(y, x))+(real_part(6) + 1j * imag_part(6)) * besselj(6, sqrt(x^2+y^2)) * exp(1j * (6) * atan2(y, x))+(real_part(7) + 1j * imag_part(7)) * besselj(7, sqrt(x^2+y^2)) * exp(1j * (7) * atan2(y, x))+(real_part(8) + 1j * imag_part(8)) * besselj(8, sqrt(x^2+y^2)) * exp(1j * (8) * atan2(y, x))+(real_part(9) + 1j * imag_part(9)) * besselj(9, sqrt(x^2+y^2)) * exp(1j * (9) * atan2(y, x))+(real_part(10) + 1j * imag_part(10)) * besselj(10, sqrt(x^2+y^2)) * exp(1j * (10) * atan2(y, x))+(real_part(11) + 1j * imag_part(11)) * besselj(11, sqrt(x^2+y^2)) * exp(1j * (11) * atan2(y, x))+(real_part(12) + 1j * imag_part(12)) * besselj(12, sqrt(x^2+y^2)) * exp(1j * (12) * atan2(y, x))+(real_part(13) + 1j * imag_part(13)) * besselj(13, sqrt(x^2+y^2)) * exp(1j * (13) * atan2(y, x))+(real_part(14) + 1j * imag_part(14)) * besselj(14, sqrt(x^2+y^2)) * exp(1j * (14) * atan2(y, x))+(real_part(15) + 1j * imag_part(15)) * besselj(15, sqrt(x^2+y^2)) * exp(1j * (15) * atan2(y, x))+(real_part(16) + 1j * imag_part(16)) * besselj(16, sqrt(x^2+y^2)) * exp(1j * (16) * atan2(y, x))+(real_part(17) + 1j * imag_part(17)) * besselj(17, sqrt(x^2+y^2)) * exp(1j * (17) * atan2(y, x))+(real_part(18) + 1j * imag_part(18)) * besselj(18, sqrt(x^2+y^2)) * exp(1j * (18) * atan2(y, x))+(real_part(19) + 1j * imag_part(19)) * besselj(19, sqrt(x^2+y^2)) * exp(1j * (19) * atan2(y, x))+(real_part(20) + 1j * imag_part(20)) * besselj(20, sqrt(x^2+y^2)) * exp(1j * (20) * atan2(y, x))');

model.component('comp1').physics('ewfd').prop('BackgroundField').set('Eb', {'0' '0' 'inc_field(x/1[m], y/1[m])'});

model.component('comp1').variable('var3').active(false);
model.component('comp1').variable.create('var4');
model.component('comp1').variable('var4').set('nrefr', '1.8');
model.component('comp1').variable('var4').selection.geom('geom1', 2);
model.component('comp1').variable('var4').selection.set([4]);

model.component('comp1').func('an1').set('expr', '(real_part(-20) + 1j * imag_part(-20)) * besselj(-20, sqrt(x^2+y^2)) * exp(1j * (-20) * atan2(y, x))');

model.component('comp1').variable.create('var5');
model.component('comp1').variable('var5').set('radius', 'sqrt(root.x^2 + root.y^2) / 1[m]');
model.component('comp1').variable('var5').set('phi', 'atan2(root.y, root.x)', 'Azimuth angle');

model.component('comp1').func('an1').set('args', 'r, p');
model.component('comp1').func('an1').set('expr', '(real_part(-10) + 1j * imag_part(-10)) * besselj(-10, r) * exp(1j * (-10) * p)+(real_part(-9) + 1j * imag_part(-9)) * besselj(-9, r) * exp(1j * (-9) * p)+(real_part(-8) + 1j * imag_part(-8)) * besselj(-8, r) * exp(1j * (-8) * p)+(real_part(-7) + 1j * imag_part(-7)) * besselj(-7, r) * exp(1j * (-7) * p)+(real_part(-6) + 1j * imag_part(-6)) * besselj(-6, r) * exp(1j * (-6) * p)+(real_part(-5) + 1j * imag_part(-5)) * besselj(-5, r) * exp(1j * (-5) * p)+(real_part(-4) + 1j * imag_part(-4)) * besselj(-4, r) * exp(1j * (-4) * p)+(real_part(-3) + 1j * imag_part(-3)) * besselj(-3, r) * exp(1j * (-3) * p)+(real_part(-2) + 1j * imag_part(-2)) * besselj(-2, r) * exp(1j * (-2) * p)+(real_part(-1) + 1j * imag_part(-1)) * besselj(-1, r) * exp(1j * (-1) * p)+(real_part(0) + 1j * imag_part(0)) * besselj(0, r) * exp(1j * (0) * p)+(real_part(1) + 1j * imag_part(1)) * besselj(1, r) * exp(1j * (1) * p)+(real_part(2) + 1j * imag_part(2)) * besselj(2, r) * exp(1j * (2) * p)+(real_part(3) + 1j * imag_part(3)) * besselj(3, r) * exp(1j * (3) * p)+(real_part(4) + 1j * imag_part(4)) * besselj(4, r) * exp(1j * (4) * p)+(real_part(5) + 1j * imag_part(5)) * besselj(5, r) * exp(1j * (5) * p)+(real_part(6) + 1j * imag_part(6)) * besselj(6, r) * exp(1j * (6) * p)+(real_part(7) + 1j * imag_part(7)) * besselj(7, r) * exp(1j * (7) * p)+(real_part(8) + 1j * imag_part(8)) * besselj(8, r) * exp(1j * (8) * p)+(real_part(9) + 1j * imag_part(9)) * besselj(9, r) * exp(1j * (9) * p)+(real_part(10) + 1j * imag_part(10)) * besselj(10, r) * exp(1j * (10) * p)');
model.component('comp1').func('an1').setIndex('plotargs', '2*pi', 1, 2);
model.component('comp1').func('an1').setIndex('plotargs', 40, 0, 2);

model.component('comp1').physics('ewfd').prop('BackgroundField').set('Eb', {'0' '0' 'inc_field(radius, phi)'});

model.component('comp1').func.remove('an1');
model.component('comp1').func.remove('int1');
model.component('comp1').func.create('int1', 'Interpolation');
model.component('comp1').func('int1').set('source', 'file');
model.component('comp1').func('int1').set('filename', 'C:\Users\user\Documents\Arseniy\SWITCHING_V1\real_inc_field.csv');
model.component('comp1').func('int1').set('nargs', 1);
model.component('comp1').func('int1').setIndex('funcs', 'real_inc_field', 0, 0);
model.component('comp1').func('int1').set('filename', 'C:\Users\user\Documents\Arseniy\SWITCHING_V1\inc_field.csv');
model.component('comp1').func('int1').setIndex('funcs', 'real_inc_field', 1, 0);
model.component('comp1').func('int1').set('nargs', 2);
model.component('comp1').func('int1').setIndex('funcs', 2, 1, 1);
model.component('comp1').func('int1').setIndex('funcs', 'imag_inc_field', 1, 0);
model.component('comp1').func('int1').importData;
model.component('comp1').func('int1').setIndex('argunit', '[m]', 0);
model.component('comp1').func('int1').setIndex('argunit', '[m]', 1);
model.component('comp1').func('int1').setIndex('argunit', '1 [m]', 0);
model.component('comp1').func('int1').setIndex('argunit', '', 0);
model.component('comp1').func('int1').setIndex('argunit', '', 1);
model.component('comp1').func('int1').discardData;
model.component('comp1').func('int1').importData;
model.component('comp1').func('int1').createPlot('pg10');
model.component('comp1').func('int1').createPlot('pg9');
model.component('comp1').func('int1').createPlot('pg8');
model.component('comp1').func('int1').createPlot('pg5');
model.component('comp1').func('int1').createPlot('pg4');


model.result('pg10').run;
model.result('pg10').set('windowtitle', 'Graphics');
model.result('pg9').set('windowtitle', 'Graphics');
model.result('pg8').set('windowtitle', 'Graphics');
model.result('pg5').set('windowtitle', 'Graphics');

model.component('comp1').physics('ewfd').prop('BackgroundField').set('Eb', {'0' '0' 'real_inc_field(x/1[m], y/1[m]) + 1j * imag_inc_field(x/1[m], y/1[m])'});

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').variable('var4').set('nrefr', '2');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result.table.create('evl2', 'Table');
model.result.table('evl2').comments('Interactive 2D values');
model.result.table('evl2').label('Evaluation 2D');
model.result.table('evl2').addRow([1.862534523010254 -3.6098484992980957 0.10881513645028032], [0 0 0]);
model.result('pg2').run;

model.param.set('q', '35');

model.component('comp1').func('int1').discardData;
model.component('comp1').func('int1').importData;
model.component('comp1').func('int1').createPlot('pg11');

model.result('pg11').run;

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.param.set('q', '20');

model.component('comp1').func('int1').discardData;
model.component('comp1').func('int1').importData;

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg3').run;
model.result('pg2').run;

model.label('2dScattering.mph');

model.result('pg2').run;
model.result('pg9').run;
model.result('pg5').run;
model.result('pg8').run;
model.result('pg10').run;
model.result('pg3').run;
model.result('pg2').run;
model.result('pg2').run;

model.component('comp1').func('int1').discardData;
model.component('comp1').func('int1').importData;

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').func('int1').discardData;
model.component('comp1').func('int1').importData;

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;
model.result('pg11').run;

model.component('comp1').func('int1').discardData;
model.component('comp1').func('int1').importData;
model.component('comp1').func('int1').discardData;
model.component('comp1').func('int1').importData;

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;

model.component('comp1').func('int1').discardData;
model.component('comp1').func('int1').importData;

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').func.create('wv1', 'Wave');
model.component('comp1').func.remove('wv1');

model.label('2dScattering.mph');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;
model.result('pg5').run;
model.result('pg8').run;
model.result('pg9').run;
model.result('pg10').run;
model.result('pg11').run;
model.result.dataset.remove('dset1');
model.result.dataset.remove('an1_ds1');
model.result.dataset.remove('an1_ds4');
model.result.dataset.remove('an1_ds5');
model.result.dataset.remove('int1_ds1');
model.result.dataset.remove('int1_ds2');

model.component('comp1').func('int1').discardData;
model.component('comp1').func('int1').importData;
model.component('comp1').func('int1').discardData;
model.component('comp1').func('int1').set('filename', 'C:\Users\user\Documents\Arseniy\SWITCHING_V1\incArlen2D.csv');
model.component('comp1').func('int1').refresh;
model.component('comp1').func('int1').importData;

model.param.set('q', '5');

model.component('comp1').variable('var4').set('nrefr', '1.5');

model.component('comp1').mesh('mesh1').run;

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result.dataset.create('dset1', 'Solution');
model.result.dataset('dset1').set('solution', 'sol1');
model.result.dataset('dset1').set('comp', 'none');
model.result.dataset('dset1').set('geom', 'geom1');
model.result.dataset('dset1').set('comp', 'comp1');

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
model.result('pg2').run;
model.result('pg1').run;
model.result.duplicate('pg3', 'pg1');
model.result('pg3').run;
model.result('pg3').label('Inc Field');
model.result('pg3').run;
model.result('pg3').feature('surf1').set('expr', 'ewfd.Ebr');
model.result('pg3').feature('surf1').set('descr', 'ewfd.Ebr Background electric field, z-component');
model.result('pg3').feature('surf1').set('expr', 'abs(ewfd.Ebz)');
model.result('pg3').run;
model.result('pg3').feature('surf1').set('expr', 'real(ewfd.Ebz)');
model.result('pg3').run;

model.component('comp1').physics('ewfd').prop('BackgroundField').set('Eb', {'0' '0' 'exp(1j*2*pi/lambda*x)'});

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;
model.result('pg3').run;

model.component('comp1').physics('ewfd').prop('BackgroundField').set('Eb', {'0' '0' 'exp(1j*2*pi/lambda*x)*0 + 1 * (real_inc_field(x/1[m], y/1[m]) + 1j * imag_inc_field(x/1[m], y/1[m]))'});

model.component('comp1').func('int1').discardData;
model.component('comp1').func('int1').refresh;
model.component('comp1').func('int1').importData;

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;
model.result('pg3').run;
model.result('pg3').run;

model.component('comp1').physics('ewfd').prop('components').set('components', 'threecomponent');

model.component('comp1').func('int1').discardData;
model.component('comp1').func('int1').refresh;
model.component('comp1').func('int1').importData;

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;
model.result('pg3').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('c2').set('r', 4);
model.component('comp1').geom('geom1').run('fin');

model.param.set('q', '20');

model.study('std1').create('param', 'Parametric');

model.component('comp1').variable('var4').set('nrefr', 'nrefr0');

model.param.set('nrefr0', '1.8');

model.study('std1').feature('param').setIndex('pname', 'q', 0);
model.study('std1').feature('param').setIndex('plistarr', '', 0);
model.study('std1').feature('param').setIndex('punit', '', 0);
model.study('std1').feature('param').setIndex('pname', 'q', 0);
model.study('std1').feature('param').setIndex('plistarr', '', 0);
model.study('std1').feature('param').setIndex('punit', '', 0);
model.study('std1').feature('param').setIndex('pname', 'nrefr0', 0);
model.study('std1').feature('param').setIndex('plistarr', '(1.8, 2)', 0);
model.study('std1').feature('param').setIndex('plistarr', '{1.8, 2}', 0);

model.component('comp1').func('int1').discardData;
model.component('comp1').func('int1').refresh;
model.component('comp1').func('int1').importData;

model.component('comp1').mesh('mesh1').run;

model.batch.create('p1', 'Parametric');
model.batch('p1').study('std1');
model.batch('p1').create('so1', 'Solutionseq');
model.batch('p1').feature('so1').set('seq', 'sol1');
model.batch('p1').feature('so1').set('store', 'on');
model.batch('p1').feature('so1').set('clear', 'on');
model.batch('p1').feature('so1').set('psol', 'none');
model.batch('p1').set('pname', {'nrefr0'});
model.batch('p1').set('plistarr', {'{1.8, 2}'});
model.batch('p1').set('sweeptype', 'sparse');
model.batch('p1').set('probesel', 'all');
model.batch('p1').set('probes', {});
model.batch('p1').set('plot', 'off');
model.batch('p1').set('err', 'on');
model.batch('p1').attach('std1');
model.batch('p1').set('control', 'param');

model.sol.create('sol2');
model.sol('sol2').study('std1');
model.sol('sol2').label('Parametric Solutions 1');

model.batch('p1').feature('so1').set('psol', 'sol2');
model.batch('p1').run('compute');

model.result.create('pg4', 'PlotGroup2D');
model.result('pg4').label('Electric Field (ewfd) 1');
model.result('pg4').set('data', 'dset2');
model.result('pg4').setIndex('looplevel', 2, 0);
model.result('pg4').set('frametype', 'spatial');
model.result('pg4').set('defaultPlotID', 'ElectromagneticWavesFrequencyDomain/phys1/pdef1/pcond2/pg1');
model.result('pg4').feature.create('surf1', 'Surface');
model.result('pg4').feature('surf1').set('smooth', 'internal');
model.result('pg4').feature('surf1').set('data', 'parent');
model.result.create('pg5', 'PolarGroup');
model.result('pg5').label('2D Far Field (ewfd) 1');
model.result('pg5').set('data', 'dset2');
model.result('pg5').create('rp1', 'RadiationPattern');
model.result('pg5').feature('rp1').set('legend', 'on');
model.result('pg5').feature('rp1').set('phidisc', '180');
model.result('pg5').feature('rp1').set('expr', {'ewfd.normEfar'});
model.result('pg5').feature('rp1').create('exp1', 'Export');
model.result('pg5').feature('rp1').feature('exp1').setIndex('expr', 'comp1.ewfd.phi', 0);
model.result('pg4').run;
model.result('pg5').run;
model.result('pg2').run;
model.result('pg5').run;

model.param.set('q', '10');

model.component('comp1').func('int1').discardData;
model.component('comp1').func('int1').importData;

model.batch('p1').run('compute');

model.result('pg4').run;
model.result('pg2').run;
model.result('pg5').run;

model.component('comp1').func('int1').discardData;
model.component('comp1').func('int1').importData;

model.batch('p1').run('compute');

model.result('pg4').run;
model.result('pg5').run;

model.component('comp1').func('int1').discardData;
model.component('comp1').func('int1').refresh;
model.component('comp1').func('int1').importData;

model.batch('p1').run('compute');

model.result('pg4').run;
model.result('pg5').run;
model.result('pg5').setIndex('looplevelinput', 'first', 0);
model.result('pg5').run;
model.result('pg1').run;
model.result('pg4').run;
model.result('pg5').run;
model.result('pg1').run;
model.result('pg5').run;
model.result('pg5').set('windowtitle', 'Graphics');
model.result('pg4').set('windowtitle', 'Graphics');
model.result('pg3').set('windowtitle', 'Graphics');
model.result('pg2').set('windowtitle', 'Graphics');
model.result('pg1').set('windowtitle', 'Graphics');
model.result('pg5').set('window', 'window2');
model.result('pg5').set('windowtitle', 'Plot 2');
model.result('pg5').set('window', 'window2');
model.result('pg5').set('windowtitle', 'Plot 2');
model.result('pg5').run;
model.result('pg5').set('window', 'graphics');
model.result('pg5').set('windowtitle', '');
model.result('pg1').run;

model.component('comp1').func('int1').discardData;
model.component('comp1').func('int1').refresh;
model.component('comp1').func('int1').importData;

model.batch('p1').run('compute');

model.result('pg4').run;
model.result('pg5').run;
model.result('pg3').run;
model.result('pg1').run;
model.result('pg1').set('data', 'dset2');
model.result('pg1').setIndex('looplevel', 1, 0);
model.result('pg5').run;
model.result('pg1').run;
model.result('pg5').run;
model.result('pg5').set('window', 'window2');
model.result('pg5').set('windowtitle', 'Plot 2');
model.result('pg5').set('window', 'window2');
model.result('pg5').set('windowtitle', 'Plot 2');
model.result('pg5').run;
model.result('pg5').set('window', 'graphics');
model.result('pg5').set('windowtitle', '');
model.result('pg5').setIndex('looplevelinput', 'all', 0);
model.result('pg5').setIndex('looplevelinput', 'last', 0);
model.result('pg5').run;
model.result('pg5').setIndex('looplevelinput', 'all', 0);
model.result('pg5').set('window', 'window2');
model.result('pg5').set('windowtitle', 'Plot 2');
model.result('pg5').set('window', 'window2');
model.result('pg5').set('windowtitle', 'Plot 2');
model.result('pg5').run;
model.result('pg5').set('window', 'graphics');
model.result('pg5').set('windowtitle', '');
model.result('pg1').run;

model.param.set('q', '20');

model.study('std1').feature('param').setIndex('plistarr', '{1.8, 2.1}', 0);

model.component('comp1').func('int1').discardData;
model.component('comp1').func('int1').refresh;
model.component('comp1').func('int1').importData;

model.batch('p1').run('compute');

model.result('pg1').run;
model.result('pg5').run;
model.result('pg5').set('window', 'window2');
model.result('pg5').set('windowtitle', 'Plot 2');
model.result('pg5').set('window', 'window2');
model.result('pg5').set('windowtitle', 'Plot 2');
model.result('pg5').run;
model.result('pg5').set('window', 'graphics');
model.result('pg5').set('windowtitle', '');
model.result('pg1').run;

model.label('2dScattering.mph');

model.result('pg1').run;
model.result.dataset.remove('dset1');
model.result.dataset.remove('dset2');

model.label('2dScattering.mph');

model.component('comp1').geom('geom1').feature.remove('c1');
model.component('comp1').geom('geom1').run('c2');
model.component('comp1').geom('geom1').feature.remove('ls1');
model.component('comp1').geom('geom1').create('pc1', 'ParametricCurve');
model.component('comp1').geom('geom1').feature('pc1').set('parname', 't');
model.component('comp1').geom('geom1').feature('pc1').set('parmax', '2*pi');
model.component('comp1').geom('geom1').feature('pc1').set('coord', {'(sin(3*t)*0.2 - 0.1 *sin(4*t)) * cos(t)' ''});
model.component('comp1').geom('geom1').feature('pc1').setIndex('coord', '(sin(3*t)*0.2 - 0.1 *sin(4*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').run('pc1');
model.component('comp1').geom('geom1').feature('pc1').setIndex('coord', '(1 + sin(3*t)*0.2 - 0.1 *sin(4*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc1').setIndex('coord', '(1  + sin(3*t)*0.2 - 0.1 *sin(4*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').run('pc1');
model.component('comp1').geom('geom1').feature('pc1').setIndex('coord', '(1 + sin(3*t)*0.2 - 0.1 *sin(4*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').feature('pc1').setIndex('coord', '(1 + sin(2*t)*0.2 - 0.1 *sin(4*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc1').setIndex('coord', '(1 + sin(2*t)*0.2 - 0.1 *sin(4*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').feature('pc1').setIndex('coord', '(1 + sin(2*t)*0.2 - 0.1 *sin(3*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc1').setIndex('coord', '(1 + sin(2*t)*0.2 - 0.1 *sin(3*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').run('pc1');
model.component('comp1').geom('geom1').run;

model.component('comp1').variable('var4').selection.set([6]);
model.component('comp1').variable('var4').set('nrefr', '3');

model.component('comp1').physics('ewfd').feature('ffd1').selection.set([5]);

model.component('comp1').mesh('mesh1').feature('ftri1').selection.set([5]);
model.component('comp1').mesh('mesh1').feature('ftri2').selection.set([6]);
model.component('comp1').mesh('mesh1').run;

model.param.set('q', '10');

model.component('comp1').mesh('mesh1').run;

model.result.dataset.create('dset1', 'Solution');
model.result.dataset('dset1').set('solution', 'sol1');
model.result.dataset('dset1').set('comp', 'none');
model.result.dataset('dset1').set('geom', 'geom1');
model.result.dataset('dset1').set('comp', 'comp1');
model.result.dataset.create('dset2', 'Solution');
model.result.dataset('dset2').set('solution', 'sol2');
model.result.dataset('dset2').set('comp', 'none');
model.result.dataset('dset2').set('geom', 'geom1');
model.result.dataset('dset2').set('comp', 'comp1');
model.result.dataset.move('dset2', 1);
model.result.dataset('dset2').tag('dset2');
model.result.create('pg1', 'PlotGroup2D');
model.result('pg1').label('Electric Field (ewfd)');
model.result('pg1').set('data', 'dset2');
model.result('pg1').set('frametype', 'spatial');
model.result('pg1').set('defaultPlotID', 'ElectromagneticWavesFrequencyDomain/phys1/pdef1/pcond2/pg1');
model.result('pg1').feature.create('surf1', 'Surface');
model.result('pg1').feature('surf1').set('smooth', 'internal');
model.result('pg1').feature('surf1').set('data', 'parent');
model.result.create('pg2', 'PolarGroup');
model.result('pg2').label('2D Far Field (ewfd)');
model.result('pg2').set('data', 'dset2');
model.result('pg2').create('rp1', 'RadiationPattern');
model.result('pg2').feature('rp1').set('legend', 'on');
model.result('pg2').feature('rp1').set('phidisc', '180');
model.result('pg2').feature('rp1').set('expr', {'ewfd.normEfar'});
model.result('pg2').feature('rp1').create('exp1', 'Export');
model.result('pg2').feature('rp1').feature('exp1').setIndex('expr', 'comp1.ewfd.phi', 0);
model.result.remove('pg2');
model.result.remove('pg1');

model.component('comp1').variable('var1').selection.set([1 2 3 4 5]);

model.result.create('pg1', 'PlotGroup2D');
model.result('pg1').label('Electric Field (ewfd)');
model.result('pg1').set('data', 'dset2');
model.result('pg1').set('frametype', 'spatial');
model.result('pg1').set('defaultPlotID', 'ElectromagneticWavesFrequencyDomain/phys1/pdef1/pcond2/pg1');
model.result('pg1').feature.create('surf1', 'Surface');
model.result('pg1').feature('surf1').set('smooth', 'internal');
model.result('pg1').feature('surf1').set('data', 'parent');
model.result.create('pg2', 'PolarGroup');
model.result('pg2').label('2D Far Field (ewfd)');
model.result('pg2').set('data', 'dset2');
model.result('pg2').create('rp1', 'RadiationPattern');
model.result('pg2').feature('rp1').set('legend', 'on');
model.result('pg2').feature('rp1').set('phidisc', '180');
model.result('pg2').feature('rp1').set('expr', {'ewfd.normEfar'});
model.result('pg2').feature('rp1').create('exp1', 'Export');
model.result('pg2').feature('rp1').feature('exp1').setIndex('expr', 'comp1.ewfd.phi', 0);
model.result.remove('pg2');
model.result.remove('pg1');

model.study('std1').feature('param').active(false);

model.batch.remove('p1');

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
model.result.remove('pg2');
model.result.remove('pg1');

model.study('std1').feature.remove('param');

model.sol.remove('sol1');
model.sol.remove('sol2');

model.component('comp1').mesh('mesh1').run;

model.component('comp1').physics('ewfd').prop('BackgroundField').set('Eb', {'0' '0' 'exp(1j*2*pi/lambda*x)*1 +0 * (real_inc_field(x/1[m], y/1[m]) + 1j * imag_inc_field(x/1[m], y/1[m]))'});

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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
model.result('pg2').run;

model.component('comp1').physics('ewfd').prop('BackgroundField').set('Eb', {'0' '0' 'exp(-1j*2*pi/lambda*x)*1 +0 * (real_inc_field(x/1[m], y/1[m]) + 1j * imag_inc_field(x/1[m], y/1[m]))'});

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc1').setIndex('coord', '(1 + sin(2*t)*0.05 - 0.1 *sin(3*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc1').setIndex('coord', '(1 + sin(2*t)*0.05 - 0.1 *sin(3*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').feature('pc1').setIndex('coord', '(1 + sin(2*t)*0.05 - 0.15 *sin(3*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc1').setIndex('coord', '(1 + sin(2*t)*0.05 - 0.15 *sin(3*t)) * sin(t)', 1);

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc1').setIndex('coord', '(1 + sin(2*t)*0.05 - 0.05 *sin(3*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc1').setIndex('coord', '(1 + sin(2*t)*0.05 - 0.05 *sin(3*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').run('pc1');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').mesh('mesh1').feature('ftri2').feature('size1').set('hmax', 'lambda/18');
model.component('comp1').mesh('mesh1').feature('ftri1').create('size1', 'Size');
model.component('comp1').mesh('mesh1').feature('ftri1').feature('size1').set('custom', true);
model.component('comp1').mesh('mesh1').feature('ftri1').feature('size1').set('hmaxactive', true);
model.component('comp1').mesh('mesh1').feature('ftri1').feature('size1').set('hmax', 'lambda/14');
model.component('comp1').mesh('mesh1').feature('size').set('hmax', 'lambda/8');
model.component('comp1').mesh('mesh1').run;

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').mesh('mesh1').feature('ftri2').feature('size1').set('hmax', 'lambda/20');
model.component('comp1').mesh('mesh1').run('ftri2');
model.component('comp1').mesh('mesh1').run('map1');
model.component('comp1').mesh('mesh1').run('ftri1');
model.component('comp1').mesh('mesh1').run('ftri2');
model.component('comp1').mesh('mesh1').feature.move('ftri2', 2);
model.component('comp1').mesh('mesh1').run('ftri2');
model.component('comp1').mesh('mesh1').feature('ftri2').feature('size1').set('hmax', 'lambda/26');
model.component('comp1').mesh('mesh1').run('ftri2');
model.component('comp1').mesh('mesh1').feature('ftri2').feature('size1').selection.set([6]);
model.component('comp1').mesh('mesh1').run('ftri2');
model.component('comp1').mesh('mesh1').feature('ftri2').feature('size1').set('hmax', 'lambda/18');
model.component('comp1').mesh('mesh1').run('ftri2');
model.component('comp1').mesh('mesh1').run;

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc1').setIndex('coord', '-(1 + sin(2*t)*0.05 - 0.05 *sin(3*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').runPre('fin');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc1').setIndex('coord', '(1 + sin(2*t)*0.0 - 0.05 *sin(3*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc1').setIndex('coord', '-(1 + sin(2*t)*0.0 - 0.05 *sin(3*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').feature('pc1').setIndex('coord', '(1 + sin(2*t)*0.0 - 0.15 *sin(3*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc1').setIndex('coord', '-(1 + sin(2*t)*0.0 + 0.15 *sin(3*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').feature('pc1').setIndex('coord', '(1 + sin(2*t)*0.0 + 0.15 *sin(3*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').run('pc1');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;
model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').variable('var1').set('nrefr', '2');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;

model.component('comp1').variable('var1').selection.set([5]);

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.component('comp1').variable('var1').selection.set([1 2 3 4 5]);
model.component('comp1').variable('var2').active(true);
model.component('comp1').variable('var2').selection.set([1 2 3 4]);
model.component('comp1').variable('var2').set('nrefr', '1');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.component('comp1').variable('var1').selection.set([4 5]);

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.component('comp1').variable('var1').selection.set([5]);

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;

model.component('comp1').physics('ewfd').feature('wee1').set('DisplacementFieldModel', 'RelativePermittivity');
model.component('comp1').physics('ewfd').feature('wee1').set('epsilonr_mat', 'userdef');
model.component('comp1').physics('ewfd').feature('wee1').set('epsilonr', {'nrefr^2' '0' '0' '0' 'nrefr^2' '0' '0' '0' 'nrefr^2'});

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.component('comp1').physics('ewfd').feature('wee1').set('mur_mat', 'userdef');
model.component('comp1').physics('ewfd').feature('wee1').set('sigma_mat', 'userdef');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').variable('var2').selection.set([]);
model.component('comp1').variable('var1').selection.set([1 2 3 4 5]);

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').physics('ewfd').prop('BackgroundField').set('Eb', {'0' '0' 'exp(-1j*2*pi/lambda*x*2)*1 +0 * (real_inc_field(x/1[m], y/1[m]) + 1j * imag_inc_field(x/1[m], y/1[m]))'});

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature.duplicate('pc2', 'pc1');
model.component('comp1').geom('geom1').feature('pc2').active(false);
model.component('comp1').geom('geom1').run;
model.component('comp1').geom('geom1').feature('pc1').setIndex('coord', 't', 0);
model.component('comp1').geom('geom1').feature('pc1').set('parmax', 1);
model.component('comp1').geom('geom1').feature('pc1').set('coord', {'t' '0.8*(1 - t^4)^(1/4)'});
model.component('comp1').geom('geom1').run('pc1');
model.component('comp1').geom('geom1').feature('pc1').set('parmax', 2);
model.component('comp1').geom('geom1').run('c2');
model.component('comp1').geom('geom1').feature('pc1').set('coord', {'t' 'real(0.8*(1 - t^4)^(1/4))'});
model.component('comp1').geom('geom1').run('pc1');
model.component('comp1').geom('geom1').feature('pc1').set('coord', {'t' 'abs(0.8*(1 - t^4)^(1/4))'});
model.component('comp1').geom('geom1').run('pc1');
model.component('comp1').geom('geom1').feature('pc1').set('coord', {'t' '(0.8*(1 - t^4)^(1/4))'});
model.component('comp1').geom('geom1').feature('pc1').set('parmax', 1);
model.component('comp1').geom('geom1').run('pc1');
model.component('comp1').geom('geom1').feature('pc1').set('parmin', -1);
model.component('comp1').geom('geom1').run('pc1');
model.component('comp1').geom('geom1').create('mir1', 'Mirror');
model.component('comp1').geom('geom1').feature('mir1').selection('input').set({'pc1'});
model.component('comp1').geom('geom1').run('mir1');
model.component('comp1').geom('geom1').feature('mir1').set('axis', [0 1]);
model.component('comp1').geom('geom1').run('mir1');
model.component('comp1').geom('geom1').feature('mir1').set('keep', true);
model.component('comp1').geom('geom1').run('mir1');
model.component('comp1').geom('geom1').run('fin');

model.component('comp1').mesh('mesh1').run;

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;

model.component('comp1').variable('var1').set('nrefr', '1');

model.result('pg2').run;
model.result('pg2').feature('rp1').set('phidisc', 720);
model.result('pg2').run;

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').physics('ewfd').prop('BackgroundField').set('Eb', {'0' '0' 'exp(-1j*2*pi/lambda*x)*1 +0 * (real_inc_field(x/1[m], y/1[m]) + 1j * imag_inc_field(x/1[m], y/1[m]))'});

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.param.set('q', '15');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc1').set('coord', {'t' '(0.75*(1 - t^8)^(1/8))'});
model.component('comp1').geom('geom1').run('pc1');
model.component('comp1').geom('geom1').run('fin');

model.component('comp1').mesh('mesh1').run;

model.component('comp1').geom('geom1').feature('pc1').set('parmin', -0.9);
model.component('comp1').geom('geom1').feature('pc1').set('parmax', 0.9);
model.component('comp1').geom('geom1').run('pc1');
model.component('comp1').geom('geom1').feature('pc1').set('parmin', -0.99);
model.component('comp1').geom('geom1').feature('pc1').set('parmax', 0.99);
model.component('comp1').geom('geom1').run('pc1');
model.component('comp1').geom('geom1').feature('pc1').set('parmin', -0.9999);
model.component('comp1').geom('geom1').feature('pc1').set('parmax', 0.9999);
model.component('comp1').geom('geom1').run('pc1');
model.component('comp1').geom('geom1').run('mir1');
model.component('comp1').geom('geom1').run('fin');
model.component('comp1').geom('geom1').run('pc2');
model.component('comp1').geom('geom1').create('ls1', 'LineSegment');
model.component('comp1').geom('geom1').feature('ls1').selection('vertex2').set('pc1', 1);
model.component('comp1').geom('geom1').feature('ls1').selection('vertex2').clear('pc1');
model.component('comp1').geom('geom1').feature('ls1').selection('vertex2').set('mir1', [1]);
model.component('comp1').geom('geom1').feature('ls1').selection('vertex2').clear('mir1');
model.component('comp1').geom('geom1').feature('ls1').selection('vertex2').set('pc1', [1]);
model.component('comp1').geom('geom1').feature('ls1').selection('vertex1').set('pc1', 1);
model.component('comp1').geom('geom1').feature('ls1').selection('vertex2').clear('pc1');
model.component('comp1').geom('geom1').feature('ls1').selection('vertex2').set('mir1', [1]);
model.component('comp1').geom('geom1').run('ls1');
model.component('comp1').geom('geom1').feature.duplicate('ls2', 'ls1');
model.component('comp1').geom('geom1').feature('ls2').selection('vertex1').set('pc1', [2]);
model.component('comp1').geom('geom1').feature('ls2').selection('vertex2').set('mir1', [2]);
model.component('comp1').geom('geom1').run('ls2');
model.component('comp1').geom('geom1').run('fin');

model.component('comp1').mesh('mesh1').run;

model.component('comp1').variable('var4').selection.set([3]);

model.component('comp1').mesh('mesh1').run;
model.component('comp1').mesh('mesh1').feature('ftri2').feature('size1').selection.set([4]);
model.component('comp1').mesh('mesh1').feature('ftri1').feature('size1').selection.set([3]);
model.component('comp1').mesh('mesh1').run;

model.component('comp1').variable('var1').selection.set([1 2 4 5 6]);

model.component('comp1').physics('ewfd').feature('ffd1').selection.set([4]);

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc1').set('coord', {'t' '(0.9*(1 - t^10)^(1/10))'});
model.component('comp1').geom('geom1').run('pc1');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc1').set('coord', {'t' '(0.9*(1 - t^4)^(1/4))'});
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('pc1').set('coord', {'t' '(0.9*(1 - t^2.5)^(1/2.5))'});
model.component('comp1').geom('geom1').run('c2');
model.component('comp1').geom('geom1').feature('pc1').set('coord', {'t' '(0.9*(1 - t^3)^(1/3))'});
model.component('comp1').geom('geom1').run('pc1');
model.component('comp1').geom('geom1').feature('pc1').set('coord', {'t' '(abs(0.9*(1 - t^3))^(1/3))'});
model.component('comp1').geom('geom1').run('pc1');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('pc1').set('coord', {'t' '(abs(0.9*(1 - t^4))^(1/4))'});
model.component('comp1').geom('geom1').runPre('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc1').set('coord', {'t' '((0.9*(1 - t^40))^(1/40))'});
model.component('comp1').geom('geom1').feature('pc1').set('parmin', -0.999999);
model.component('comp1').geom('geom1').feature('pc1').set('parmax', 0.9999999);
model.component('comp1').geom('geom1').run('pc1');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('pc1').set('coord', {'t' '((0.9*(1 - t^100))^(1/100))'});
model.component('comp1').geom('geom1').runPre('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;
model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('ls2').active(false);
model.component('comp1').geom('geom1').feature('ls1').active(false);
model.component('comp1').geom('geom1').feature('pc1').active(false);
model.component('comp1').geom('geom1').feature('mir1').active(false);
model.component('comp1').geom('geom1').feature.move('pc2', 1);
model.component('comp1').geom('geom1').nodeGroup.create('grp1');
model.component('comp1').geom('geom1').nodeGroup('grp1').placeAfter('pc2');
model.component('comp1').geom('geom1').nodeGroup('grp1').add('pc1');
model.component('comp1').geom('geom1').nodeGroup('grp1').add('mir1');
model.component('comp1').geom('geom1').nodeGroup('grp1').add('ls1');
model.component('comp1').geom('geom1').nodeGroup('grp1').add('ls2');
model.component('comp1').geom('geom1').feature('pc2').active(true);
model.component('comp1').geom('geom1').feature('pc2').setIndex('coord', '(1 + 0.15 *sin(3*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc2').setIndex('coord', '-(1 +0.15 *sin(3*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').feature('pc2').setIndex('coord', '(1 + 0.1 *sin(3*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc2').setIndex('coord', '-(1 +0.1 *sin(3*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').feature('pc2').setIndex('coord', '(1 + 0.1 *sin(6*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc2').setIndex('coord', '-(1 +0.1 *sin(6*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').run('pc2');
model.component('comp1').geom('geom1').feature('pc2').setIndex('coord', '(1 +0.1 *sin(6*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').run('pc2');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc2').setIndex('coord', '(1 + 0.1 *sin(4*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc2').setIndex('coord', '(1 +0.1 *sin(4*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').feature('pc2').setIndex('coord', '(1 + 0.05 *sin(4*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc2').setIndex('coord', '-(1 +0.05 *sin(4*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').run('pc2');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').create('rot1', 'Rotate');
model.component('comp1').geom('geom1').nodeGroup('grp1').remove('rot1', false);
model.component('comp1').geom('geom1').feature('rot1').selection('input').set({'pc2'});
model.component('comp1').geom('geom1').feature('rot1').set('rot', 45);
model.component('comp1').geom('geom1').run('rot1');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('rot1').set('rot', 30);
model.component('comp1').geom('geom1').run('rot1');
model.component('comp1').geom('geom1').feature('rot1').set('rot', 15);
model.component('comp1').geom('geom1').run('rot1');
model.component('comp1').geom('geom1').feature('rot1').set('rot', 20);
model.component('comp1').geom('geom1').run('rot1');
model.component('comp1').geom('geom1').feature('rot1').set('rot', 'pi/9 [rad]');
model.component('comp1').geom('geom1').run('rot1');
model.component('comp1').geom('geom1').feature('rot1').set('rot', 'pi/10 [rad]');
model.component('comp1').geom('geom1').run('rot1');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('rot1').set('rot', 'pi/4 [rad]');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run('rot1');
model.component('comp1').geom('geom1').feature('rot1').set('rot', 15);
model.component('comp1').geom('geom1').run('rot1');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('rot1').set('rot', -15);
model.component('comp1').geom('geom1').runPre('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('c2').set('r', 8);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('pc2').set('pos', [1.1 1.1]);
model.component('comp1').geom('geom1').run('pc2');
model.component('comp1').geom('geom1').feature.duplicate('pc3', 'pc2');
model.component('comp1').geom('geom1').feature.duplicate('pc4', 'pc3');
model.component('comp1').geom('geom1').feature.duplicate('pc5', 'pc4');
model.component('comp1').geom('geom1').feature('pc3').set('pos', [-1.1 1.1]);
model.component('comp1').geom('geom1').feature('pc4').set('pos', [1.1 -1.1]);
model.component('comp1').geom('geom1').feature('pc5').set('pos', [-1.1 -1.1]);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('pc2').set('pos', {'d' 'd'});
model.component('comp1').geom('geom1').feature('pc3').set('pos', {'-d' 'd'});
model.component('comp1').geom('geom1').feature('pc4').set('pos', {'d' '-d'});
model.component('comp1').geom('geom1').feature('pc5').set('pos', {'-d' '-d'});

model.param.set('d', '1.5');

model.component('comp1').geom('geom1').run('fin');
model.component('comp1').geom('geom1').run('pc2');
model.component('comp1').geom('geom1').run('pc3');
model.component('comp1').geom('geom1').run('pc4');
model.component('comp1').geom('geom1').run('pc5');
model.component('comp1').geom('geom1').run('fin');
model.component('comp1').geom('geom1').feature('rot1').active(false);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run;

model.component('comp1').variable('var2').selection.set([]);
model.component('comp1').variable('var2').active(false);

model.component('comp1').mesh('mesh1').run;

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;
model.result('pg1').run;
model.result('pg2').run;

model.param.set('d', '2.5');

model.component('comp1').geom('geom1').run('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;

model.label('2dScattering_multi.mph');

model.result('pg2').run;

model.component('comp1').geom('geom1').nodeGroup.create('grp2');
model.component('comp1').geom('geom1').nodeGroup('grp2').placeAfter('c2');
model.component('comp1').geom('geom1').nodeGroup('grp2').add('pc2');
model.component('comp1').geom('geom1').nodeGroup('grp2').add('pc3');
model.component('comp1').geom('geom1').nodeGroup('grp2').add('pc4');
model.component('comp1').geom('geom1').nodeGroup('grp2').add('pc5');
model.component('comp1').geom('geom1').nodeGroup('grp2').active(false);
model.component('comp1').geom('geom1').run('rot1');
model.component('comp1').geom('geom1').create('c3', 'Circle');
model.component('comp1').geom('geom1').feature('c3').set('pos', [0 1.5]);
model.component('comp1').geom('geom1').run('c3');
model.component('comp1').geom('geom1').feature.duplicate('c4', 'c3');
model.component('comp1').geom('geom1').feature('c4').set('pos', [0 -1.5]);
model.component('comp1').geom('geom1').run('c4');
model.component('comp1').geom('geom1').run;

model.component('comp1').variable('var4').selection.set([6 7]);

model.component('comp1').mesh('mesh1').feature('ftri2').selection.set([6 7]);

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('c3').set('pos', [0 1.9]);
model.component('comp1').geom('geom1').feature('c4').set('pos', [0 -1.9]);
model.component('comp1').geom('geom1').runPre('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('c4').active(false);
model.component('comp1').geom('geom1').feature('c3').set('pos', [0 0]);

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;

model.param.set('q', '20');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;
model.result('pg1').run;
model.result('pg2').run;

model.param.set('q', '10');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.label('2dScattering_multi.mph');

model.result('pg2').run;

model.component('comp1').geom('geom1').feature('c4').active(true);
model.component('comp1').geom('geom1').feature('c4').set('pos', [0 -2]);
model.component('comp1').geom('geom1').feature('c3').set('pos', [0 2]);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run;

model.component('comp1').variable('var4').selection.set([6 7]);
model.component('comp1').variable('var4').set('nrefr', '2.9941 + 0.0395j');

model.component('comp1').physics('ewfd').prop('components').set('components', 'outofplane');

model.component('comp1').mesh('mesh1').feature('ftri2').selection.set([6 7]);
model.component('comp1').mesh('mesh1').run;

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('c4').set('pos', [0 -3]);
model.component('comp1').geom('geom1').feature('c3').set('pos', [0 3]);
model.component('comp1').geom('geom1').runPre('fin');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').variable('var4').set('nrefr', '1.5');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('c3').active(false);
model.component('comp1').geom('geom1').feature('c4').active(false);
model.component('comp1').geom('geom1').nodeGroup('grp2').active(true);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run;

model.component('comp1').variable('var4').set('nrefr', '3');
model.component('comp1').variable('var4').selection.set([6 7 8 9]);

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.component('comp1').variable('var1').selection.set([1 2 3 4 5]);

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.component('comp1').physics('ewfd').feature('ffd1').selection.set([5]);

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;

model.component('comp1').mesh('mesh1').feature('ftri2').feature('size1').selection.set([6 7 8 9]);
model.component('comp1').mesh('mesh1').feature('ftri2').selection.set([6 7 8 9]);
model.component('comp1').mesh('mesh1').feature('ftri1').selection.set([5]);
model.component('comp1').mesh('mesh1').run;

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.param.set('d', '1.25');

model.component('comp1').geom('geom1').run('fin');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;

model.param.set('d', '5');

model.component('comp1').geom('geom1').run('fin');
model.component('comp1').geom('geom1').feature('c2').set('r', 14);
model.component('comp1').geom('geom1').run('c2');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run;

model.component('comp1').variable('var4').selection.set([6 7 8 9]);

model.component('comp1').physics('ewfd').feature('ffd1').selection.set([5]);

model.component('comp1').mesh('mesh1').feature('ftri1').selection.set([5]);
model.component('comp1').mesh('mesh1').feature('ftri2').selection.set([6 7 8 9]);

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.component('comp1').variable('var1').selection.set([1 2 3 4 5]);

model.component('comp1').mesh('mesh1').feature('ftri2').feature('size1').set('hmax', 'lambda/12');
model.component('comp1').mesh('mesh1').feature('ftri1').feature('size1').selection.set([5]);
model.component('comp1').mesh('mesh1').feature('ftri1').feature('size1').set('hmax', 'lambda/4');
model.component('comp1').mesh('mesh1').run;

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').feature('rp1').set('phidisc', 2000);
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').set('axislimits', true);
model.result('pg2').set('rmin', 0);
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc4').active(false);
model.component('comp1').geom('geom1').feature('pc5').active(false);
model.component('comp1').geom('geom1').feature('pc2').set('pos', {'0' 'd'});
model.component('comp1').geom('geom1').feature('pc3').set('pos', {'0' 'd'});
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('pc3').set('pos', {'0' '-d'});
model.component('comp1').geom('geom1').runPre('fin');

model.param.set('d', '2');

model.component('comp1').geom('geom1').run('fin');
model.component('comp1').geom('geom1').feature('c2').set('r', 8);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run;

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc4').active(true);
model.component('comp1').geom('geom1').feature('pc4').set('pos', {'d' '0'});
model.component('comp1').geom('geom1').runPre('fin');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc5').active(true);
model.component('comp1').geom('geom1').feature('pc5').set('pos', {'-d' '0'});
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature.duplicate('pc6', 'pc2');
model.component('comp1').geom('geom1').feature.duplicate('pc7', 'pc3');
model.component('comp1').geom('geom1').feature.duplicate('pc8', 'pc4');
model.component('comp1').geom('geom1').feature.duplicate('pc9', 'pc5');
model.component('comp1').geom('geom1').feature.move('pc6', 5);
model.component('comp1').geom('geom1').nodeGroup('grp2').add('pc6');
model.component('comp1').geom('geom1').feature.move('pc7', 6);
model.component('comp1').geom('geom1').nodeGroup('grp2').add('pc7');
model.component('comp1').geom('geom1').feature.move('pc8', 7);
model.component('comp1').geom('geom1').nodeGroup('grp2').add('pc8');
model.component('comp1').geom('geom1').feature.move('pc9', 8);
model.component('comp1').geom('geom1').nodeGroup('grp2').add('pc9');
model.component('comp1').geom('geom1').feature('pc6').set('pos', {'0' '2*d'});
model.component('comp1').geom('geom1').run('pc6');
model.component('comp1').geom('geom1').feature('pc6').set('pos', {'d' '2*d'});
model.component('comp1').geom('geom1').run('pc6');
model.component('comp1').geom('geom1').feature('pc7').set('pos', {'d' '-2*d'});
model.component('comp1').geom('geom1').run('pc7');
model.component('comp1').geom('geom1').feature('pc8').set('pos', {'2*d' 'd'});
model.component('comp1').geom('geom1').run('pc8');
model.component('comp1').geom('geom1').feature('pc8').set('pos', {'-2*d' 'd'});
model.component('comp1').geom('geom1').run('pc8');
model.component('comp1').geom('geom1').feature('pc9').set('pos', {'-2*d' '-d'});
model.component('comp1').geom('geom1').run('pc9');
model.component('comp1').geom('geom1').feature('pc9').set('pos', {'-2*d' '-2*d'});
model.component('comp1').geom('geom1').feature('pc8').set('pos', {'-2*d' '2*d'});
model.component('comp1').geom('geom1').run('pc8');
model.component('comp1').geom('geom1').feature('pc8').set('pos', {'-d' '2*d'});
model.component('comp1').geom('geom1').run('pc8');
model.component('comp1').geom('geom1').feature('pc9').set('pos', {'-d' '-2*d'});
model.component('comp1').geom('geom1').run('pc9');
model.component('comp1').geom('geom1').run;

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;

model.param.set('q', '8');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc7').active(false);
model.component('comp1').geom('geom1').feature('pc8').active(false);
model.component('comp1').geom('geom1').feature('pc9').active(false);
model.component('comp1').geom('geom1').runPre('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;

model.component('comp1').variable('var4').set('nrefr', '1.25');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc3').active(false);
model.component('comp1').geom('geom1').feature('pc4').active(false);
model.component('comp1').geom('geom1').feature('pc5').active(false);
model.component('comp1').geom('geom1').feature('pc6').active(false);
model.component('comp1').geom('geom1').feature('pc2').set('pos', [0 0]);
model.component('comp1').geom('geom1').runPre('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc3').active(true);
model.component('comp1').geom('geom1').feature('pc4').active(true);
model.component('comp1').geom('geom1').feature('pc5').active(true);
model.component('comp1').geom('geom1').feature('pc6').active(true);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('pc2').set('pos', {'0' 'd'});
model.component('comp1').geom('geom1').runPre('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc6').active(false);

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').variable('var4').set('nrefr', '1.92368');

model.component('comp1').geom('geom1').feature('pc2').set('rot', -173.6062);
model.component('comp1').geom('geom1').run('pc2');
model.component('comp1').geom('geom1').feature('pc4').set('rot', -173.6062);
model.component('comp1').geom('geom1').runPre('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc4').set('rot', 0);
model.component('comp1').geom('geom1').feature('pc2').set('rot', 0);

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc2').setIndex('coord', '(1 + c *sin(4*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc2').setIndex('coord', '-(1 + c *sin(4*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').feature('pc3').setIndex('coord', '(1 + c *sin(4*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc3').setIndex('coord', '-(1 +c *sin(4*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').feature('pc4').setIndex('coord', '-(1 +c *sin(4*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').feature('pc4').setIndex('coord', '(1 + c *sin(4*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc5').setIndex('coord', '(1 + c *sin(4*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc5').setIndex('coord', '-(1 +c *sin(4*t)) * sin(t)', 1);

model.param.set('c', '0');

model.component('comp1').geom('geom1').run('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.param.set('d', '3');

model.component('comp1').geom('geom1').run;

model.component('comp1').variable('var4').set('nrefr', '2');

model.component('comp1').geom('geom1').run('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.label('2dScattering_multi.mph');

model.result('pg2').run;
model.result('pg1').run;

model.component('comp1').geom('geom1').feature('pc3').active(false);
model.component('comp1').geom('geom1').feature('pc4').active(false);
model.component('comp1').geom('geom1').feature('pc5').active(false);
model.component('comp1').geom('geom1').feature('pc2').set('pos', [0 0]);
model.component('comp1').geom('geom1').runPre('fin');

model.sol('sol1').runAll;

model.result('pg1').run;

model.component('comp1').geom('geom1').feature('pc2').set('pos', {[native2unicode(hex2dec({'04' '32'}), 'unicode') ] '0'});
model.component('comp1').geom('geom1').run('c2');
model.component('comp1').geom('geom1').feature('pc2').set('pos', {'d' '0'});
model.component('comp1').geom('geom1').run('pc2');
model.component('comp1').geom('geom1').feature('pc2').set('pos', {'0' 'd'});
model.component('comp1').geom('geom1').run('fin');
model.component('comp1').geom('geom1').run('fin');
model.component('comp1').geom('geom1').run('fin');
model.component('comp1').geom('geom1').feature('pc3').active(true);
model.component('comp1').geom('geom1').feature('pc4').active(true);
model.component('comp1').geom('geom1').feature('pc5').active(true);
model.component('comp1').geom('geom1').run('fin');

model.param.set('d', '4');

model.component('comp1').geom('geom1').run('fin');

model.param.set('d', '5');

model.component('comp1').geom('geom1').run('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.param.set('d', '3');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.param.set('d', '4');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.param.set('c', '0.05');

model.component('comp1').geom('geom1').run('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc3').active(false);
model.component('comp1').geom('geom1').feature('pc4').active(false);
model.component('comp1').geom('geom1').feature('pc5').active(false);

model.param.set('d', '0');

model.component('comp1').geom('geom1').run('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc3').active(true);
model.component('comp1').geom('geom1').feature('pc4').active(true);
model.component('comp1').geom('geom1').feature('pc5').active(true);

model.param.set('d', '4');

model.component('comp1').geom('geom1').run('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.param.set('c', '0');

model.component('comp1').geom('geom1').run('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;

model.component('comp1').variable('var4').set('nrefr', '1.5');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc5').active(false);
model.component('comp1').geom('geom1').feature('pc2').set('pos', [0 0]);
model.component('comp1').geom('geom1').feature('pc4').set('pos', {'0' 'd'});

model.sol('sol1').updateSolution;

model.result('pg1').run;

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc5').active(true);
model.component('comp1').geom('geom1').feature('pc6').active(true);
model.component('comp1').geom('geom1').feature('pc5').set('pos', {'0' '2*d'});
model.component('comp1').geom('geom1').feature('pc6').set('pos', {'0' '-2*d'});
model.component('comp1').geom('geom1').feature('c2').set('r', 14);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('pc6').setIndex('coord', '(1 + c1 *sin(4*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc6').setIndex('coord', '-(1 +c *sin(4*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').feature('pc6').setIndex('coord', '(1 + c*sin(4*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').run('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc6').active(false);
model.component('comp1').geom('geom1').feature('pc5').active(false);
model.component('comp1').geom('geom1').feature('pc3').set('pos', {'d' '0'});
model.component('comp1').geom('geom1').feature('pc4').set('pos', {'-d' '0'});
model.component('comp1').geom('geom1').runPre('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc3').set('pos', {'0' 'd'});
model.component('comp1').geom('geom1').feature('pc4').set('pos', {'0' '-d'});
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('pc5').set('pos', {'d' '0'});
model.component('comp1').geom('geom1').feature('pc6').set('pos', {'-d' '0'});
model.component('comp1').geom('geom1').run('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').variable('var4').set('nrefr', '2');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc4').active(false);
model.component('comp1').geom('geom1').feature('pc3').active(false);
model.component('comp1').geom('geom1').feature('pc5').active(true);
model.component('comp1').geom('geom1').feature('pc6').active(true);

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc4').active(true);
model.component('comp1').geom('geom1').feature('pc3').active(true);
model.component('comp1').geom('geom1').feature('pc5').active(false);
model.component('comp1').geom('geom1').feature('pc6').active(false);
model.component('comp1').geom('geom1').run('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc3').active(false);
model.component('comp1').geom('geom1').feature('pc4').active(false);
model.component('comp1').geom('geom1').feature('pc5').active(true);
model.component('comp1').geom('geom1').feature('pc6').active(true);
model.component('comp1').geom('geom1').runPre('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc3').active(true);
model.component('comp1').geom('geom1').feature('pc4').active(true);
model.component('comp1').geom('geom1').feature('pc5').active(false);
model.component('comp1').geom('geom1').feature('pc6').active(false);
model.component('comp1').geom('geom1').runPre('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc3').active(false);
model.component('comp1').geom('geom1').feature('pc4').active(false);
model.component('comp1').geom('geom1').feature('pc5').active(true);
model.component('comp1').geom('geom1').feature('pc6').active(true);
model.component('comp1').geom('geom1').runPre('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.param.set('q', '15');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.param.set('d', '3');

model.component('comp1').geom('geom1').feature('pc2').active(false);
model.component('comp1').geom('geom1').feature('pc3').active(true);
model.component('comp1').geom('geom1').feature('pc4').active(true);
model.component('comp1').geom('geom1').runPre('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.param.set('d', '8');

model.component('comp1').geom('geom1').feature('c2').set('r', 20);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('c2').set('r', 10);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('c2').set('r', 15);

model.component('comp1').mesh('mesh1').run('ftri2');

model.component('comp1').geom('geom1').runPre('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.param.set('d', '2');

model.component('comp1').geom('geom1').feature('c2').set('r', 8);
model.component('comp1').geom('geom1').runPre('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc3').active(false);
model.component('comp1').geom('geom1').feature('pc4').active(false);
model.component('comp1').geom('geom1').runPre('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc3').active(true);
model.component('comp1').geom('geom1').feature('pc4').active(true);
model.component('comp1').geom('geom1').feature('pc5').active(false);
model.component('comp1').geom('geom1').feature('pc6').active(false);
model.component('comp1').geom('geom1').runPre('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.param.set('d', '3');
model.param.set('q', '10');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc3').active(false);
model.component('comp1').geom('geom1').feature('pc4').active(false);
model.component('comp1').geom('geom1').feature('pc5').active(true);
model.component('comp1').geom('geom1').feature('pc6').active(true);
model.component('comp1').geom('geom1').runPre('fin');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc4').active(true);
model.component('comp1').geom('geom1').feature('pc3').active(true);
model.component('comp1').geom('geom1').runPre('fin');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.label('2dScattering_multi.mph');

model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc6').active(false);
model.component('comp1').geom('geom1').feature('pc5').active(false);
model.component('comp1').geom('geom1').runPre('fin');

model.param.set('d', '2');

model.component('comp1').geom('geom1').run;

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.param.set('d', '1.5');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.param.set('d', '1.05');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.param.set('d', '1.0001');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.param.set('d', '1.5');

model.component('comp1').geom('geom1').feature('pc4').active(false);
model.component('comp1').geom('geom1').feature('pc3').active(false);
model.component('comp1').geom('geom1').feature('pc5').active(true);
model.component('comp1').geom('geom1').feature('pc6').active(true);
model.component('comp1').geom('geom1').runPre('fin');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc5').active(false);
model.component('comp1').geom('geom1').feature('pc6').active(false);
model.component('comp1').geom('geom1').feature('pc4').active(true);
model.component('comp1').geom('geom1').feature('pc3').active(true);

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc3').active(false);
model.component('comp1').geom('geom1').feature('pc4').active(false);
model.component('comp1').geom('geom1').feature('pc5').active(true);
model.component('comp1').geom('geom1').feature('pc6').active(true);
model.component('comp1').geom('geom1').runPre('fin');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc5').active(false);
model.component('comp1').geom('geom1').feature('pc6').active(false);
model.component('comp1').geom('geom1').feature('pc4').active(true);
model.component('comp1').geom('geom1').feature('pc3').active(true);
model.component('comp1').geom('geom1').run;

model.component('comp1').physics('ewfd').prop('BackgroundField').set('Eb', {'0' '0' 'exp(-1j*2*pi/lambda*y)*1 +0 * (real_inc_field(x/1[m], y/1[m]) + 1j * imag_inc_field(x/1[m], y/1[m]))'});

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').physics('ewfd').prop('BackgroundField').set('Eb', {'0' '0' 'exp(1j*2*pi/lambda*y)*1 +0 * (real_inc_field(x/1[m], y/1[m]) + 1j * imag_inc_field(x/1[m], y/1[m]))'});

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').physics('ewfd').prop('BackgroundField').set('Eb', {'0' '0' 'exp(-1j*2*pi/lambda*(x+y)/sqrt(2))*1 +0 * (real_inc_field(x/1[m], y/1[m]) + 1j * imag_inc_field(x/1[m], y/1[m]))'});

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc3').active(false);
model.component('comp1').geom('geom1').feature('pc4').active(false);
model.component('comp1').geom('geom1').feature('pc5').active(true);
model.component('comp1').geom('geom1').feature('pc6').active(true);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run;

model.component('comp1').physics('ewfd').prop('BackgroundField').set('Eb', {'0' '0' 'exp(-1j*2*pi/lambda*(x))*1 +0 * (real_inc_field(x/1[m], y/1[m]) + 1j * imag_inc_field(x/1[m], y/1[m]))'});

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').physics('ewfd').prop('BackgroundField').set('Eb', {'0' '0' 'exp(-1j*2*pi/lambda*(-y))*1 +0 * (real_inc_field(x/1[m], y/1[m]) + 1j * imag_inc_field(x/1[m], y/1[m]))'});

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc5').set('pos', {'d/sqrt(2)' 'd/sqrt(2)'});
model.component('comp1').geom('geom1').feature('pc6').set('pos', {'-d/sqrt(2)' '-d/sqrt(2)'});
model.component('comp1').geom('geom1').run;

model.component('comp1').physics('ewfd').prop('BackgroundField').set('Eb', {'0' '0' 'exp(-1j*2*pi/lambda*(x+y)/sqrt(2))*1 +0 * (real_inc_field(x/1[m], y/1[m]) + 1j * imag_inc_field(x/1[m], y/1[m]))'});

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').physics('ewfd').prop('BackgroundField').set('Eb', {'0' '0' 'exp(-1j*2*pi/lambda*(x))*1 +0 * (real_inc_field(x/1[m], y/1[m]) + 1j * imag_inc_field(x/1[m], y/1[m]))'});

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc2').active(true);
model.component('comp1').geom('geom1').feature('pc5').set('pos', {'0' '2*d'});
model.component('comp1').geom('geom1').feature('pc6').set('pos', {'0' '-2*d'});
model.component('comp1').geom('geom1').run('fin');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').physics('ewfd').prop('BackgroundField').set('Eb', {'0' '0' 'exp(-1j*2*pi/lambda*(y))*1 +0 * (real_inc_field(x/1[m], y/1[m]) + 1j * imag_inc_field(x/1[m], y/1[m]))'});

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.param.set('c', '0.05');

model.component('comp1').geom('geom1').run('fin');

model.component('comp1').physics('ewfd').prop('BackgroundField').set('Eb', {'0' '0' 'exp(-1j*2*pi/lambda*(x))*1 +0 * (real_inc_field(x/1[m], y/1[m]) + 1j * imag_inc_field(x/1[m], y/1[m]))'});

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').physics('ewfd').prop('BackgroundField').set('Eb', {'0' '0' 'exp(-1j*2*pi/lambda*(y))*1 +0 * (real_inc_field(x/1[m], y/1[m]) + 1j * imag_inc_field(x/1[m], y/1[m]))'});

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc5').set('pos', {'0.5' '2*d'});
model.component('comp1').geom('geom1').runPre('fin');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').physics('ewfd').prop('BackgroundField').set('Eb', {'0' '0' 'exp(-1j*2*pi/lambda*(x))*1 +0 * (real_inc_field(x/1[m], y/1[m]) + 1j * imag_inc_field(x/1[m], y/1[m]))'});

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc5').set('pos', {'0.1' '2*d'});

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc5').set('pos', {'d' '2*d'});
model.component('comp1').geom('geom1').runPre('fin');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc6').set('pos', {'-d' '-2*d'});
model.component('comp1').geom('geom1').run('fin');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.param.set('c', '0');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;
model.result('pg2').run;
model.result('pg2').run;

model.param.set('c', '0.03');

model.component('comp1').geom('geom1').run('fin');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.param.set('c', '0.1');

model.component('comp1').geom('geom1').run('fin');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;
model.result('pg1').run;
model.result('pg1').set('windowtitle', 'Graphics');
model.result('pg2').set('windowtitle', 'Graphics');
model.result('pg1').set('window', 'window3');
model.result('pg1').set('windowtitle', 'Plot 3');
model.result('pg1').set('window', 'window3');
model.result('pg1').set('windowtitle', 'Plot 3');
model.result('pg1').run;
model.result('pg1').set('window', 'graphics');
model.result('pg1').set('windowtitle', '');
model.result('pg2').run;
model.result('pg2').run;
model.result('pg1').set('windowtitle', 'Graphics');

model.component('comp1').geom('geom1').nodeGroup('grp2').active(false);
model.component('comp1').geom('geom1').feature.duplicate('pc10', 'pc2');
model.component('comp1').geom('geom1').feature('pc10').active(true);
model.component('comp1').geom('geom1').feature('pc10').setIndex('coord', '(1 + 0.5*sin(2*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc10').setIndex('coord', '-(1 + 0.5*sin(2*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').run('fin');
model.component('comp1').geom('geom1').feature('pc10').setIndex('coord', '-(1 + 0.3*sin(2*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').feature('pc10').setIndex('coord', '(1 + 0.3*sin(2*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').run('fin');
model.component('comp1').geom('geom1').feature('pc10').setIndex('coord', '(1 + 0.25*sin(2*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc10').setIndex('coord', '-(1 + 0.25*sin(2*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').run('fin');
model.component('comp1').geom('geom1').feature('pc10').setIndex('coord', '(1 + 0.25*sin(2*t) + 0.1 * sin(4*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc10').setIndex('coord', '-(1 + 0.25*sin(2*t) + 0.1 * sin(4*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('pc10').setIndex('coord', '(1 + 0.25*sin(2*t)-+ 0.1 * sin(4*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc10').setIndex('coord', '-(1 + 0.25*sin(2*t) - 0.1 * sin(4*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').feature('pc10').setIndex('coord', '(1 + 0.25*sin(2*t)- 0.1 * sin(4*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('pc10').setIndex('coord', '(1 + 0.25*sin(2*t)- 0.1 * cos(4*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc10').setIndex('coord', '-(1 + 0.25*sin(2*t) - 0.1 * cos(4*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('pc10').setIndex('coord', '(1 + 0.25*sin(2*t)- 0.15 * cos(4*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc10').setIndex('coord', '-(1 + 0.25*sin(2*t) - 0.15 * cos(4*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('pc10').setIndex('coord', '(1 + 0.25*sin(2*t)- 0.25 * cos(4*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc10').setIndex('coord', '-(1 + 0.25*sin(2*t) - 0.25 * cos(4*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('pc10').setIndex('coord', '(1 + 0.5*sin(2*t)- 0.25 * cos(4*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc10').setIndex('coord', '-(1 + 0.5*sin(2*t) - 0.25 * cos(4*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').feature('pc10').setIndex('coord', '(1 + 0.5*sin(2*t)- 0.15 * cos(4*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc10').setIndex('coord', '-(1 + 0.5*sin(2*t) - 0.15 * cos(4*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').runPre('fin');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;

model.component('comp1').geom('geom1').feature('pc10').active(false);
model.component('comp1').geom('geom1').nodeGroup('grp2').active(true);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run('pc2');
model.component('comp1').geom('geom1').run('pc3');
model.component('comp1').geom('geom1').feature('pc3').set('pos', {'0' '2*d'});
model.component('comp1').geom('geom1').run('pc3');
model.component('comp1').geom('geom1').feature('pc4').set('pos', {'0' '-2*d'});
model.component('comp1').geom('geom1').run('pc4');
model.component('comp1').geom('geom1').feature('pc5').set('pos', {'2*d' '0'});
model.component('comp1').geom('geom1').run('pc5');
model.component('comp1').geom('geom1').feature('pc6').set('pos', {'-2*d' '0'});
model.component('comp1').geom('geom1').run('pc6');
model.component('comp1').geom('geom1').run('pc6');
model.component('comp1').geom('geom1').run('pc7');
model.component('comp1').geom('geom1').feature('pc7').set('pos', {'2*d' '-2*d'});
model.component('comp1').geom('geom1').run('pc7');
model.component('comp1').geom('geom1').feature('pc7').setIndex('coord', '(1 + c1 *sin(4*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').run('pc6');
model.component('comp1').geom('geom1').feature('pc7').setIndex('coord', '(1 + c *sin(4*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc7').setIndex('coord', '-(1 +c *sin(4*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').run('pc7');
model.component('comp1').geom('geom1').feature('pc8').setIndex('coord', '(1 + c *sin(4*t)) * cos(t)', 0);
model.component('comp1').geom('geom1').feature('pc8').setIndex('coord', '-(1 + c *sin(4*t)) * sin(t)', 1);
model.component('comp1').geom('geom1').run('pc8');
model.component('comp1').geom('geom1').feature('pc8').set('pos', {'-2*d' '2*d'});
model.component('comp1').geom('geom1').run('pc8');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;

model.component('comp1').geom('geom1').feature('pc9').active(false);
model.component('comp1').geom('geom1').run('fin');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.param.set('d', '2');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;

model.component('comp1').geom('geom1').feature('c2').set('r', 10);
model.component('comp1').geom('geom1').runPre('fin');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.param.set('q', '30');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('c2').set('r', 14);
model.component('comp1').geom('geom1').runPre('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;
model.result('pg1').run;

model.param.set('q', '15');
model.param.set('c', '0.02');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').geom('geom1').feature('pc7').active(false);
model.component('comp1').geom('geom1').feature('pc8').active(false);
model.component('comp1').geom('geom1').feature('pc6').active(false);
model.component('comp1').geom('geom1').run('fin');

model.component('comp1').mesh('mesh1').run('ftri2');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.param.set('q', '5');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.param.set('q', '10');
model.param.set('d', '1.1');

model.component('comp1').geom('geom1').run('fin');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').variable('var4').set('nrefr', '2+0.05j');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').variable('var4').set('nrefr', '2+0.001j');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').variable('var4').set('nrefr', '2+0.9j');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.component('comp1').variable('var4').set('nrefr', '2-0.9j');

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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

model.result('pg1').run;
model.result('pg2').run;

model.label('2dScattering_multi.mph');

model.result('pg2').run;

model.component('comp1').geom('geom1').nodeGroup('grp2').active(false);
model.component('comp1').geom('geom1').nodeGroup.remove('grp2');
model.component('comp1').geom('geom1').nodeGroup.remove('grp1');
model.component('comp1').geom('geom1').feature.remove('rot1');
model.component('comp1').geom('geom1').feature.remove('c4');
model.component('comp1').geom('geom1').feature.remove('pc10');
model.component('comp1').geom('geom1').feature('c3').active(true);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').create('sel1', 'ExplicitSelection');
model.component('comp1').geom('geom1').feature('sel1').selection('selection').set('c3', 1);
model.component('comp1').geom('geom1').run('sel1');
model.component('comp1').geom('geom1').run;

model.component('comp1').physics('ewfd').prop('BackgroundField').set('WaveType', 'GaussianBeam');
model.component('comp1').physics('ewfd').prop('BackgroundField').set('w0', 'w0');

model.param.set('w0', 'pi [m] / q');
model.param.set('q', '1');

model.component('comp1').mesh('mesh1').feature('ftri2').selection.named('geom1_sel1');

model.component('comp1').variable('var4').selection.named('geom1_sel1');
model.component('comp1').variable('var4').set('nrefr', 'nrefr0');

model.param.set('nrefr0', '2.5');

model.component('comp1').geom('geom1').run('fin');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg2').run;

model.label('sca2d.mph');

model.result('pg2').run;

model.component('comp1').variable.remove('var2');
model.component('comp1').variable.remove('var3');

model.component('comp1').func.remove('int1');

model.component('comp1').mesh.remove('mesh1');

model.component.create('comp2', true);

model.component('comp2').geom.create('geom2', 2);

model.component('comp2').mesh.create('mesh1');

model.component('comp2').geom('geom2').run;

model.component.remove('comp2');

model.component('comp1').mesh.create('mesh1');
model.component('comp1').mesh('mesh1').create('map1', 'Map');
model.component('comp1').mesh('mesh1').feature('map1').selection.geom('geom1', 2);
model.component('comp1').mesh('mesh1').feature('map1').selection.set([1 2 3 4]);
model.component('comp1').mesh('mesh1').feature('map1').create('size1', 'Size');
model.component('comp1').mesh('mesh1').feature('map1').feature('size1').set('custom', true);
model.component('comp1').mesh('mesh1').feature('map1').feature('size1').set('hmaxactive', true);
model.component('comp1').mesh('mesh1').feature('map1').feature('size1').set('hmax', 'lambda/4');
model.component('comp1').mesh('mesh1').run('map1');

model.component('comp1').geom('geom1').feature('c2').setIndex('layer', 2, 0);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run;

model.component('comp1').mesh('mesh1').run('map1');
model.component('comp1').mesh('mesh1').feature('map1').feature('size1').set('hmax', 'lambda/6');
model.component('comp1').mesh('mesh1').run('map1');
model.component('comp1').mesh('mesh1').create('ftri1', 'FreeTri');
model.component('comp1').mesh('mesh1').feature('ftri1').selection.geom('geom1', 2);
model.component('comp1').mesh('mesh1').feature('ftri1').selection.set([5]);
model.component('comp1').mesh('mesh1').feature('ftri1').create('size1', 'Size');
model.component('comp1').mesh('mesh1').feature('ftri1').feature('size1').set('custom', true);
model.component('comp1').mesh('mesh1').feature('ftri1').feature('size1').set('hmaxactive', true);
model.component('comp1').mesh('mesh1').feature('ftri1').feature('size1').set('hmax', 'lambda/6');
model.component('comp1').mesh('mesh1').run;
model.component('comp1').mesh('mesh1').create('ftri2', 'FreeTri');
model.component('comp1').mesh('mesh1').feature.move('ftri2', 2);
model.component('comp1').mesh('mesh1').feature('ftri2').selection.geom('geom1', 2);
model.component('comp1').mesh('mesh1').feature('ftri2').selection.named('geom1_sel1');
model.component('comp1').mesh('mesh1').feature('ftri2').create('size1', 'Size');
model.component('comp1').mesh('mesh1').feature('ftri2').feature('size1').set('custom', true);
model.component('comp1').mesh('mesh1').feature('ftri2').feature('size1').set('hmaxactive', true);
model.component('comp1').mesh('mesh1').feature('ftri2').feature('size1').set('hmax', 'lambda / nrefr0 / 4');
model.component('comp1').mesh('mesh1').feature('ftri1').feature('size1').set('hmax', 'lambda/4');
model.component('comp1').mesh('mesh1').run;

model.sol('sol1').clearSolutionData;
model.sol.remove('sol1');
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
model.sol('sol1').feature('s1').feature('p1').set('punit', {[native2unicode(hex2dec({'00' 'b5'}), 'unicode') 'm']});
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

out = model;
